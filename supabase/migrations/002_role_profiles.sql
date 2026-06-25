-- 002_role_profiles.sql
-- Stored procedures, trigger functions, and onboarding flow helpers for Lifecycle.

create or replace function public.generate_lc_id() returns text language plpgsql as $$
begin
  return 'LC-' || to_char(now(), 'YYYY') || '-' || upper(substr(md5(gen_random_uuid()::text), 1, 8));
end;
$$;

create or replace function public.assign_lc_id() returns trigger as $$
begin
  if new.lc_id is null then
    new.lc_id := public.generate_lc_id();
  end if;
  return new;
end;
$$ language plpgsql;

create trigger profiles_assign_lc_id
  before insert on public.profiles
  for each row execute function public.assign_lc_id();

create or replace function public.recompute_profile_rank() returns trigger as $$
declare
  grade_avg numeric;
  sport_rating numeric;
  new_rank text := 'Bronze';
begin
  select avg(score) into grade_avg from public.grade_logs where student_profile_id = new.student_profile_id;
  select avg(rating) into sport_rating from public.sport_stats where student_profile_id = new.student_profile_id;
  if grade_avg is null then grade_avg := 0; end if;
  if sport_rating is null then sport_rating := 0; end if;

  if grade_avg >= 85 or sport_rating >= 8 then
    new_rank := 'Diamond';
  elsif grade_avg >= 75 or sport_rating >= 7 then
    new_rank := 'Platinum';
  elsif grade_avg >= 60 or sport_rating >= 5 then
    new_rank := 'Gold';
  else
    new_rank := 'Silver';
  end if;

  update public.profiles
  set rank = new_rank,
      score = greatest(grade_avg, sport_rating)
  where id = (select profile_id from public.student_profiles where profile_id = new.student_profile_id);

  return new;
end;
$$ language plpgsql;

create trigger grade_logs_rank_recompute
  after insert or update on public.grade_logs
  for each row execute function public.recompute_profile_rank();

create trigger sport_stats_rank_recompute
  after insert or update on public.sport_stats
  for each row execute function public.recompute_profile_rank();

create or replace function public.increment_profile_view_count() returns trigger as $$
begin
  update public.profiles
  set view_count = view_count + 1
  where id = (select profile_id from public.student_profiles where profile_id = new.student_profile_id);
  return new;
end;
$$ language plpgsql;

create trigger scout_views_increment_profile_views
  after insert on public.scout_views
  for each row execute function public.increment_profile_view_count();

create or replace function public.update_student_streak() returns trigger as $$
declare
  last_date date;
  yesterday date := (current_date - interval '1 day')::date;
  current_streak int;
  profile_id uuid := new.student_profile_id;
  activity_date date;
begin
  if TG_TABLE_NAME = 'study_hours' then
    activity_date := new.activity_date;
  elsif TG_TABLE_NAME = 'recovery_logs' then
    activity_date := new.recovery_date;
  elsif TG_TABLE_NAME = 'training_sessions' then
    activity_date := new.session_date;
  else
    return new;
  end if;

  select last_active_at::date, current_streak into last_date, current_streak
  from public.profiles where id = profile_id;

  if last_date is null or last_date < yesterday then
    current_streak := 1;
  elsif last_date = yesterday then
    current_streak := current_streak + 1;
  else
    current_streak := current_streak;
  end if;

  update public.profiles
  set current_streak = current_streak,
      last_active_at = activity_date::timestamptz
  where id = profile_id;

  return new;
end;
$$ language plpgsql;

create trigger study_hours_streak_update
  after insert on public.study_hours
  for each row execute function public.update_student_streak();

create trigger recovery_logs_streak_update
  after insert on public.recovery_logs
  for each row execute function public.update_student_streak();

create trigger training_sessions_streak_update
  after insert on public.training_sessions
  for each row execute function public.update_student_streak();

create or replace function public.register_lifecycle_profile(
  p_role text,
  p_profile jsonb,
  p_role_payload jsonb
) returns uuid language plpgsql as $$
declare
  new_profile_id uuid;
  guardian_id uuid;
