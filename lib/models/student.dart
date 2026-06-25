import 'package:flutter/material.dart';
import '../data/careers.dart';
import '../theme/theme.dart';
import 'tier_system.dart';

class SubjectGrade {
  final String subject;
  final double score;
  final String grade;
  final String term;
  final bool verified;

  const SubjectGrade({
    required this.subject,
    required this.score,
    required this.grade,
    required this.term,
    this.verified = false,
  });
}

class SportStat {
  final String sport;
  final String position;
  final int gamesPlayed;
  final int goals;
  final int assists;
  final double topSpeed;
  final int hoursTrainedThisTerm;
  final int tournamentsAttended;
  final int careerGoals;
  final List<String> achievementsThisSeason;

  const SportStat({
    required this.sport,
    required this.position,
    required this.gamesPlayed,
    required this.goals,
    required this.assists,
    required this.topSpeed,
    required this.hoursTrainedThisTerm,
    required this.tournamentsAttended,
    required this.careerGoals,
    required this.achievementsThisSeason,
  });
}

class ClubAttendance {
  final String clubName;
  final int sessionsAttended;
  final int totalSessions;
  final String category;

  const ClubAttendance({
    required this.clubName,
    required this.sessionsAttended,
    required this.totalSessions,
    required this.category,
  });

  double get attendanceRate => sessionsAttended / totalSessions;
}

class SchoolRecord {
  final String schoolName;
  final String location;
  final String fromYear;
  final String toYear;
  final bool current;
  final String grade;

  const SchoolRecord({
    required this.schoolName,
    required this.location,
    required this.fromYear,
    required this.toYear,
    required this.current,
    required this.grade,
  });
}

class StudentProfile {
  final String id;
  final String name;
  final String initials;
  final String dob;
  final String nationality;
  final String currentSchool;
  final String currentGrade;
  final double gpa;
  final int footballAfricaRank;
  final int hoursStudiedThisTerm;
  final int hoursTrainedThisTerm;
  final int testsWrittenThisTerm;
  final double avgTestScore;
  final List<SubjectGrade> grades;
  final List<SportStat> sports;
  final List<ClubAttendance> clubs;
  final List<SchoolRecord> schoolHistory;
  final String selectedCareerId;
  final Map<String, bool> completedTasks;

  StudentProfile({
    required this.id,
    required this.name,
    required this.initials,
    required this.dob,
    required this.nationality,
    required this.currentSchool,
    required this.currentGrade,
    required this.gpa,
    required this.footballAfricaRank,
    required this.hoursStudiedThisTerm,
    required this.hoursTrainedThisTerm,
    required this.testsWrittenThisTerm,
    required this.avgTestScore,
    required this.grades,
    required this.sports,
    required this.clubs,
    required this.schoolHistory,
    required this.selectedCareerId,
    required this.completedTasks,
  });

  StudentProfile copyWith({
    String? selectedCareerId,
    Map<String, bool>? completedTasks,
  }) => StudentProfile(
    id: id, name: name, initials: initials, dob: dob,
    nationality: nationality, currentSchool: currentSchool,
    currentGrade: currentGrade, gpa: gpa,
    footballAfricaRank: footballAfricaRank,
    hoursStudiedThisTerm: hoursStudiedThisTerm,
    hoursTrainedThisTerm: hoursTrainedThisTerm,
    testsWrittenThisTerm: testsWrittenThisTerm,
    avgTestScore: avgTestScore, grades: grades, sports: sports,
    clubs: clubs, schoolHistory: schoolHistory,
    selectedCareerId: selectedCareerId ?? this.selectedCareerId,
    completedTasks: completedTasks ?? this.completedTasks,
  );

  // TIER CALCULATION METHODS

  /// Get the overall education tier based on GPA and average test score
  String getEducationTierStatus() {
    final overallScore = (gpa * 10 + avgTestScore) / 2;
    return EducationTierSystem.getEducationTierStatus(overallScore);
  }

  /// Get education tier with full details
  TierDefinition getEducationTier() {
    final overallScore = (gpa * 10 + avgTestScore) / 2;
    return EducationTierSystem.getTierForScore(overallScore);
  }

  /// Get the tier for a specific subject grade
  TierDefinition getSubjectTier(String subject) {
    try {
      final subjectGrade = grades.firstWhere((g) => g.subject == subject);
      return EducationTierSystem.getTierForScore(subjectGrade.score);
    } catch (_) {
      return EducationTierSystem.getTierForScore(0);
    }
  }

  /// Get the overall sports tier based on performance metrics
  String getSportsTierStatus() {
    if (sports.isEmpty) return '📚 N/A';
    final sport = sports.first;
    final performanceScore = SportsTierSystem.calculateOverallSportsPerformance(
      goals: sport.goals,
      assists: sport.assists,
      gamesPlayed: sport.gamesPlayed,
      hoursTrainedThisTerm: sport.hoursTrainedThisTerm,
      tournamentsAttended: sport.tournamentsAttended,
      topSpeed: sport.topSpeed,
    );
    return SportsTierSystem.getSportsTierStatus(performanceScore);
  }

  /// Get sports tier with full details
  TierDefinition getSportsTier() {
    if (sports.isEmpty) return SportsTierSystem.getTierForScore(0);
    final sport = sports.first;
    final performanceScore = SportsTierSystem.calculateOverallSportsPerformance(
      goals: sport.goals,
      assists: sport.assists,
      gamesPlayed: sport.gamesPlayed,
      hoursTrainedThisTerm: sport.hoursTrainedThisTerm,
      tournamentsAttended: sport.tournamentsAttended,
      topSpeed: sport.topSpeed,
    );
    return SportsTierSystem.getTierForScore(performanceScore);
  }

