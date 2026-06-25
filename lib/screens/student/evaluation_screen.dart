import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../data/careers.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';

class EvaluationScreen extends StatelessWidget {
  final VoidCallback? onSelectCareer;
  const EvaluationScreen({super.key, this.onSelectCareer});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final career = state.selectedCareer;
    final student = state.student;

    if (career == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a career goal to see your evaluation', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onSelectCareer ?? () {},
                child: const Text('Choose a career path'),
              ),
            ],
          ),
        ),
      );
    }

    final status = career.getStatus(student.gpa, student.footballAfricaRank);
    final readiness = career.getReadiness(student.gpa, student.footballAfricaRank);
    final gapGPA = career.minGPA - student.gpa;

    return ListView(padding: const EdgeInsets.all(14), children: [

      // Header status card
      LCCard(
        borderColor: status.color.withOpacity(0.35),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 44, height: 44,
              decoration: BoxDecoration(
                color: career.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
              child: Icon(career.icon, color: career.color, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(career.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              Row(children: [
                const Text('Status: ', style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
                Text(status.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: status.color)),
              ]),
            ])),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Text('Overall readiness: ${(readiness * 100).toInt()}%',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text('${(readiness * 100).toInt()}%',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: status.color)),
          ]),
          const SizedBox(height: 6),
          LCProgressBar(value: readiness, color: status.color, height: 8),
        ]),
      ),

      // Life Cycle assessment message
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: status.color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: status.color.withOpacity(0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(_statusIcon(status), color: status.color, size: 16),
            const SizedBox(width: 8),
            Text('Life Cycle Assessment',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: status.color)),
          ]),
          const SizedBox(height: 8),
          Text(_assessmentText(career, student, gapGPA),
            style: const TextStyle(fontSize: 12, color: LCColors.textSecondary, height: 1.6)),
        ]),
      ),

      // Gap analysis
      const LCSectionLabel('What you need to close the gap'),
      LCCard(child: Column(children: [
        ..._buildGapItems(career, student, gapGPA),
      ])),

      // Subject performance vs career requirements
      const LCSectionLabel('Subject performance vs requirements'),
      LCCard(child: Column(children: career.requiredSubjects.map((subject) {
        final matchingGrades = student.grades.where((g) => g.subject.toLowerCase() == subject.toLowerCase()).toList();
        final grade = matchingGrades.isNotEmpty ? matchingGrades.first : null;
        final hasGrade = grade != null;
        final score = hasGrade ? grade.score : 0.0;
        final isGood = score >= 75;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(isGood ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                size: 14, color: isGood ? LCColors.primary : LCColors.gold),
              const SizedBox(width: 8),
              Expanded(child: Text(subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              Text(hasGrade ? '${grade.grade} · ${grade.score.toInt()}%' : 'Not logged',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                  color: hasGrade ? gradeColor(grade.grade) : LCColors.textDim)),
            ]),
            const SizedBox(height: 6),
            LCProgressBar(
              value: hasGrade ? score / 100 : 0,
              color: hasGrade ? gradeColor(grade.grade) : LCColors.border,
              height: 5,
            ),
          ]),
        );
      }).toList())),

      // Schools you currently qualify for
      const LCSectionLabel('Schools you currently qualify for'),
      ..._buildSchoolCards(career, student, qualify: true),

      // Schools you don't qualify for yet
      const LCSectionLabel('Schools you don\'t qualify for yet'),
      ..._buildSchoolCards(career, student, qualify: false),

      // What unlocks if you hit the target GPA
      if (gapGPA > 0) ...[
        LCSectionLabel('Unlock if you raise GPA to ${career.minGPA.toStringAsFixed(1)}+'),
        LCCard(
          borderColor: LCColors.purple.withOpacity(0.3),
          child: Column(children: [
            ...career.targetUniversities.skip(2).map((uni) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(children: [
                const Icon(Icons.lock_open_outlined, size: 14, color: LCColors.purple),
                const SizedBox(width: 10),
                Expanded(child: Text(uni, style: const TextStyle(fontSize: 13))),
                LCPill('Unlocks', LCColors.purple),
              ]),
            )),
            ...career.scholarshipTypes.map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(children: [
                const Icon(Icons.lock_open_outlined, size: 14, color: LCColors.purple),
                const SizedBox(width: 10),
                Expanded(child: Text('$s scholarship', style: const TextStyle(fontSize: 13))),
                LCPill('Scholarship', LCColors.purple),
              ]),
            )),
          ]),
        ),
      ],

      // Alternative careers based on current stats
      const LCSectionLabel('Alternative paths matching your current stats'),
      ..._buildAlternativePaths(context, career, student),

      // Monthly goal to raise GPA
      const LCSectionLabel('Your monthly target'),
      LCCard(
        borderColor: LCColors.primary.withOpacity(0.3),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.flag_outlined, size: 16, color: LCColors.primary),
            SizedBox(width: 8),
            Text('To reach your goal this year', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 12),
          _targetRow('Daily study hours', '${career.dailyGoals.where((g) => g.category == GoalCategory.academic).length * 2}+ hrs/day', LCColors.blue),
          _targetRow('Weekly tasks', '${career.weeklyGoals.length} tasks completed', LCColors.gold),
          _targetRow('Club attendance', '80%+ every week', LCColors.purple),
          _targetRow('Monthly mock exam', 'Track GPA progress', LCColors.primary),
          if (career.minGPA > student.gpa)
            _targetRow('GPA target', '${career.minGPA.toStringAsFixed(1)}+ by year end', LCColors.red),
        ]),
      ),

      const SizedBox(height: 20),
    ]);
  }

  Widget _targetRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
      ]),
    );
  }

  IconData _statusIcon(CareerStatus s) {
    switch (s) {
      case CareerStatus.strong: return Icons.check_circle_outline;
      case CareerStatus.onTrack: return Icons.check_circle_outline;
      case CareerStatus.possible: return Icons.info_outline;
      case CareerStatus.atRisk: return Icons.warning_amber_outlined;
    }
  }

  String _assessmentText(CareerPath career, StudentProfile student, double gapGPA) {
    if (gapGPA <= 0) {
      return 'Your GPA of ${student.gpa} meets the minimum requirement of ${career.minGPA} for ${career.title}. You are on track. Keep maintaining your academic performance and complete your daily tasks to stay competitive.';
    } else if (gapGPA <= 0.3) {
      return 'Your GPA of ${student.gpa} is ${gapGPA.toStringAsFixed(1)} below the ${career.minGPA} minimum for ${career.title}. This is recoverable. With consistent effort on your daily tasks, particularly in your weaker subjects, you can close this gap within ${student.currentGrade.contains('6') ? 'this academic year' : '1-2 terms'}.';
    } else {
      return 'Your current GPA of ${student.gpa} is ${gapGPA.toStringAsFixed(1)} below the minimum ${career.minGPA} required for most ${career.title} programmes. This is a significant gap. You should consider the alternative paths listed below which better match your current profile, while working intensively on the gap items listed.';
    }
  }

  List<Widget> _buildGapItems(CareerPath career, StudentProfile student, double gapGPA) {
    final items = <_GapItem>[];

    // GPA gap
    if (gapGPA > 0) {
      items.add(_GapItem(
        false,
        'Raise GPA from ${student.gpa} → ${career.minGPA}',
        gapGPA <= 0.3 ? 'Achievable with consistent daily study' : 'Significant effort required across all subjects',
      ));
    } else {
      items.add(_GapItem(true, 'GPA meets minimum requirement', 'Current GPA ${student.gpa} ≥ ${career.minGPA}'));
    }

    // Weakest subjects
    final weakSubjects = student.grades.where((g) => g.score < 75).toList();
    for (final ws in weakSubjects.take(2)) {
      items.add(_GapItem(
        false,
        '${ws.subject} must reach 75%+',
        'Currently ${ws.grade} (${ws.score.toInt()}%) — drag on GPA',
      ));
    }

    // Strong subjects
    final strongSubjects = student.grades.where((g) => g.score >= 85).toList();
    for (final ss in strongSubjects.take(1)) {
      items.add(_GapItem(true, '${ss.subject} · on track', 'Currently ${ss.grade} (${ss.score.toInt()}%) — keep it up'));
    }

    // Club requirements
    final lowClubs = student.clubs.where((c) => c.attendanceRate < 0.7).toList();
    if (lowClubs.isNotEmpty) {
      items.add(_GapItem(false, 'Improve ${lowClubs.first.clubName} attendance',
        '${(lowClubs.first.attendanceRate * 100).toInt()}% — target 80%+'));
    }

    // Community service for med/law/politics
    if (['neurosurgeon','gp','nurse','lawyer','politician','diplomat'].contains(career.id)) {
      final hasService = student.clubs.any((c) => c.clubName.toLowerCase().contains('service'));
      if (!hasService) {
        items.add(_GapItem(false, 'Join a community service club',
          '${career.title} programmes require demonstrated service'));
      }
    }

    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LCColors.surfaceAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: LCColors.border),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(item.met ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 16, color: item.met ? LCColors.primary : LCColors.gold),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              color: item.met ? LCColors.textSecondary : LCColors.textPrimary)),
            Text(item.subtitle, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
          ])),
        ]),
      ),
    )).toList();
  }

  List<Widget> _buildSchoolCards(CareerPath career, StudentProfile student, {required bool qualify}) {
    // Simulate qualification based on GPA bands
    final unis = career.targetUniversities;
    final qualified = <String>[];
    final notQualified = <String>[];
    final gpaThresholds = [3.0, 3.3, 3.5, 3.7, 3.8];

    for (var i = 0; i < unis.length; i++) {
      final threshold = gpaThresholds[i % gpaThresholds.length];
      if (student.gpa >= threshold) {
        qualified.add(unis[i]);
      } else {
        notQualified.add(unis[i]);
      }
    }

    final list = qualify ? qualified : notQualified;
    if (list.isEmpty) return [];

    return list.map((uni) {
      final threshold = gpaThresholds[unis.indexOf(uni) % gpaThresholds.length];
      final gap = threshold - student.gpa;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: LCColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: qualify ? LCColors.primary.withOpacity(0.3) : LCColors.red.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(uni, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            LCPill(qualify ? 'Qualifies ✓' : 'Does not qualify', qualify ? LCColors.primary : LCColors.red),
          ]),
          const SizedBox(height: 6),
          Text(qualify
            ? '${career.title} · Min GPA ${threshold.toStringAsFixed(1)} · Your GPA ${student.gpa}'
            : '${career.title} · Min GPA ${threshold.toStringAsFixed(1)} · You need +${gap.toStringAsFixed(1)} GPA',
            style: const TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          const SizedBox(height: 8),
          LCProgressBar(
            value: (student.gpa / threshold).clamp(0.0, 1.0),
            color: qualify ? LCColors.primary : LCColors.red,
            height: 6,
          ),
        ]),
      );
    }).toList();
  }

  List<Widget> _buildAlternativePaths(BuildContext context, CareerPath current, StudentProfile student) {
    final alternatives = CareerData.all
      .where((c) => c.id != current.id)
      .map((c) => MapEntry(c, c.getReadiness(student.gpa, student.footballAfricaRank)))
      .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return alternatives.take(3).map((entry) {
      final c = entry.key;
      final readiness = entry.value;
      final status = c.getStatus(student.gpa, student.footballAfricaRank);
      return GestureDetector(
        onTap: () {
          context.read<AppState>().selectCareer(c.id);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Career changed to ${c.title}'),
            backgroundColor: c.color,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: LCColors.surfaceAlt,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: status.color.withOpacity(0.3)),
          ),
          child: Row(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(
                color: c.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Icon(c.icon, color: c.color, size: 18)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(c.subtitle, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${(readiness * 100).toInt()}% ready',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: status.color)),
              LCPill(status.label, status.color),
            ]),
          ]),
        ),
      );
    }).toList();
  }
}

class _GapItem {
  final bool met;
  final String title;
  final String subtitle;
  const _GapItem(this.met, this.title, this.subtitle);
}