begin
  if p_role not in ('student','teacher','coach','admin','scout') then
    raise exception 'Unsupported role: %', p_role;
  end if;

  insert into public.profiles (
    auth_uid,
    email,
    full_name,
    first_name,
    last_name,
    dob,
    nationality,
    phone,
    address,
    school_id,
    role,
    onboarding_completed,
    profile_photo
  ) values (
    auth.uid(),
    p_profile ->> 'email',
    p_profile ->> 'full_name',
    p_profile ->> 'first_name',
    p_profile ->> 'last_name',
    (p_profile ->> 'dob')::date,
    p_profile ->> 'nationality',
    p_profile ->> 'phone',
    p_profile ->> 'address',
    (p_profile ->> 'school_id')::uuid,
    p_role,
    true,
    p_profile ->> 'profile_photo'
  ) returning id into new_profile_id;

  if p_role = 'student' then
    if p_role_payload ? 'guardian' then
      insert into public.guardians (profile_id, guardian_name, relationship, phone, email, address)
      values (
        new_profile_id,
        p_role_payload -> 'guardian' ->> 'guardian_name',
        p_role_payload -> 'guardian' ->> 'relationship',
        p_role_payload -> 'guardian' ->> 'phone',
        p_role_payload -> 'guardian' ->> 'email',
        p_role_payload -> 'guardian' ->> 'address'
      ) returning id into guardian_id;
    end if;

    insert into public.student_profiles (
      profile_id,
      enrollment_number,
      year_group,
      house,
      guardian_id,
      career_interest,
      academic_status,
      grade_point_avg,
      student_rank,
      team_id
    ) values (
      new_profile_id,
      p_role_payload ->> 'enrollment_number',
      p_role_payload ->> 'year_group',
      p_role_payload ->> 'house',
      guardian_id,
      p_role_payload ->> 'career_interest',
      p_role_payload ->> 'academic_status',
      nullif(p_role_payload ->> 'grade_point_avg', '')::numeric,
      p_role_payload ->> 'student_rank',
      nullif(p_role_payload ->> 'team_id', '')::uuid
    );
  elsif p_role = 'teacher' then
    insert into public.teacher_profiles (
      profile_id,
      teacher_code,
      subject_area,
      department,
      hire_date,
      years_experience,
      certifications,
      office_location
    ) values (
      new_profile_id,
      p_role_payload ->> 'teacher_code',
      p_role_payload ->> 'subject_area',
      p_role_payload ->> 'department',
      (p_role_payload ->> 'hire_date')::date,
      nullif(p_role_payload ->> 'years_experience', '')::int,
      p_role_payload ->> 'certifications',
      p_role_payload ->> 'office_location'
    );
  elsif p_role = 'coach' then
    insert into public.coach_profiles (
      profile_id,
      coach_code,
      sport_specialty,
      certifications,
      region,
      active_teams
    ) values (
      new_profile_id,
      p_role_payload ->> 'coach_code',
      p_role_payload ->> 'sport_specialty',
      p_role_payload ->> 'certifications',
      p_role_payload ->> 'region',
      nullif(p_role_payload ->> 'active_teams', '')::int
    );
  elsif p_role = 'admin' then
    insert into public.admin_profiles (
      profile_id,
      admin_level,
      department,
      permissions
    ) values (
      new_profile_id,
      p_role_payload ->> 'admin_level',
      p_role_payload ->> 'department',
      coalesce(p_role_payload -> 'permissions', '{}'::jsonb)
    );
  elsif p_role = 'scout' then
    insert into public.scout_profiles (
      profile_id,
      organization,
      region_focus,
      scout_rank,
      saved_prospect_count
    ) values (
      new_profile_id,
      p_role_payload ->> 'organization',
      p_role_payload ->> 'region_focus',
      p_role_payload ->> 'scout_rank',
      nullif(p_role_payload ->> 'saved_prospect_count', '')::int
    );
  end if;

  return new_profile_id;
end;
$$;

create or replace function public.log_grade(
  p_student_profile_id uuid,
  p_teacher_profile_id uuid,
  p_class_id uuid,
  p_subject_id uuid,
  p_grade text,
  p_score numeric,
  p_comments text
) returns uuid language plpgsql as $$
declare
  log_id uuid;