  /// Get the tier for a specific sport
  TierDefinition getSpecificSportTier(int sportIndex) {
    if (sports.isEmpty || sportIndex >= sports.length) {
      return SportsTierSystem.getTierForScore(0);
    }
    final sport = sports[sportIndex];
    final performanceScore = SportsTierSystem.calculateOverallSportsPerformance(
      goals: sport.goals,
      assists: sport.assists,
      gamesPlayed: sport.gamesPlayed,
      hoursTrainedThisTerm: sport.hoursTrainedThisTerm,
      tournamentsAttended: sport.tournamentsAttended,
      topSpeed: sport.topSpeed,
    );
    return SportsTierSystem.getTierForScore(performanceScore);
  }

  /// Calculate sports performance percentage for a specific sport
  double calculateSportsPerformancePercentage(int sportIndex) {
    if (sports.isEmpty || sportIndex >= sports.length) return 0.0;
    final sport = sports[sportIndex];
    return SportsTierSystem.calculateOverallSportsPerformance(
      goals: sport.goals,
      assists: sport.assists,
      gamesPlayed: sport.gamesPlayed,
      hoursTrainedThisTerm: sport.hoursTrainedThisTerm,
      tournamentsAttended: sport.tournamentsAttended,
      topSpeed: sport.topSpeed,
    );
  }

  /// Calculate overall education performance percentage
  double calculateEducationPerformancePercentage() {
    return (gpa * 10 + avgTestScore) / 2;
  }
}

class AppState extends ChangeNotifier {
  String _userType = '';
  StudentProfile _student = _defaultStudent;

  String get userType => _userType;
  StudentProfile get student => _student;

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }

  void selectCareer(String careerId) {
    _student = _student.copyWith(selectedCareerId: careerId, completedTasks: {});
    notifyListeners();
  }

  void toggleTask(String taskId) {
    final updated = Map<String, bool>.from(_student.completedTasks);
    updated[taskId] = !(updated[taskId] ?? false);
    _student = _student.copyWith(completedTasks: updated);
    notifyListeners();
  }

  CareerPath? get selectedCareer {
    try {
      return CareerData.all.firstWhere((c) => c.id == _student.selectedCareerId);
    } catch (_) {
      return null;
    }
  }

  int completedCount(List<CareerGoal> goals) =>
    goals.where((g) => _student.completedTasks[g.id] == true).length;
}

final _defaultStudent = StudentProfile(
  id: 'LC-2024-ZW-00412',
  name: 'Takudzwa Moyo',
  initials: 'TM',
  dob: '14 March 2007',
  nationality: 'Zimbabwean',
  currentSchool: 'Watershed College',
  currentGrade: 'Form 6',
  gpa: 3.2,
  footballAfricaRank: 3,
  hoursStudiedThisTerm: 96,
  hoursTrainedThisTerm: 184,
  testsWrittenThisTerm: 12,
  avgTestScore: 84.0,
  selectedCareerId: 'neurosurgeon',
  completedTasks: {},
  grades: const [
    SubjectGrade(subject: 'Biology', score: 88, grade: 'A', term: 'Term 2, 2025', verified: true),
    SubjectGrade(subject: 'Mathematics', score: 71, grade: 'B-', term: 'Term 2, 2025', verified: true),
    SubjectGrade(subject: 'Chemistry', score: 79, grade: 'B+', term: 'Term 2, 2025', verified: true),
    SubjectGrade(subject: 'English', score: 75, grade: 'B', term: 'Term 2, 2025', verified: true),
    SubjectGrade(subject: 'Physics', score: 82, grade: 'A-', term: 'Term 2, 2025', verified: true),
    SubjectGrade(subject: 'History', score: 68, grade: 'C+', term: 'Term 2, 2025', verified: true),
  ],
  sports: const [
    SportStat(
      sport: 'Football', position: 'Striker',
      gamesPlayed: 28, goals: 34, assists: 12,
      topSpeed: 31.4, hoursTrainedThisTerm: 184,
      tournamentsAttended: 6, careerGoals: 147,
      achievementsThisSeason: ['Easter Schools Cup Champions', 'Zim Schools Cup Runners Up', 'Hat-trick vs Peterhouse'],
    ),
  ],
  clubs: const [
    ClubAttendance(clubName: 'Science Club', sessionsAttended: 8, totalSessions: 10, category: 'Academic'),
    ClubAttendance(clubName: 'Chess Club', sessionsAttended: 7, totalSessions: 10, category: 'Strategy'),
    ClubAttendance(clubName: 'Debate Club', sessionsAttended: 5, totalSessions: 10, category: 'Leadership'),
    ClubAttendance(clubName: 'Community Service', sessionsAttended: 4, totalSessions: 8, category: 'Service'),
  ],
  schoolHistory: const [
    SchoolRecord(schoolName: 'Glen Norah Primary', location: 'Harare, Zimbabwe', fromYear: '2013', toYear: '2018', current: false, grade: 'Grade 1–7'),
    SchoolRecord(schoolName: 'Watershed College', location: 'Marondera, Zimbabwe', fromYear: '2019', toYear: 'Present', current: true, grade: 'Form 1–6'),
  ],
);

Color gradeColor(String grade) {
  if (grade.startsWith('A')) return LCColors.primary;
  if (grade.startsWith('B')) return LCColors.blue;
  if (grade.startsWith('C')) return LCColors.gold;
  return LCColors.red;
}
