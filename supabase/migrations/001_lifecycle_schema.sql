-- 001_lifecycle_schema.sql
-- Core Lifecycle schema for Supabase / PostgreSQL.

create extension if not exists pgcrypto;

-- Schools and guardian lookup.
create table if not exists public.schools (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  code text unique not null,
  address text,
  city text,
  country text,
  established_year int,
  website text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_uid uuid unique not null references auth.users(id) on delete cascade,
  lc_id text unique,
  email text not null,
  full_name text not null,
  first_name text,
  last_name text,
  dob date,
  nationality text,
  phone text,
  address text,
  school_id uuid references public.schools(id),
  role text not null check (role in ('student','teacher','coach','admin','scout')),
  onboarding_completed boolean not null default false,
  profile_photo text,
  current_streak int not null default 0,
  last_active_at timestamptz,
  view_count int not null default 0,
  rank text,
  score numeric default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.guardians (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  guardian_name text not null,
  relationship text not null,
  phone text,
  email text,
  address text,
  created_at timestamptz not null default now(),
  unique(profile_id)
);

create table if not exists public.teacher_profiles (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  teacher_code text unique,
  subject_area text,
  department text,
  hire_date date,
  years_experience int,
  certifications text,
  office_location text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.coach_profiles (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  coach_code text unique,
  sport_specialty text,
  certifications text,
  region text,
  active_teams int default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_profiles (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  admin_level text not null default 'standard',
  department text,
  permissions jsonb default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.scout_profiles (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  organization text,
  region_focus text,
  scout_rank text,
  saved_prospect_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.teams (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  name text not null,
  coach_profile_id uuid references public.coach_profiles(profile_id) on delete set null,
  sport text,
  season text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.student_profiles (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  enrollment_number text unique,
  year_group text,
  house text,
  guardian_id uuid references public.guardians(id) on delete set null,
  career_interest text,
  academic_status text,
  grade_point_avg numeric,
  student_rank text,
  team_id uuid references public.teams(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.classes (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  subject_id uuid references public.subjects(id) on delete set null,
  name text not null,
  term text,
  teacher_profile_id uuid references public.teacher_profiles(profile_id) on delete set null,
  capacity int default 30,
  schedule jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.class_enrolments (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.classes(id) on delete cascade,
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  enrolled_at timestamptz not null default now(),
  active boolean not null default true,
  status text not null default 'enrolled',
  unique(class_id, student_profile_id)
);

create table if not exists public.careers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  pathway text,
  industry text,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.career_selections (
  id uuid primary key default gen_random_uuid(),
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  career_id uuid not null references public.careers(id) on delete cascade,
  selected_at timestamptz not null default now(),
  priority int not null default 1,
  status text not null default 'pending'
);

create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  title text not null,
  description text,
  category text,
  target_date date,
  progress numeric default 0,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.grade_logs (
  id uuid primary key default gen_random_uuid(),
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  teacher_profile_id uuid references public.teacher_profiles(profile_id) on delete set null,
  class_id uuid references public.classes(id) on delete set null,
  subject_id uuid references public.subjects(id) on delete set null,
  grade text,
  score numeric,
  comments text,
  logged_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.study_hours (
  id uuid primary key default gen_random_uuid(),
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  activity_date date not null,
  hours numeric not null,
  activity text,
  session_type text,
  created_at timestamptz not null default now()
);

create table if not exists public.recovery_logs (
  id uuid primary key default gen_random_uuid(),
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  recovery_date date not null,
  recovery_type text not null,
  duration_minutes int,
  quality_rating int check (quality_rating between 1 and 10),
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.training_sessions (
  id uuid primary key default gen_random_uuid(),
  coach_profile_id uuid not null references public.coach_profiles(profile_id) on delete cascade,
  team_id uuid references public.teams(id) on delete set null,
  session_date date not null,
  duration_minutes int,
  focus_area text,
  intensity text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.sport_stats (
  id uuid primary key default gen_random_uuid(),
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  team_id uuid references public.teams(id) on delete set null,
  season text,
  matches_played int default 0,
  goals int default 0,
  assists int default 0,
  wins int default 0,
  losses int default 0,
  rating numeric default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.teams (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  name text not null,
  coach_profile_id uuid references public.coach_profiles(profile_id) on delete set null,
  sport text,
  season text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.team_members (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  role text,
  joined_at timestamptz not null default now(),
  active boolean not null default true,
  unique(team_id, student_profile_id)
);

create table if not exists public.match_plans (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  coach_profile_id uuid not null references public.coach_profiles(profile_id) on delete cascade,
  opponent text,
  match_date date,
  location text,
  plan_notes text,
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.match_plan_lineups (
  id uuid primary key default gen_random_uuid(),
  match_plan_id uuid not null references public.match_plans(id) on delete cascade,
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  position text,
  starter boolean not null default false,
  notes text
);

create table if not exists public.squad_messages (
  id uuid primary key default gen_random_uuid(),
  match_plan_id uuid not null references public.match_plans(id) on delete cascade,
  sender_profile_id uuid not null references public.profiles(id) on delete cascade,
  message text not null,
  sent_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  author_profile_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  target_roles text[] not null default array['student','teacher','coach','admin','scout'],
  target_school_id uuid references public.schools(id) on delete set null,
  created_at timestamptz not null default now(),
  expires_at timestamptz,
  is_public boolean not null default false,
  view_count int not null default 0
);

create table if not exists public.announcement_replies (
  id uuid primary key default gen_random_uuid(),
  announcement_id uuid not null references public.announcements(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.announcement_reads (
  id uuid primary key default gen_random_uuid(),
  announcement_id uuid not null references public.announcements(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  read_at timestamptz not null default now(),
  unique(announcement_id, profile_id)
);

create table if not exists public.clubs (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  name text not null,
  description text,
  coach_profile_id uuid references public.coach_profiles(profile_id) on delete set null,
  created_at timestamptz not null default now(),
  active boolean not null default true
);

create table if not exists public.club_memberships (
  id uuid primary key default gen_random_uuid(),
  club_id uuid not null references public.clubs(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  role text not null default 'member',
  status text not null default 'active',
  unique(club_id, profile_id)
);

create table if not exists public.communities (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  name text not null,
  description text,
  category text,
  created_at timestamptz not null default now(),
  is_public boolean not null default true
);

create table if not exists public.community_memberships (
  id uuid primary key default gen_random_uuid(),
  community_id uuid not null references public.communities(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  role text not null default 'member',
  unique(community_id, profile_id)
);

create table if not exists public.community_posts (
  id uuid primary key default gen_random_uuid(),
  community_id uuid not null references public.communities(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  parent_post_id uuid references public.community_posts(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  title text not null,
  description text,
  location text,
  event_start timestamptz not null,
  event_end timestamptz,
  created_by uuid not null references public.profiles(id) on delete cascade,
  capacity int,
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.event_rsvps (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.events(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'going',
  responded_at timestamptz not null default now(),
  unique(event_id, profile_id)
);

create table if not exists public.scout_views (
  id uuid primary key default gen_random_uuid(),
  scout_profile_id uuid not null references public.scout_profiles(profile_id) on delete cascade,
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  viewed_at timestamptz not null default now(),
  view_type text not null default 'profile',
  notes text
);

create table if not exists public.saved_prospects (
  id uuid primary key default gen_random_uuid(),
  scout_profile_id uuid not null references public.scout_profiles(profile_id) on delete cascade,
  student_profile_id uuid not null references public.student_profiles(profile_id) on delete cascade,
  saved_at timestamptz not null default now(),
  priority int not null default 1,
  notes text,
  unique(scout_profile_id, student_profile_id)
);

create table if not exists public.teacher_logs (
  id uuid primary key default gen_random_uuid(),
  teacher_profile_id uuid not null references public.teacher_profiles(profile_id) on delete cascade,
  class_id uuid references public.classes(id) on delete set null,
  log_type text not null check (log_type in ('lesson','marking','project')),
  title text,
  details jsonb,
  logged_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

-- Trigger helper for updated_at.
create or replace function public.set_updated_at() returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

create trigger student_profiles_updated_at
  before update on public.student_profiles
  for each row execute function public.set_updated_at();

create trigger teacher_profiles_updated_at
  before update on public.teacher_profiles
  for each row execute function public.set_updated_at();

create trigger coach_profiles_updated_at
  before update on public.coach_profiles
  for each row execute function public.set_updated_at();

create trigger admin_profiles_updated_at
  before update on public.admin_profiles
  for each row execute function public.set_updated_at();

create trigger scout_profiles_updated_at
  before update on public.scout_profiles
  for each row execute function public.set_updated_at();

-- RLS helpers.
create or replace function public.current_app_role() returns text stable as $$
begin
  return current_setting('request.jwt.claims.app_role', true);
end;
$$ language plpgsql;

create or replace function public.current_profile_id() returns uuid stable as $$
select id from public.profiles where auth_uid = auth.uid() limit 1;
$$ language sql;

create or replace function public.is_admin() returns boolean stable as $$
select public.current_app_role() = 'admin';
$$ language sql;

create or replace function public.is_role(role text) returns boolean stable as $$
select public.current_app_role() = role;
$$ language sql;

-- Enable RLS for all major tables.
alter table public.profiles enable row level security;
alter table public.student_profiles enable row level security;
alter table public.teacher_profiles enable row level security;
alter table public.coach_profiles enable row level security;
alter table public.admin_profiles enable row level security;
alter table public.scout_profiles enable row level security;
alter table public.subjects enable row level security;
alter table public.classes enable row level security;
alter table public.class_enrolments enable row level security;
alter table public.careers enable row level security;
alter table public.career_selections enable row level security;
alter table public.goals enable row level security;
alter table public.grade_logs enable row level security;
alter table public.study_hours enable row level security;
alter table public.recovery_logs enable row level security;
alter table public.training_sessions enable row level security;
alter table public.sport_stats enable row level security;
alter table public.teams enable row level security;
alter table public.team_members enable row level security;
alter table public.match_plans enable row level security;
alter table public.match_plan_lineups enable row level security;
alter table public.squad_messages enable row level security;
alter table public.announcements enable row level security;
alter table public.announcement_replies enable row level security;
alter table public.announcement_reads enable row level security;
alter table public.clubs enable row level security;
alter table public.club_memberships enable row level security;
alter table public.communities enable row level security;
alter table public.community_memberships enable row level security;
alter table public.community_posts enable row level security;
alter table public.events enable row level security;
alter table public.event_rsvps enable row level security;
alter table public.scout_views enable row level security;
alter table public.saved_prospects enable row level security;

create policy profiles_select_owner on public.profiles for select using (
  auth.uid() = auth_uid or public.is_admin()
);
create policy profiles_update_owner on public.profiles for update using (
  auth.uid() = auth_uid or public.is_admin()
);
create policy profiles_insert_authenticated on public.profiles for insert with check (
  auth.role() = 'authenticated'
);

create policy student_profiles_select on public.student_profiles for select using (
  profile_id = public.current_profile_id() or public.is_admin() or public.is_role('teacher') or public.is_role('coach')
);
create policy teacher_profiles_select on public.teacher_profiles for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy coach_profiles_select on public.coach_profiles for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy scout_profiles_select on public.scout_profiles for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy admin_profiles_select on public.admin_profiles for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);

create policy classes_select on public.classes for select using (
  public.is_admin() or auth.uid() is not null
);
create policy class_enrolments_select on public.class_enrolments for select using (
  student_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin()
);
create policy teacher_logs_select on public.teacher_logs for select using (
  teacher_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin()
);
create policy grade_logs_select on public.grade_logs for select using (
  student_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin() or public.is_role('teacher')
);
create policy study_hours_select on public.study_hours for select using (
  student_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin()
);
create policy training_sessions_select on public.training_sessions for select using (
  coach_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin()
);
create policy announcements_select on public.announcements for select using (
  is_public or public.is_admin() or auth.uid() = author_profile_id
);
create policy clubs_select on public.clubs for select using (
  public.is_admin() or auth.uid() is not null
);
create policy communities_select on public.communities for select using (
  public.is_admin() or auth.uid() is not null
);
create policy events_select on public.events for select using (
  public.is_admin() or is_public or auth.uid() is not null
);
create policy announcement_replies_select on public.announcement_replies for select using (
  announcement_id in (select id from public.announcements where author_profile_id = public.current_profile_id()) or profile_id = public.current_profile_id() or public.is_admin()
);
create policy announcement_reads_select on public.announcement_reads for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy club_memberships_select on public.club_memberships for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy community_memberships_select on public.community_memberships for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy community_posts_select on public.community_posts for select using (
  community_id in (select community_id from public.community_memberships where profile_id = public.current_profile_id()) or public.is_admin()
);
create policy event_rsvps_select on public.event_rsvps for select using (
  profile_id = public.current_profile_id() or public.is_admin()
);
create policy career_selections_select on public.career_selections for select using (
  student_profile_id = public.current_profile_id() or public.is_admin()
);
create policy goals_select on public.goals for select using (
  student_profile_id = public.current_profile_id() or public.is_admin()
);
create policy match_plan_lineups_select on public.match_plan_lineups for select using (
  match_plan_id in (select id from public.match_plans where coach_profile_id = public.current_profile_id()) or public.is_admin()
);
create policy squad_messages_select on public.squad_messages for select using (
  match_plan_id in (select id from public.match_plans where coach_profile_id = public.current_profile_id()) or sender_profile_id = public.current_profile_id() or public.is_admin()
);
create policy scout_views_select on public.scout_views for select using (
  scout_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin()
);
create policy saved_prospects_select on public.saved_prospects for select using (
  scout_profile_id = (select profile_id from public.profiles where auth_uid = auth.uid()) or public.is_admin()
);

alter table public.profiles force row level security;
alter table public.student_profiles force row level security;
alter table public.teacher_profiles force row level security;
alter table public.coach_profiles force row level security;
alter table public.admin_profiles force row level security;
alter table public.scout_profiles force row level security;
alter table public.classes force row level security;
alter table public.class_enrolments force row level security;
alter table public.teacher_logs force row level security;
alter table public.grade_logs force row level security;
alter table public.study_hours force row level security;
alter table public.recovery_logs force row level security;
alter table public.training_sessions force row level security;
alter table public.match_plans force row level security;
alter table public.match_plan_lineups force row level security;
alter table public.squad_messages force row level security;
alter table public.announcements force row level security;
alter table public.announcement_replies force row level security;
alter table public.announcement_reads force row level security;
alter table public.clubs force row level security;
alter table public.club_memberships force row level security;
alter table public.communities force row level security;
alter table public.community_memberships force row level security;
alter table public.community_posts force row level security;
alter table public.events force row level security;
alter table public.event_rsvps force row level security;
alter table public.scout_views force row level security;
alter table public.saved_prospects force row level security;
