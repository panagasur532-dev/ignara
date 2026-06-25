import mysql from 'mysql2/promise';

export async function queryStudentPortal(connection: mysql.Pool, studentProfileId: string) {
  const [rows] = await connection.query(
    `SELECT p.id as profile_id,
      p.email,
      p.full_name,
      p.current_streak,
      s.enrollment_number,
      s.year_group,
      (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', g.id, 'title', g.title, 'progress', g.progress, 'status', g.status))
        FROM goals g
        WHERE g.student_profile_id = s.profile_id) AS goals,
      (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', gl.id, 'grade', gl.grade, 'score', gl.score, 'comments', gl.comments))
        FROM grade_logs gl
        WHERE gl.student_profile_id = s.profile_id) AS grade_logs,
      (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', sh.id, 'activity_date', sh.activity_date, 'hours', sh.hours, 'activity', sh.activity))
        FROM study_hours sh
        WHERE sh.student_profile_id = s.profile_id) AS study_hours,
      (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', rl.id, 'recovery_date', rl.recovery_date, 'recovery_type', rl.recovery_type, 'quality_rating', rl.quality_rating))
        FROM recovery_logs rl
        WHERE rl.student_profile_id = s.profile_id) AS recovery_logs
    FROM profiles p
    JOIN student_profiles s ON s.profile_id = p.id
    WHERE p.id = ?`,
    [studentProfileId]
  );
  return rows[0] || null;
}

export async function createMatchPlan(connection: mysql.Pool, payload: {
  id: string;
  teamId: string;
  coachProfileId: string;
  opponent: string;
  matchDate: string;
  location: string;
  planNotes?: string;
  status?: string;
}) {
  await connection.execute(
    `INSERT INTO match_plans (id, team_id, coach_profile_id, opponent, match_date, location, plan_notes, status)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?);`,
    [payload.id, payload.teamId, payload.coachProfileId, payload.opponent, payload.matchDate, payload.location, payload.planNotes ?? null, payload.status ?? 'draft']
  );
  return payload.id;
}

export async function postAnnouncement(connection: mysql.Pool, payload: {
  id: string;
  authorProfileId: string;
  title: string;
  body: string;
  targetRoles: string[];
  targetSchoolId?: string;
  isPublic?: boolean;
  expiresAt?: string;
}) {
  await connection.execute(
    `INSERT INTO announcements (id, author_profile_id, title, body, target_roles, target_school_id, is_public, expires_at)
     VALUES (?, ?, ?, ?, CAST(? AS JSON), ?, ?, ?);`,
    [payload.id, payload.authorProfileId, payload.title, payload.body, JSON.stringify(payload.targetRoles), payload.targetSchoolId ?? null, payload.isPublic ? 1 : 0, payload.expiresAt ?? null]
  );
  return payload.id;
}

export async function saveProspect(connection: mysql.Pool, payload: {
  id: string;
  scoutProfileId: string;
  studentProfileId: string;
  priority: number;
  notes?: string;
}) {
  await connection.execute(
    `INSERT INTO saved_prospects (id, scout_profile_id, student_profile_id, priority, notes)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE priority = VALUES(priority), notes = VALUES(notes);`,
    [payload.id, payload.scoutProfileId, payload.studentProfileId, payload.priority, payload.notes ?? null]
  );
  return payload.id;
}