begin
  insert into public.grade_logs (
    student_profile_id,
    teacher_profile_id,
    class_id,
    subject_id,
    grade,
    score,
    comments
  ) values (
    p_student_profile_id,
    p_teacher_profile_id,
    p_class_id,
    p_subject_id,
    p_grade,
    p_score,
    p_comments
  ) returning id into log_id;
  return log_id;
end;
$$;

create or replace function public.log_study_hours(
  p_student_profile_id uuid,
  p_activity_date date,
  p_hours numeric,
  p_activity text,
  p_session_type text
) returns uuid language plpgsql as $$
declare
  record_id uuid;
begin
  insert into public.study_hours (
    student_profile_id,
    activity_date,
    hours,
    activity,
    session_type
  ) values (
    p_student_profile_id,
    p_activity_date,
    p_hours,
    p_activity,
    p_session_type
  ) returning id into record_id;
  return record_id;
end;
$$;

create or replace function public.log_recovery(
  p_student_profile_id uuid,
  p_recovery_date date,
  p_recovery_type text,
  p_duration_minutes int,
  p_quality_rating int,
  p_notes text
) returns uuid language plpgsql as $$
declare
  record_id uuid;
begin
  insert into public.recovery_logs (
    student_profile_id,
    recovery_date,
    recovery_type,
    duration_minutes,
    quality_rating,
    notes
  ) values (
    p_student_profile_id,
    p_recovery_date,
    p_recovery_type,
    p_duration_minutes,
    p_quality_rating,
    p_notes
  ) returning id into record_id;
  return record_id;
end;
$$;

create or replace function public.log_training_session(
  p_coach_profile_id uuid,
  p_team_id uuid,
  p_session_date date,
  p_duration_minutes int,
  p_focus_area text,
  p_intensity text,
  p_notes text
) returns uuid language plpgsql as $$
declare
  record_id uuid;
begin
  insert into public.training_sessions (
    coach_profile_id,
    team_id,
    session_date,
    duration_minutes,
    focus_area,
    intensity,
    notes
  ) values (
    p_coach_profile_id,
    p_team_id,
    p_session_date,
    p_duration_minutes,
    p_focus_area,
    p_intensity,
    p_notes
  ) returning id into record_id;
  return record_id;
end;
$$;

create or replace function public.post_announcement(
  p_author_profile_id uuid,
  p_title text,
  p_body text,
  p_target_roles text[],
  p_target_school_id uuid,
  p_is_public boolean,
  p_expires_at timestamptz
) returns uuid language plpgsql as $$
declare
  announcement_id uuid;
begin
  insert into public.announcements (
    author_profile_id,
    title,
    body,
    target_roles,
    target_school_id,
    is_public,
    expires_at
  ) values (
    p_author_profile_id,
    p_title,
    p_body,
    p_target_roles,
    p_target_school_id,
    p_is_public,
    p_expires_at
  ) returning id into announcement_id;
  return announcement_id;
end;
$$;

create or replace function public.reply_announcement(
  p_announcement_id uuid,
  p_profile_id uuid,
  p_body text
) returns uuid language plpgsql as $$
declare
  reply_id uuid;
begin
  insert into public.announcement_replies (
    announcement_id,
    profile_id,
    body
  ) values (
    p_announcement_id,
    p_profile_id,
    p_body
  ) returning id into reply_id;
  return reply_id;
end;
$$;

create or replace function public.mark_announcement_read(
  p_announcement_id uuid,
  p_profile_id uuid
) returns boolean language plpgsql as $$
begin
  insert into public.announcement_reads (announcement_id, profile_id) values (p_announcement_id, p_profile_id)
  on conflict (announcement_id, profile_id) do update set read_at = now();
  return true;
end;
$$;

create or replace function public.join_club(
  p_club_id uuid,
  p_profile_id uuid,
  p_role text
) returns uuid language plpgsql as $$
declare
  membership_id uuid;
begin
  insert into public.club_memberships (club_id, profile_id, role)
  values (p_club_id, p_profile_id, p_role)
  on conflict (club_id, profile_id) do update set status = 'active', role = excluded.role;
  select id into membership_id from public.club_memberships where club_id = p_club_id and profile_id = p_profile_id;
  return membership_id;
end;
$$;

