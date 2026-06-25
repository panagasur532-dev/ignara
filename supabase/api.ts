import { SupabaseClient } from '@supabase/supabase-js';

export async function fetchStudentDashboard(client: SupabaseClient, studentProfileId: string) {
  const { data, error } = await client.rpc('get_student_portal', { p_profile_id: studentProfileId });
  if (error) throw error;
  return data;
}

export async function fetchTeacherDashboard(client: SupabaseClient, teacherProfileId: string) {
  const { data, error } = await client.rpc('get_teacher_portal', { p_profile_id: teacherProfileId });
  if (error) throw error;
  return data;
}

export async function fetchCoachDashboard(client: SupabaseClient, coachProfileId: string) {
  const { data, error } = await client.rpc('get_coach_portal', { p_profile_id: coachProfileId });
  if (error) throw error;
  return data;
}

export async function fetchAdminDashboard(client: SupabaseClient, adminProfileId: string) {
  const { data, error } = await client.rpc('get_admin_portal', { p_profile_id: adminProfileId });
  if (error) throw error;
  return data;
}

export async function fetchScoutDashboard(client: SupabaseClient, scoutProfileId: string) {
  const { data, error } = await client.rpc('get_scout_portal', { p_profile_id: scoutProfileId });
  if (error) throw error;
  return data;
}

export async function createMatchPlan(client: SupabaseClient, payload: {
  team_id: string;
  coach_profile_id: string;
  opponent: string;
  match_date: string;
  location: string;
  plan_notes?: string;
  status?: string;
}) {
  const { data, error } = await client.rpc('create_match_plan', {
    p_team_id: payload.team_id,
    p_coach_profile_id: payload.coach_profile_id,
    p_opponent: payload.opponent,
    p_match_date: payload.match_date,
    p_location: payload.location,
    p_plan_notes: payload.plan_notes,
    p_status: payload.status ?? 'draft',
  });
  if (error) throw error;
  return data;
}

export async function postAnnouncement(client: SupabaseClient, payload: {
  author_profile_id: string;
  title: string;
  body: string;
  target_roles?: string[];
  target_school_id?: string;
  is_public?: boolean;
  expires_at?: string;
}) {
  const { data, error } = await client.rpc('post_announcement', {
    p_author_profile_id: payload.author_profile_id,
    p_title: payload.title,
    p_body: payload.body,
    p_target_roles: payload.target_roles ?? ['student', 'teacher', 'coach', 'admin', 'scout'],
    p_target_school_id: payload.target_school_id ?? null,
    p_is_public: payload.is_public ?? false,
    p_expires_at: payload.expires_at ?? null,
  });
  if (error) throw error;
  return data;
}

export async function saveProspect(client: SupabaseClient, payload: {
  scout_profile_id: string;
  student_profile_id: string;
  priority: number;
  notes?: string;
}) {
  const { data, error } = await client.rpc('save_prospect', {
    p_scout_profile_id: payload.scout_profile_id,
    p_student_profile_id: payload.student_profile_id,
    p_priority: payload.priority,
    p_notes: payload.notes ?? null,
  });
  if (error) throw error;
  return data;
}
