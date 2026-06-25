import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../data/careers.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';

class GoalsScreen extends StatefulWidget {
  final VoidCallback? onSelectCareer;
  const GoalsScreen({super.key, this.onSelectCareer});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  GoalFrequency _freq = GoalFrequency.daily;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final career = state.selectedCareer;
    if (career == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a career goal first', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: widget.onSelectCareer ?? () {},
                child: const Text('Choose a career'),
              ),
            ],
          ),
        ),
      );
    }

    final goals = _freq == GoalFrequency.daily ? career.dailyGoals
      : _freq == GoalFrequency.weekly ? career.weeklyGoals
      : career.monthlyGoals;

    final completed = state.completedCount(goals);
    final progress = goals.isEmpty ? 0.0 : completed / goals.length;

    return ListView(padding: const EdgeInsets.all(14), children: [

      // Career header
      LCCard(
        borderColor: career.color.withOpacity(0.35),
        child: Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(
            color: career.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(career.icon, color: career.color, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Goal: ${career.title}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text(career.subtitle, style: const TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          ])),
          LCPill(
            career.getStatus(context.watch<AppState>().student.gpa, context.watch<AppState>().student.footballAfricaRank).label,
            career.getStatus(context.watch<AppState>().student.gpa, context.watch<AppState>().student.footballAfricaRank).color,
          ),
        ]),
      ),

      // Frequency switcher
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: LCColors.surfaceAlt, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LCColors.border)),
        child: Row(children: GoalFrequency.values.map((f) {
          final active = f == _freq;
          final label = f == GoalFrequency.daily ? 'Daily' : f == GoalFrequency.weekly ? 'Weekly' : 'Monthly';
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => _freq = f),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: active ? LCColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(7)),
              child: Text(label, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                  color: active ? LCColors.bg : LCColors.textSecondary)),
            ),
          ));
        }).toList()),
      ),

      // Progress
      LCCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${_freq.name[0].toUpperCase()}${_freq.name.substring(1)} progress',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text('$completed / ${goals.length}', style: const TextStyle(fontSize: 13, color: LCColors.primary, fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 8),
        LCProgressBar(value: progress, color: LCColors.primary, height: 8),
        if (progress == 1.0) ...[
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
            color: LCColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8),
            border: Border.all(color: LCColors.primary.withOpacity(0.3))),
            child: const Row(children: [
              Icon(Icons.check_circle_outline, color: LCColors.primary, size: 16),
              SizedBox(width: 8),
              Text('All done! +12 readiness points earned', style: TextStyle(fontSize: 12, color: LCColors.primary)),
            ])),
        ],
      ])),

      // Tasks by category
      ..._buildGoalGroups(goals, state),

      // Recommended clubs for this career
      const LCSectionLabel('Recommended clubs for this path'),
      LCCard(child: Column(children: career.recommendedClubs.map((club) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          const Icon(Icons.groups_outlined, size: 16, color: LCColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(child: Text(club, style: const TextStyle(fontSize: 13))),
          LCPill('Recommended', LCColors.gold),
        ]),
      )).toList())),

      const SizedBox(height: 20),
    ]);
  }

  List<Widget> _buildGoalGroups(List<CareerGoal> goals, AppState state) {
    final groups = <GoalCategory, List<CareerGoal>>{};
    for (final g in goals) groups.putIfAbsent(g.category, () => []).add(g);

    return groups.entries.map((e) {
      final cat = e.key;
      final catGoals = e.value;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LCSectionLabel(_categoryLabel(cat)),
        LCCard(
          borderColor: _categoryColor(cat).withOpacity(0.3),
          child: Column(children: catGoals.map((goal) {
            final done = state.student.completedTasks[goal.id] == true;
            return GestureDetector(
              onTap: () => state.toggleTask(goal.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: done ? LCColors.primary : Colors.transparent,
                      border: Border.all(color: done ? LCColors.primary : LCColors.border, width: 1.5)),
                    child: done ? const Icon(Icons.check, size: 14, color: LCColors.bg) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(goal.title,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                        color: done ? LCColors.textSecondary : LCColors.textPrimary,
                        decoration: done ? TextDecoration.lineThrough : null)),
                    const SizedBox(height: 3),
                    Text(goal.description, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                    const SizedBox(height: 6),
                    LCPill(_categoryShortLabel(cat), _categoryColor(cat)),
                  ])),
                ]),
              ),
            );
          }).toList()),
        ),
      ]);
    }).toList();
  }

  String _categoryLabel(GoalCategory c) {
    switch (c) {
      case GoalCategory.academic: return 'Academic';
      case GoalCategory.sport: return 'Sport & Fitness';
      case GoalCategory.extracurricular: return 'Clubs & Activities';
      case GoalCategory.entrepreneurship: return 'Entrepreneurship';
      case GoalCategory.leadership: return 'Leadership';
      case GoalCategory.creative: return 'Creative';
      case GoalCategory.technical: return 'Technical Skills';
    }
  }

  String _categoryShortLabel(GoalCategory c) {
    switch (c) {
      case GoalCategory.academic: return 'Academic';
      case GoalCategory.sport: return 'Sport';
      case GoalCategory.extracurricular: return 'Extracurricular';
      case GoalCategory.entrepreneurship: return 'Entrepreneurship';
      case GoalCategory.leadership: return 'Leadership';
      case GoalCategory.creative: return 'Creative';
      case GoalCategory.technical: return 'Technical';
    }
  }

  Color _categoryColor(GoalCategory c) {
    switch (c) {
      case GoalCategory.academic: return LCColors.blue;
      case GoalCategory.sport: return LCColors.primary;
      case GoalCategory.extracurricular: return LCColors.gold;
      case GoalCategory.entrepreneurship: return LCColors.gold;
      case GoalCategory.leadership: return LCColors.purple;
      case GoalCategory.creative: return LCColors.purple;
      case GoalCategory.technical: return LCColors.blue;
    }
  }
}