create or replace function public.join_community(
  p_community_id uuid,
  p_profile_id uuid,
  p_role text
) returns uuid language plpgsql as $$
declare
  membership_id uuid;
begin
  insert into public.community_memberships (community_id, profile_id, role)
  values (p_community_id, p_profile_id, p_role)
  on conflict (community_id, profile_id) do update set role = excluded.role;
  select id into membership_id from public.community_memberships where community_id = p_community_id and profile_id = p_profile_id;
  return membership_id;
end;
$$;

create or replace function public.rsvp_event(
  p_event_id uuid,
  p_profile_id uuid,
  p_status text
) returns uuid language plpgsql as $$
declare
  rsvp_id uuid;
begin
  insert into public.event_rsvps (event_id, profile_id, status)
  values (p_event_id, p_profile_id, p_status)
  on conflict (event_id, profile_id) do update set status = excluded.status, responded_at = now();
  select id into rsvp_id from public.event_rsvps where event_id = p_event_id and profile_id = p_profile_id;
  return rsvp_id;
end;
$$;

create or replace function public.create_match_plan(
  p_team_id uuid,
  p_coach_profile_id uuid,
  p_opponent text,
  p_match_date date,
  p_location text,
  p_plan_notes text,
  p_status text
) returns uuid language plpgsql as $$
declare
  match_plan_id uuid;
begin
  insert into public.match_plans (team_id, coach_profile_id, opponent, match_date, location, plan_notes, status)
  values (p_team_id, p_coach_profile_id, p_opponent, p_match_date, p_location, p_plan_notes, p_status)
  returning id into match_plan_id;
  return match_plan_id;
end;
$$;

create or replace function public.add_match_plan_lineup(
  p_match_plan_id uuid,
  p_student_profile_id uuid,
  p_position text,
  p_starter boolean,
  p_notes text
) returns uuid language plpgsql as $$
declare
  lineup_id uuid;
begin
  insert into public.match_plan_lineups (match_plan_id, student_profile_id, position, starter, notes)
  values (p_match_plan_id, p_student_profile_id, p_position, p_starter, p_notes)
  returning id into lineup_id;
  return lineup_id;
end;
$$;

create or replace function public.add_squad_message(
  p_match_plan_id uuid,
  p_sender_profile_id uuid,
  p_message text
) returns uuid language plpgsql as $$
declare
  message_id uuid;
begin
  insert into public.squad_messages (match_plan_id, sender_profile_id, message)
  values (p_match_plan_id, p_sender_profile_id, p_message)
  returning id into message_id;
  return message_id;
end;
$$;

create or replace function public.save_prospect(
  p_scout_profile_id uuid,
  p_student_profile_id uuid,
  p_priority int,
  p_notes text
) returns uuid language plpgsql as $$
declare
  prospect_id uuid;
begin
  insert into public.saved_prospects (scout_profile_id, student_profile_id, priority, notes)
  values (p_scout_profile_id, p_student_profile_id, p_priority, p_notes)
  on conflict (scout_profile_id, student_profile_id) do update set priority = excluded.priority, notes = excluded.notes;
  select id into prospect_id from public.saved_prospects where scout_profile_id = p_scout_profile_id and student_profile_id = p_student_profile_id;
  return prospect_id;
end;
$$;

create or replace function public.get_student_portal(p_profile_id uuid) returns jsonb language plpgsql as $$
declare
  result jsonb;
begin
  select jsonb_build_object(
    'profile', to_jsonb(p) - 'auth_uid',
    'student', to_jsonb(s),
    'goals', coalesce((select jsonb_agg(to_jsonb(g)) from public.goals g where g.student_profile_id = p_profile_id), '[]'::jsonb),
    'grade_logs', coalesce((select jsonb_agg(to_jsonb(g)) from public.grade_logs g where g.student_profile_id = p_profile_id), '[]'::jsonb),
    'study_hours', coalesce((select jsonb_agg(to_jsonb(h)) from public.study_hours h where h.student_profile_id = p_profile_id order by h.activity_date desc limit 20), '[]'::jsonb),
    'recovery_logs', coalesce((select jsonb_agg(to_jsonb(r)) from public.recovery_logs r where r.student_profile_id = p_profile_id order by r.recovery_date desc limit 20), '[]'::jsonb),
    'streak', p.current_streak
  ) into result
  from public.profiles p
  join public.student_profiles s on s.profile_id = p_profile_id
  where p.id = p_profile_id;

  return result;
