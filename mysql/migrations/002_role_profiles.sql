-- 002_role_profiles.sql
-- MySQL stored procedures and triggers for Lifecycle app.

USE lifecycle_app;

DELIMITER $$

CREATE FUNCTION generate_lc_id() RETURNS VARCHAR(32)
DETERMINISTIC
BEGIN
  RETURN CONCAT('LC-', YEAR(CURRENT_DATE), '-', UPPER(LEFT(REPLACE(UUID(), '-', ''), 8)));
END$$

CREATE TRIGGER profiles_before_insert
BEFORE INSERT ON profiles
FOR EACH ROW
BEGIN
  IF NEW.lc_id IS NULL OR NEW.lc_id = '' THEN
    SET NEW.lc_id = generate_lc_id();
  END IF;
END$$

CREATE PROCEDURE create_auth_user(
  IN p_id CHAR(36),
  IN p_email VARCHAR(255),
  IN p_password_hash VARCHAR(255),
  IN p_provider VARCHAR(50)
)
BEGIN
  INSERT INTO auth_users (id, email, password_hash, provider)
  VALUES (p_id, p_email, p_password_hash, p_provider);
END$$

CREATE PROCEDURE create_profile(
  IN p_id CHAR(36),
  IN p_auth_uid CHAR(36),
  IN p_email VARCHAR(255),
  IN p_full_name VARCHAR(255),
  IN p_first_name VARCHAR(100),
  IN p_last_name VARCHAR(100),
  IN p_dob DATE,
  IN p_nationality VARCHAR(100),
  IN p_phone VARCHAR(50),
  IN p_address TEXT,
  IN p_school_id CHAR(36),
  IN p_role VARCHAR(20),
  IN p_profile_photo TEXT
)
BEGIN
  INSERT INTO profiles (id, auth_uid, email, full_name, first_name, last_name, dob, nationality, phone, address, school_id, role, onboarding_completed, profile_photo)
  VALUES (p_id, p_auth_uid, p_email, p_full_name, p_first_name, p_last_name, p_dob, p_nationality, p_phone, p_address, p_school_id, p_role, 1, p_profile_photo);
END$$

CREATE PROCEDURE register_student_profile(
  IN p_profile_id CHAR(36),
  IN p_enrollment_number VARCHAR(100),
  IN p_year_group VARCHAR(100),
  IN p_house VARCHAR(100),
  IN p_guardian_name VARCHAR(255),
  IN p_guardian_relationship VARCHAR(100),
  IN p_guardian_phone VARCHAR(50),
  IN p_guardian_email VARCHAR(255),
  IN p_guardian_address TEXT,
  IN p_career_interest VARCHAR(255),
  IN p_academic_status VARCHAR(100),
  IN p_grade_point_avg DECIMAL(5,2),
  IN p_student_rank VARCHAR(100),
  IN p_team_id CHAR(36)
)
BEGIN
  DECLARE p_guardian_id CHAR(36) DEFAULT NULL;
  IF p_guardian_name IS NOT NULL AND p_guardian_name != '' THEN
    SET p_guardian_id = UUID();
    INSERT INTO guardians (id, profile_id, guardian_name, relationship, phone, email, address)
    VALUES (p_guardian_id, p_profile_id, p_guardian_name, p_guardian_relationship, p_guardian_phone, p_guardian_email, p_guardian_address);
  END IF;

  INSERT INTO student_profiles (profile_id, enrollment_number, year_group, house, guardian_id, career_interest, academic_status, grade_point_avg, student_rank, team_id)
  VALUES (p_profile_id, p_enrollment_number, p_year_group, p_house, p_guardian_id, p_career_interest, p_academic_status, p_grade_point_avg, p_student_rank, p_team_id);
END$$

CREATE PROCEDURE register_teacher_profile(
  IN p_profile_id CHAR(36),
  IN p_teacher_code VARCHAR(100),
  IN p_subject_area VARCHAR(255),
  IN p_department VARCHAR(255),
  IN p_hire_date DATE,
  IN p_years_experience INT,
  IN p_certifications TEXT,
  IN p_office_location VARCHAR(255)
)
BEGIN
  INSERT INTO teacher_profiles (profile_id, teacher_code, subject_area, department, hire_date, years_experience, certifications, office_location)
  VALUES (p_profile_id, p_teacher_code, p_subject_area, p_department, p_hire_date, p_years_experience, p_certifications, p_office_location);
END$$

CREATE PROCEDURE register_coach_profile(
  IN p_profile_id CHAR(36),
  IN p_coach_code VARCHAR(100),
  IN p_sport_specialty VARCHAR(255),
  IN p_certifications TEXT,
  IN p_region VARCHAR(255),
  IN p_active_teams INT
)
BEGIN
  INSERT INTO coach_profiles (profile_id, coach_code, sport_specialty, certifications, region, active_teams)
  VALUES (p_profile_id, p_coach_code, p_sport_specialty, p_certifications, p_region, p_active_teams);
END$$

