-- 001_lifecycle_schema.sql
-- MySQL schema for Lifecycle app.

CREATE DATABASE IF NOT EXISTS lifecycle_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lifecycle_app;

CREATE TABLE IF NOT EXISTS auth_users (
  id CHAR(36) NOT NULL PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  provider VARCHAR(50) NOT NULL DEFAULT 'local',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  last_login DATETIME(6) NULL,
  INDEX idx_auth_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS schools (
  id CHAR(36) NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100) NOT NULL UNIQUE,
  address TEXT,
  city VARCHAR(100),
  country VARCHAR(100),
  established_year INT,
  website VARCHAR(255),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS profiles (
  id CHAR(36) NOT NULL PRIMARY KEY,
  auth_uid CHAR(36) NOT NULL,
  lc_id VARCHAR(32) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  dob DATE,
  nationality VARCHAR(100),
  phone VARCHAR(50),
  address TEXT,
  school_id CHAR(36),
  role VARCHAR(20) NOT NULL,
  onboarding_completed TINYINT(1) NOT NULL DEFAULT 0,
  profile_photo TEXT,
  current_streak INT NOT NULL DEFAULT 0,
  last_active_at DATETIME(6),
  view_count INT NOT NULL DEFAULT 0,
  rank VARCHAR(50),
  score DECIMAL(10,2) NOT NULL DEFAULT 0,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_profiles_auth_users FOREIGN KEY (auth_uid) REFERENCES auth_users(id) ON DELETE CASCADE,
  CONSTRAINT fk_profiles_schools FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL,
  CONSTRAINT chk_profiles_role CHECK (role IN ('student','teacher','coach','admin','scout')),
  INDEX idx_profiles_auth_uid (auth_uid),
  INDEX idx_profiles_school_id (school_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS guardians (
  id CHAR(36) NOT NULL PRIMARY KEY,
  profile_id CHAR(36) NOT NULL,
  guardian_name VARCHAR(255) NOT NULL,
  relationship VARCHAR(100) NOT NULL,
  phone VARCHAR(50),
  email VARCHAR(255),
  address TEXT,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_guardians_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  UNIQUE KEY ux_guardians_profile_id (profile_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS teacher_profiles (
  profile_id CHAR(36) NOT NULL PRIMARY KEY,
  teacher_code VARCHAR(100) UNIQUE,
  subject_area VARCHAR(255),
  department VARCHAR(255),
  hire_date DATE,
  years_experience INT,
  certifications TEXT,
  office_location VARCHAR(255),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_teacher_profiles_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS coach_profiles (
  profile_id CHAR(36) NOT NULL PRIMARY KEY,
  coach_code VARCHAR(100) UNIQUE,
  sport_specialty VARCHAR(255),
  certifications TEXT,
  region VARCHAR(255),
  active_teams INT NOT NULL DEFAULT 0,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_coach_profiles_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS admin_profiles (
  profile_id CHAR(36) NOT NULL PRIMARY KEY,
  admin_level VARCHAR(100) NOT NULL DEFAULT 'standard',
  department VARCHAR(255),
  permissions JSON NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_admin_profiles_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS scout_profiles (
  profile_id CHAR(36) NOT NULL PRIMARY KEY,
  organization VARCHAR(255),
  region_focus VARCHAR(255),
  scout_rank VARCHAR(100),
  saved_prospect_count INT NOT NULL DEFAULT 0,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_scout_profiles_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS subjects (
  id CHAR(36) NOT NULL PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS teams (
  id CHAR(36) NOT NULL PRIMARY KEY,
  school_id CHAR(36),
  name VARCHAR(255) NOT NULL,
  coach_profile_id CHAR(36),
  sport VARCHAR(100),
  season VARCHAR(100),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_teams_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL,
  CONSTRAINT fk_teams_coach FOREIGN KEY (coach_profile_id) REFERENCES coach_profiles(profile_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS student_profiles (
  profile_id CHAR(36) NOT NULL PRIMARY KEY,
  enrollment_number VARCHAR(100) UNIQUE,
  year_group VARCHAR(100),
  house VARCHAR(100),
  guardian_id CHAR(36),
  career_interest VARCHAR(255),
  academic_status VARCHAR(100),
  grade_point_avg DECIMAL(5,2),
  student_rank VARCHAR(100),
  team_id CHAR(36),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_student_profiles_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  CONSTRAINT fk_student_profiles_guardian FOREIGN KEY (guardian_id) REFERENCES guardians(id) ON DELETE SET NULL,
  CONSTRAINT fk_student_profiles_team FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS classes (
  id CHAR(36) NOT NULL PRIMARY KEY,
  school_id CHAR(36),
  subject_id CHAR(36),
  name VARCHAR(255) NOT NULL,
  term VARCHAR(100),
  teacher_profile_id CHAR(36),
  capacity INT NOT NULL DEFAULT 30,
  schedule JSON NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_classes_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL,
  CONSTRAINT fk_classes_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL,
  CONSTRAINT fk_classes_teacher FOREIGN KEY (teacher_profile_id) REFERENCES teacher_profiles(profile_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS class_enrolments (
  id CHAR(36) NOT NULL PRIMARY KEY,
  class_id CHAR(36) NOT NULL,
  student_profile_id CHAR(36) NOT NULL,
  enrolled_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  active TINYINT(1) NOT NULL DEFAULT 1,
  status VARCHAR(50) NOT NULL DEFAULT 'enrolled',
  CONSTRAINT fk_class_enrolments_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
  CONSTRAINT fk_class_enrolments_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE,
  UNIQUE KEY ux_class_enrolments_unique (class_id, student_profile_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS careers (
  id CHAR(36) NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  pathway VARCHAR(255),
  industry VARCHAR(255),
  description TEXT,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS career_selections (
  id CHAR(36) NOT NULL PRIMARY KEY,
  student_profile_id CHAR(36) NOT NULL,
  career_id CHAR(36) NOT NULL,
  selected_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  priority INT NOT NULL DEFAULT 1,
  status VARCHAR(50) NOT NULL DEFAULT 'pending',
  CONSTRAINT fk_career_selections_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_career_selections_career FOREIGN KEY (career_id) REFERENCES careers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS goals (
  id CHAR(36) NOT NULL PRIMARY KEY,
  student_profile_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  target_date DATE,
  progress DECIMAL(5,2) NOT NULL DEFAULT 0,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_goals_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS grade_logs (
  id CHAR(36) NOT NULL PRIMARY KEY,
  student_profile_id CHAR(36) NOT NULL,
  teacher_profile_id CHAR(36),
  class_id CHAR(36),
  subject_id CHAR(36),
  grade VARCHAR(50),
  score DECIMAL(10,2),
  comments TEXT,
  logged_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_grade_logs_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_grade_logs_teacher FOREIGN KEY (teacher_profile_id) REFERENCES teacher_profiles(profile_id) ON DELETE SET NULL,
  CONSTRAINT fk_grade_logs_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL,
  CONSTRAINT fk_grade_logs_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS study_hours (
  id CHAR(36) NOT NULL PRIMARY KEY,
  student_profile_id CHAR(36) NOT NULL,
  activity_date DATE NOT NULL,
  hours DECIMAL(5,2) NOT NULL,
  activity VARCHAR(255),
  session_type VARCHAR(100),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_study_hours_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS recovery_logs (
  id CHAR(36) NOT NULL PRIMARY KEY,
  student_profile_id CHAR(36) NOT NULL,
  recovery_date DATE NOT NULL,
  recovery_type VARCHAR(100) NOT NULL,
  duration_minutes INT,
  quality_rating INT,
  notes TEXT,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_recovery_logs_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE,
  CHECK (quality_rating BETWEEN 1 AND 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS training_sessions (
  id CHAR(36) NOT NULL PRIMARY KEY,
  coach_profile_id CHAR(36) NOT NULL,
  team_id CHAR(36),
  session_date DATE NOT NULL,
  duration_minutes INT,
  focus_area VARCHAR(255),
  intensity VARCHAR(100),
  notes TEXT,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_training_sessions_coach FOREIGN KEY (coach_profile_id) REFERENCES coach_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_training_sessions_team FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sport_stats (
  id CHAR(36) NOT NULL PRIMARY KEY,
  student_profile_id CHAR(36) NOT NULL,
  team_id CHAR(36),
  season VARCHAR(100),
  matches_played INT NOT NULL DEFAULT 0,
  goals INT NOT NULL DEFAULT 0,
  assists INT NOT NULL DEFAULT 0,
  wins INT NOT NULL DEFAULT 0,
  losses INT NOT NULL DEFAULT 0,
  rating DECIMAL(5,2) NOT NULL DEFAULT 0,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_sport_stats_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_sport_stats_team FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS team_members (
  id CHAR(36) NOT NULL PRIMARY KEY,
  team_id CHAR(36) NOT NULL,
  student_profile_id CHAR(36) NOT NULL,
  role VARCHAR(100),
  joined_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  active TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_team_members_team FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
  CONSTRAINT fk_team_members_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE,
  UNIQUE KEY ux_team_members_unique (team_id, student_profile_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS match_plans (
  id CHAR(36) NOT NULL PRIMARY KEY,
  team_id CHAR(36) NOT NULL,
  coach_profile_id CHAR(36) NOT NULL,
  opponent VARCHAR(255),
  match_date DATE,
  location VARCHAR(255),
  plan_notes TEXT,
  status VARCHAR(50) NOT NULL DEFAULT 'draft',
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_match_plans_team FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE,
  CONSTRAINT fk_match_plans_coach FOREIGN KEY (coach_profile_id) REFERENCES coach_profiles(profile_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS match_plan_lineups (
  id CHAR(36) NOT NULL PRIMARY KEY,
  match_plan_id CHAR(36) NOT NULL,
  student_profile_id CHAR(36) NOT NULL,
  position VARCHAR(100),
  starter TINYINT(1) NOT NULL DEFAULT 0,
  notes TEXT,
  CONSTRAINT fk_match_plan_lineups_plan FOREIGN KEY (match_plan_id) REFERENCES match_plans(id) ON DELETE CASCADE,
  CONSTRAINT fk_match_plan_lineups_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS squad_messages (
  id CHAR(36) NOT NULL PRIMARY KEY,
  match_plan_id CHAR(36) NOT NULL,
  sender_profile_id CHAR(36) NOT NULL,
  message TEXT NOT NULL,
  sent_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_squad_messages_plan FOREIGN KEY (match_plan_id) REFERENCES match_plans(id) ON DELETE CASCADE,
  CONSTRAINT fk_squad_messages_sender FOREIGN KEY (sender_profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS announcements (
  id CHAR(36) NOT NULL PRIMARY KEY,
  author_profile_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  target_roles JSON NOT NULL,
  target_school_id CHAR(36),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  expires_at DATETIME(6),
  is_public TINYINT(1) NOT NULL DEFAULT 0,
  view_count INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_announcements_author FOREIGN KEY (author_profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  CONSTRAINT fk_announcements_school FOREIGN KEY (target_school_id) REFERENCES schools(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS announcement_replies (
  id CHAR(36) NOT NULL PRIMARY KEY,
  announcement_id CHAR(36) NOT NULL,
  profile_id CHAR(36) NOT NULL,
  body TEXT NOT NULL,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_announcement_replies_announcement FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON DELETE CASCADE,
  CONSTRAINT fk_announcement_replies_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS announcement_reads (
  id CHAR(36) NOT NULL PRIMARY KEY,
  announcement_id CHAR(36) NOT NULL,
  profile_id CHAR(36) NOT NULL,
  read_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  UNIQUE KEY ux_announcement_reads_unique (announcement_id, profile_id),
  CONSTRAINT fk_announcement_reads_announcement FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON DELETE CASCADE,
  CONSTRAINT fk_announcement_reads_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS clubs (
  id CHAR(36) NOT NULL PRIMARY KEY,
  school_id CHAR(36),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  coach_profile_id CHAR(36),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  active TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_clubs_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL,
  CONSTRAINT fk_clubs_coach FOREIGN KEY (coach_profile_id) REFERENCES coach_profiles(profile_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS club_memberships (
  id CHAR(36) NOT NULL PRIMARY KEY,
  club_id CHAR(36) NOT NULL,
  profile_id CHAR(36) NOT NULL,
  joined_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  role VARCHAR(100) NOT NULL DEFAULT 'member',
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  UNIQUE KEY ux_club_memberships_unique (club_id, profile_id),
  CONSTRAINT fk_club_memberships_club FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
  CONSTRAINT fk_club_memberships_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS communities (
  id CHAR(36) NOT NULL PRIMARY KEY,
  school_id CHAR(36),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  is_public TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_communities_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS community_memberships (
  id CHAR(36) NOT NULL PRIMARY KEY,
  community_id CHAR(36) NOT NULL,
  profile_id CHAR(36) NOT NULL,
  joined_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  role VARCHAR(100) NOT NULL DEFAULT 'member',
  UNIQUE KEY ux_community_memberships_unique (community_id, profile_id),
  CONSTRAINT fk_community_memberships_community FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE,
  CONSTRAINT fk_community_memberships_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS community_posts (
  id CHAR(36) NOT NULL PRIMARY KEY,
  community_id CHAR(36) NOT NULL,
  profile_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  parent_post_id CHAR(36),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_community_posts_community FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE,
  CONSTRAINT fk_community_posts_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
  CONSTRAINT fk_community_posts_parent FOREIGN KEY (parent_post_id) REFERENCES community_posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS events (
  id CHAR(36) NOT NULL PRIMARY KEY,
  school_id CHAR(36),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  location VARCHAR(255),
  event_start DATETIME(6) NOT NULL,
  event_end DATETIME(6),
  created_by CHAR(36) NOT NULL,
  capacity INT,
  is_public TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_events_school FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL,
  CONSTRAINT fk_events_created_by FOREIGN KEY (created_by) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS event_rsvps (
  id CHAR(36) NOT NULL PRIMARY KEY,
  event_id CHAR(36) NOT NULL,
  profile_id CHAR(36) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'going',
  responded_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  UNIQUE KEY ux_event_rsvps_unique (event_id, profile_id),
  CONSTRAINT fk_event_rsvps_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  CONSTRAINT fk_event_rsvps_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS scout_views (
  id CHAR(36) NOT NULL PRIMARY KEY,
  scout_profile_id CHAR(36) NOT NULL,
  student_profile_id CHAR(36) NOT NULL,
  viewed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  view_type VARCHAR(100) NOT NULL DEFAULT 'profile',
  notes TEXT,
  CONSTRAINT fk_scout_views_scout FOREIGN KEY (scout_profile_id) REFERENCES scout_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_scout_views_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS saved_prospects (
  id CHAR(36) NOT NULL PRIMARY KEY,
  scout_profile_id CHAR(36) NOT NULL,
  student_profile_id CHAR(36) NOT NULL,
  saved_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  priority INT NOT NULL DEFAULT 1,
  notes TEXT,
  UNIQUE KEY ux_saved_prospects_unique (scout_profile_id, student_profile_id),
  CONSTRAINT fk_saved_prospects_scout FOREIGN KEY (scout_profile_id) REFERENCES scout_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_saved_prospects_student FOREIGN KEY (student_profile_id) REFERENCES student_profiles(profile_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS teacher_logs (
  id CHAR(36) NOT NULL PRIMARY KEY,
  teacher_profile_id CHAR(36) NOT NULL,
  class_id CHAR(36),
  log_type VARCHAR(50) NOT NULL,
  title VARCHAR(255),
  details JSON NULL,
  logged_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  CONSTRAINT fk_teacher_logs_teacher FOREIGN KEY (teacher_profile_id) REFERENCES teacher_profiles(profile_id) ON DELETE CASCADE,
  CONSTRAINT fk_teacher_logs_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL,
  CONSTRAINT chk_teacher_logs_type CHECK (log_type IN ('lesson','marking','project'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
