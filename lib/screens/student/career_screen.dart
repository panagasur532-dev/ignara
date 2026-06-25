import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../data/careers.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});
  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = ['All', ...CareerData.byCategory.keys];
    final filtered = _selectedCategory == 'All'
        ? CareerData.all
        : CareerData.byCategory[_selectedCategory] ?? [];

    return Column(children: [
      // Category filter chips
      Container(
        height: 44,
        color: LCColors.bg,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = categories[i];
            final active = cat == _selectedCategory;
            final color = cat == 'All' ? LCColors.primary : CareerData.categoryColor(cat);
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? color.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: active ? color.withOpacity(0.5) : LCColors.border),
                ),
                child: Text(cat,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                    color: active ? color : LCColors.textSecondary)),
              ),
            );
          },
        ),
      ),
      const Divider(height: 1, color: LCColors.border),

      // Career list
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: filtered.length + 1,
        itemBuilder: (_, i) {
          if (i == filtered.length) return const SizedBox(height: 20);
          final career = filtered[i];
          final selected = state.student.selectedCareerId == career.id;
          final status = career.getStatus(state.student.gpa, state.student.footballAfricaRank);
          final readiness = career.getReadiness(state.student.gpa, state.student.footballAfricaRank);

          return GestureDetector(
            onTap: () {
              state.selectCareer(career.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Goal set: ${career.title}'),
                backgroundColor: career.color,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected ? career.color.withOpacity(0.06) : LCColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? career.color.withOpacity(0.4) : LCColors.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: career.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(career.icon, color: career.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(career.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(career.subtitle,
                      style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    LCPill(status.label, status.color),
                    if (selected) ...[
                      const SizedBox(height: 4),
                      LCPill('✓ Selected', career.color),
                    ],
                  ]),
                ]),
                const SizedBox(height: 12),

                // Readiness bar
                Row(children: [
                  const Text('Readiness ', style: TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                  Expanded(child: LCProgressBar(value: readiness, color: status.color, height: 6)),
                  const SizedBox(width: 8),
                  Text('${(readiness * 100).toInt()}%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: status.color)),
                ]),
                const SizedBox(height: 10),

                // Required subjects & key info
                Text(career.description,
                  style: const TextStyle(fontSize: 12, color: LCColors.textSecondary, height: 1.5)),
                const SizedBox(height: 10),

                // Required subjects
                Wrap(spacing: 6, runSpacing: 6, children: [
                  ...career.requiredSubjects.take(3).map((s) =>
                    LCPill(s, LCColors.blue)),
                  if (career.requiredSubjects.length > 3)
                    LCPill('+${career.requiredSubjects.length - 3} more', LCColors.textDim),
                ]),
                const SizedBox(height: 10),

                // Min requirement
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: LCColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: LCColors.border),
                  ),
                  child: Row(children: [
                    Expanded(child: _reqChip(
                      career.minSportRank > 0 ? 'Sport rank required' : 'Min GPA required',
                      career.minSportRank > 0 ? 'Top ${career.minSportRank.toInt()}' : career.minGPA.toStringAsFixed(1),
                      career.color,
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _reqChip('Training', career.trainingYears, LCColors.textSecondary)),
                    const SizedBox(width: 8),
                    Expanded(child: _reqChip('Tasks', '${career.dailyGoals.length}d / ${career.weeklyGoals.length}w', LCColors.gold)),
                  ]),
                ),
              ]),
            ),
          );
        },
      )),
    ]);
  }

  Widget _reqChip(String label, String value, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: LCColors.textDim)),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
    ]);
  }
}