CREATE PROCEDURE register_admin_profile(
  IN p_profile_id CHAR(36),
  IN p_admin_level VARCHAR(100),
  IN p_department VARCHAR(255),
  IN p_permissions JSON
)
BEGIN
  INSERT INTO admin_profiles (profile_id, admin_level, department, permissions)
  VALUES (p_profile_id, p_admin_level, p_department, p_permissions);
END$$

CREATE PROCEDURE register_scout_profile(
  IN p_profile_id CHAR(36),
  IN p_organization VARCHAR(255),
  IN p_region_focus VARCHAR(255),
  IN p_scout_rank VARCHAR(100),
  IN p_saved_prospect_count INT
)
BEGIN
  INSERT INTO scout_profiles (profile_id, organization, region_focus, scout_rank, saved_prospect_count)
  VALUES (p_profile_id, p_organization, p_region_focus, p_scout_rank, p_saved_prospect_count);
END$$

CREATE PROCEDURE recompute_profile_rank_for_student(IN p_student_profile_id CHAR(36))
BEGIN
  DECLARE grade_avg DECIMAL(10,2) DEFAULT 0;
  DECLARE sport_rating DECIMAL(10,2) DEFAULT 0;
  DECLARE new_rank VARCHAR(50) DEFAULT 'Silver';
  SELECT AVG(score) INTO grade_avg FROM grade_logs WHERE student_profile_id = p_student_profile_id;
  SELECT AVG(rating) INTO sport_rating FROM sport_stats WHERE student_profile_id = p_student_profile_id;
  IF grade_avg >= 85 OR sport_rating >= 8 THEN
    SET new_rank = 'Diamond';
  ELSEIF grade_avg >= 75 OR sport_rating >= 7 THEN
    SET new_rank = 'Platinum';
  ELSEIF grade_avg >= 60 OR sport_rating >= 5 THEN
    SET new_rank = 'Gold';
  ELSE
    SET new_rank = 'Silver';
  END IF;
  UPDATE profiles p
  JOIN student_profiles s ON p.id = s.profile_id
  SET p.rank = new_rank,
      p.score = GREATEST(COALESCE(grade_avg, 0), COALESCE(sport_rating, 0))
  WHERE s.profile_id = p_student_profile_id;
END$$

CREATE PROCEDURE update_student_streak(IN p_profile_id CHAR(36), IN p_activity_date DATE)
BEGIN
  DECLARE last_date DATE;
  DECLARE current_streak INT DEFAULT 0;
  DECLARE yesterday DATE;
  SET yesterday = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY);
  SELECT DATE(last_active_at), current_streak INTO last_date, current_streak FROM profiles WHERE id = p_profile_id;
  IF last_date IS NULL OR last_date < yesterday THEN
    SET current_streak = 1;
  ELSEIF last_date = yesterday THEN
    SET current_streak = current_streak + 1;
  END IF;
  UPDATE profiles
  SET current_streak = current_streak,
      last_active_at = p_activity_date
  WHERE id = p_profile_id;
END$$

CREATE TRIGGER grade_logs_after_insert
AFTER INSERT ON grade_logs
FOR EACH ROW
BEGIN
  CALL recompute_profile_rank_for_student(NEW.student_profile_id);
END$$

CREATE TRIGGER grade_logs_after_update
AFTER UPDATE ON grade_logs
FOR EACH ROW
BEGIN
  CALL recompute_profile_rank_for_student(NEW.student_profile_id);
END$$

CREATE TRIGGER sport_stats_after_insert
AFTER INSERT ON sport_stats
FOR EACH ROW
BEGIN
  CALL recompute_profile_rank_for_student(NEW.student_profile_id);
END$$

CREATE TRIGGER sport_stats_after_update
AFTER UPDATE ON sport_stats
FOR EACH ROW
BEGIN
  CALL recompute_profile_rank_for_student(NEW.student_profile_id);
END$$

CREATE PROCEDURE increment_profile_view_count(IN p_student_profile_id CHAR(36))
BEGIN
  UPDATE profiles p
  JOIN student_profiles s ON p.id = s.profile_id
  SET p.view_count = p.view_count + 1
  WHERE s.profile_id = p_student_profile_id;
END$$

CREATE TRIGGER scout_views_after_insert
AFTER INSERT ON scout_views
FOR EACH ROW
BEGIN
  CALL increment_profile_view_count(NEW.student_profile_id);
END$$

CREATE TRIGGER study_hours_after_insert
AFTER INSERT ON study_hours
FOR EACH ROW
BEGIN
  CALL update_student_streak(NEW.student_profile_id, NEW.activity_date);
END$$

CREATE TRIGGER recovery_logs_after_insert
AFTER INSERT ON recovery_logs
FOR EACH ROW
BEGIN
  CALL update_student_streak(NEW.student_profile_id, NEW.recovery_date);
END$$

CREATE TRIGGER training_sessions_after_insert
AFTER INSERT ON training_sessions
FOR EACH ROW
BEGIN
  DECLARE student_id CHAR(36);
  SELECT student_profile_id INTO student_id FROM team_members WHERE team_id = NEW.team_id LIMIT 1;
  IF student_id IS NOT NULL THEN
    CALL update_student_streak(student_id, NEW.session_date);
  END IF;
END$$

DELIMITER ;
