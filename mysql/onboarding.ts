import mysql from 'mysql2/promise';

export interface LifecycleProfileInput {
  authId: string;
  email: string;
  passwordHash: string;
  fullName: string;
  firstName?: string;
  lastName?: string;
  dob?: string;
  nationality?: string;
  phone?: string;
  address?: string;
  schoolId?: string;
  role: 'student' | 'teacher' | 'coach' | 'admin' | 'scout';
  profilePhoto?: string;
}

export interface LifecycleStudentPayload {
  enrollmentNumber?: string;
  yearGroup?: string;
  house?: string;
  guardianName?: string;
  guardianRelationship?: string;
  guardianPhone?: string;
  guardianEmail?: string;
  guardianAddress?: string;
  careerInterest?: string;
  academicStatus?: string;
  gradePointAvg?: number;
  studentRank?: string;
  teamId?: string;
}

export interface LifecycleTeacherPayload {
  teacherCode?: string;
  subjectArea?: string;
  department?: string;
  hireDate?: string;
  yearsExperience?: number;
  certifications?: string;
  officeLocation?: string;
}

export interface LifecycleCoachPayload {
  coachCode?: string;
  sportSpecialty?: string;
  certifications?: string;
  region?: string;
  activeTeams?: number;
}

export interface LifecycleAdminPayload {
  adminLevel?: string;
  department?: string;
  permissions?: object;
}

export interface LifecycleScoutPayload {
  organization?: string;
  regionFocus?: string;
  scoutRank?: string;
  savedProspectCount?: number;
}

export type LifecycleRolePayload =
  | LifecycleStudentPayload
  | LifecycleTeacherPayload
  | LifecycleCoachPayload
  | LifecycleAdminPayload
  | LifecycleScoutPayload;

export async function createMysqlConnection() {
  return mysql.createPool({
    host: process.env.MYSQL_HOST ?? 'localhost',
    port: Number(process.env.MYSQL_PORT ?? 3306),
    user: process.env.MYSQL_USER ?? 'root',
    password: process.env.MYSQL_PASSWORD ?? '',
    database: process.env.MYSQL_DATABASE ?? 'lifecycle_app',
    connectionLimit: 10,
    namedPlaceholders: true,
  });
}

export async function onboardUser(
  connection: mysql.Pool,
  profile: LifecycleProfileInput,
  rolePayload: LifecycleRolePayload
) {
  const profileId = profile.authId;
  const authInsert = 'CALL create_auth_user(:id, :email, :password_hash, :provider)';
  await connection.execute(authInsert, {
    id: profile.authId,
    email: profile.email,
    password_hash: profile.passwordHash,
    provider: 'local',
  });

  const profileInsert = 'CALL create_profile(:id, :auth_uid, :email, :full_name, :first_name, :last_name, :dob, :nationality, :phone, :address, :school_id, :role, :profile_photo)';
  await connection.execute(profileInsert, {
    id: profileId,
    auth_uid: profile.authId,
    email: profile.email,
    full_name: profile.fullName,
    first_name: profile.firstName ?? null,
    last_name: profile.lastName ?? null,
    dob: profile.dob ?? null,
    nationality: profile.nationality ?? null,
    phone: profile.phone ?? null,
    address: profile.address ?? null,
    school_id: profile.schoolId ?? null,
    role: profile.role,
    profile_photo: profile.profilePhoto ?? null,
  });

  switch (profile.role) {
    case 'student': {
      const payload = rolePayload as LifecycleStudentPayload;
      await connection.execute(
        'CALL register_student_profile(:profile_id, :enrollment_number, :year_group, :house, :guardian_name, :guardian_relationship, :guardian_phone, :guardian_email, :guardian_address, :career_interest, :academic_status, :grade_point_avg, :student_rank, :team_id)',
        {
          profile_id: profileId,
          enrollment_number: payload.enrollmentNumber ?? null,
          year_group: payload.yearGroup ?? null,
          house: payload.house ?? null,
          guardian_name: payload.guardianName ?? null,
          guardian_relationship: payload.guardianRelationship ?? null,
          guardian_phone: payload.guardianPhone ?? null,
          guardian_email: payload.guardianEmail ?? null,
          guardian_address: payload.guardianAddress ?? null,
          career_interest: payload.careerInterest ?? null,
          academic_status: payload.academicStatus ?? null,
          grade_point_avg: payload.gradePointAvg ?? null,
          student_rank: payload.studentRank ?? null,
          team_id: payload.teamId ?? null,
        }
      );
      break;
    }
    case 'teacher': {
      const payload = rolePayload as LifecycleTeacherPayload;
      await connection.execute(
        'CALL register_teacher_profile(:profile_id, :teacher_code, :subject_area, :department, :hire_date, :years_experience, :certifications, :office_location)',
        {
          profile_id: profileId,
          teacher_code: payload.teacherCode ?? null,
          subject_area: payload.subjectArea ?? null,
          department: payload.department ?? null,
          hire_date: payload.hireDate ?? null,
          years_experience: payload.yearsExperience ?? null,
          certifications: payload.certifications ?? null,
          office_location: payload.officeLocation ?? null,
        }
      );
      break;
    }
    case 'coach': {
      const payload = rolePayload as LifecycleCoachPayload;
      await connection.execute(
        'CALL register_coach_profile(:profile_id, :coach_code, :sport_specialty, :certifications, :region, :active_teams)',
        {
          profile_id: profileId,
          coach_code: payload.coachCode ?? null,
          sport_specialty: payload.sportSpecialty ?? null,
          certifications: payload.certifications ?? null,
          region: payload.region ?? null,
          active_teams: payload.activeTeams ?? 0,
        }
      );
      break;
    }
    case 'admin': {
      const payload = rolePayload as LifecycleAdminPayload;
      await connection.execute(
        'CALL register_admin_profile(:profile_id, :admin_level, :department, :permissions)',
        {
          profile_id: profileId,
          admin_level: payload.adminLevel ?? 'standard',
          department: payload.department ?? null,
          permissions: payload.permissions ? JSON.stringify(payload.permissions) : null,
        }
      );
      break;
    }
    case 'scout': {
      const payload = rolePayload as LifecycleScoutPayload;
      await connection.execute(
        'CALL register_scout_profile(:profile_id, :organization, :region_focus, :scout_rank, :saved_prospect_count)',
        {
          profile_id: profileId,
          organization: payload.organization ?? null,
          region_focus: payload.regionFocus ?? null,
          scout_rank: payload.scoutRank ?? null,
          saved_prospect_count: payload.savedProspectCount ?? 0,
        }
      );
      break;
    }
    default:
      throw new Error(`Unsupported role ${profile.role}`);
  }

  return profileId;
}
