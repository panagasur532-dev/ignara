import { createClient, SupabaseClient } from '@supabase/supabase-js';

export type LifecycleRole = 'student' | 'teacher' | 'coach' | 'admin' | 'scout';

export interface LifecycleProfileInput {
  email: string;
  password: string;
  fullName: string;
  firstName?: string;
  lastName?: string;
  dob?: string;
  nationality?: string;
  phone?: string;
  address?: string;
  profilePhoto?: string;
  schoolId?: string;
  role: LifecycleRole;
}

export interface LifecycleStudentPayload {
  enrollment_number?: string;
  year_group?: string;
  house?: string;
  career_interest?: string;
  academic_status?: string;
  grade_point_avg?: number;
  student_rank?: string;
  team_id?: string;
  guardian?: {
    guardian_name: string;
    relationship: string;
    phone?: string;
    email?: string;
    address?: string;
  };
}

export interface LifecycleTeacherPayload {
  teacher_code?: string;
  subject_area?: string;
  department?: string;
  hire_date?: string;
  years_experience?: number;
  certifications?: string;
  office_location?: string;
}

export interface LifecycleCoachPayload {
  coach_code?: string;
  sport_specialty?: string;
  certifications?: string;
  region?: string;
  active_teams?: number;
}

export interface LifecycleAdminPayload {
  admin_level?: string;
  department?: string;
  permissions?: Record<string, unknown>;
}

export interface LifecycleScoutPayload {
  organization?: string;
  region_focus?: string;
  scout_rank?: string;
  saved_prospect_count?: number;
}

export type LifecycleRolePayload =
  | LifecycleStudentPayload
  | LifecycleTeacherPayload
  | LifecycleCoachPayload
  | LifecycleAdminPayload
  | LifecycleScoutPayload;

export function createSupabaseClient(): SupabaseClient {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? '';
  const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? '';
  return createClient(supabaseUrl, supabaseKey, {
    auth: {
      persistSession: true,
      detectSessionInUrl: true,
    },
  });
}

export async function signUpAndOnboardUser(
  client: SupabaseClient,
  profile: LifecycleProfileInput,
  rolePayload: LifecycleRolePayload
) {
  const { data: signUpData, error: signUpError } = await client.auth.signUp({
    email: profile.email,
    password: profile.password,
  }, {
    data: {
      role: profile.role,
      full_name: profile.fullName,
      school_id: profile.schoolId,
    },
  });

  if (signUpError) {
    throw signUpError;
  }

  const authUser = signUpData.user;
  if (!authUser?.id) {
    throw new Error('Supabase auth sign up did not return a user ID.');
  }

  const { error: profileError } = await client.rpc('register_lifecycle_profile', {
    p_role: profile.role,
    p_profile: {
      email: profile.email,
      full_name: profile.fullName,
      first_name: profile.firstName ?? null,
      last_name: profile.lastName ?? null,
      dob: profile.dob ?? null,
      nationality: profile.nationality ?? null,
      phone: profile.phone ?? null,
      address: profile.address ?? null,
      school_id: profile.schoolId ?? null,
      profile_photo: profile.profilePhoto ?? null,
    },
    p_role_payload: rolePayload,
  });

  if (profileError) {
    throw profileError;
  }

  return { user: authUser };
}

export async function completeOnboardingWithRole(
  client: SupabaseClient,
  profileId: string,
  rolePayload: LifecycleRolePayload
) {
  const { error } = await client
    .from('profiles')
    .update({ onboarding_completed: true })
    .eq('id', profileId);

  if (error) {
    throw error;
  }

  return true;
}