end;
$$;

create or replace function public.get_teacher_portal(p_profile_id uuid) returns jsonb language plpgsql as $$
declare
  result jsonb;
begin
  select jsonb_build_object(
    'profile', to_jsonb(p) - 'auth_uid',
    'teacher', to_jsonb(t),
    'classes', coalesce((select jsonb_agg(to_jsonb(c)) from public.classes c where c.teacher_profile_id = p_profile_id), '[]'::jsonb),
    'lesson_logs', coalesce((select jsonb_agg(to_jsonb(l)) from public.teacher_logs l where l.teacher_profile_id = p_profile_id and l.log_type = 'lesson'), '[]'::jsonb),
    'marking_logs', coalesce((select jsonb_agg(to_jsonb(l)) from public.teacher_logs l where l.teacher_profile_id = p_profile_id and l.log_type = 'marking'), '[]'::jsonb),
    'project_logs', coalesce((select jsonb_agg(to_jsonb(l)) from public.teacher_logs l where l.teacher_profile_id = p_profile_id and l.log_type = 'project'), '[]'::jsonb)
  ) into result
  from public.profiles p
  join public.teacher_profiles t on t.profile_id = p_profile_id
  where p.id = p_profile_id;

  return result;
end;
$$;

create or replace function public.get_coach_portal(p_profile_id uuid) returns jsonb language plpgsql as $$
declare
  result jsonb;
begin
  select jsonb_build_object(
    'profile', to_jsonb(p) - 'auth_uid',
    'coach', to_jsonb(c),
    'teams', coalesce((select jsonb_agg(to_jsonb(t)) from public.teams t where t.coach_profile_id = p_profile_id), '[]'::jsonb),
    'training_sessions', coalesce((select jsonb_agg(to_jsonb(s)) from public.training_sessions s where s.coach_profile_id = p_profile_id order by s.session_date desc limit 20), '[]'::jsonb),
    'match_plans', coalesce((select jsonb_agg(to_jsonb(m)) from public.match_plans m where m.coach_profile_id = p_profile_id order by m.match_date desc limit 20), '[]'::jsonb)
  ) into result
  from public.profiles p
  join public.coach_profiles c on c.profile_id = p_profile_id
  where p.id = p_profile_id;

  return result;
end;
$$;

create or replace function public.get_admin_portal(p_profile_id uuid) returns jsonb language plpgsql as $$
declare
  result jsonb;
begin
  select jsonb_build_object(
    'profile', to_jsonb(p) - 'auth_uid',
    'admin', to_jsonb(a),
    'announcements', coalesce((select jsonb_agg(to_jsonb(n)) from public.announcements n order by n.created_at desc limit 50), '[]'::jsonb),
    'clubs', coalesce((select jsonb_agg(to_jsonb(c)) from public.clubs c order by c.created_at desc limit 50), '[]'::jsonb),
    'events', coalesce((select jsonb_agg(to_jsonb(e)) from public.events e order by e.event_start desc limit 50), '[]'::jsonb)
  ) into result
  from public.profiles p
  join public.admin_profiles a on a.profile_id = p_profile_id
  where p.id = p_profile_id;

  return result;
end;
$$;

create or replace function public.get_scout_portal(p_profile_id uuid) returns jsonb language plpgsql as $$
declare
  result jsonb;
begin
  select jsonb_build_object(
    'profile', to_jsonb(p) - 'auth_uid',
    'scout', to_jsonb(s),
    'saved_prospects', coalesce((select jsonb_agg(to_jsonb(sp)) from public.saved_prospects sp where sp.scout_profile_id = p_profile_id order by sp.saved_at desc), '[]'::jsonb),
    'views', coalesce((select jsonb_agg(to_jsonb(v)) from public.scout_views v where v.scout_profile_id = p_profile_id order by v.viewed_at desc limit 50), '[]'::jsonb)
  ) into result
  from public.profiles p
  join public.scout_profiles s on s.profile_id = p_profile_id
  where p.id = p_profile_id;

  return result;
end;
$$;
