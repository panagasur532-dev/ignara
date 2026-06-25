import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../models/tier_system.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';
import 'goals_screen.dart';
import 'career_screen.dart';
import 'evaluation_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});
  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _tab = 0;

  static const _tabs = [
    _Tab(Icons.person_outline, 'Profile'),
    _Tab(Icons.checklist_outlined, 'Tasks'),
    _Tab(Icons.track_changes_outlined, 'Career'),
    _Tab(Icons.bar_chart_outlined, 'Eval'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.student;
    return Scaffold(
      backgroundColor: LCColors.bg,
      body: Column(children: [
        LCTopBar(
          brand: 'Life Cycle',
          title: _tabs[_tab].label,
          trailing: LCAvatar(initials: s.initials, size: 34, color: LCColors.primary),
        ),
        const Divider(height: 1, color: LCColors.border),
        Expanded(child: IndexedStack(index: _tab, children: [
          const _ProfileTab(),
          GoalsScreen(onSelectCareer: () => setState(() => _tab = 2)),
          const CareerScreen(),
          EvaluationScreen(onSelectCareer: () => setState(() => _tab = 2)),
        ])),
      ]),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: LCColors.bg,
        border: Border(top: BorderSide(color: LCColors.border)),
      ),
      child: SafeArea(
        child: Row(children: List.generate(_tabs.length, (i) {
          final active = i == _tab;
          final color = active ? LCColors.primary : LCColors.textDim;
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => _tab = i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(_tabs[i].icon, color: color, size: 22),
                const SizedBox(height: 3),
                Text(_tabs[i].label, style: TextStyle(fontSize: 10, color: color, fontWeight: active ? FontWeight.w500 : FontWeight.w400)),
              ]),
            ),
          ));
        })),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final String label;
  const _Tab(this.icon, this.label);
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>().student;
    return ListView(padding: const EdgeInsets.all(14), children: [

      // Identity card
      LCCard(child: Row(children: [
        LCAvatar(initials: s.initials, size: 54, color: LCColors.primary),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('${s.currentSchool} · ${s.currentGrade}', style: const TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, children: [
            LCPill('⚽ Africa #${s.footballAfricaRank}', LCColors.primary),
            LCPill('GPA ${s.gpa}', LCColors.blue),
          ]),
        ])),
      ])),

      // PERFORMANCE TIERS SECTION
      const LCSectionLabel('Performance Tiers'),
      GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.4,
        children: [
          _buildTierCard(
            title: 'Academic',
            tier: s.getEducationTier(),
            performance: s.calculateEducationPerformancePercentage(),
            icon: '📚',
          ),
          _buildTierCard(
            title: 'Athletic',
            tier: s.getSportsTier(),
            performance: s.sports.isNotEmpty ? s.calculateSportsPerformancePercentage(0) : 0,
            icon: '⚽',
          ),
        ],
      ),

      // ID
      LCCard(child: Column(children: [
        _infoRow('Life Cycle ID', s.id, LCColors.blue),
        _infoRow('Date of birth', s.dob, LCColors.textPrimary),
        _infoRow('Nationality', s.nationality, LCColors.textPrimary),
        _infoRow('Member since', '2013 · Age 6', LCColors.textPrimary),
      ])),

      // Quick stats
      const LCSectionLabel('This term at a glance'),
      GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        children: [
          LCStatBox(label: 'Hours trained', value: '${s.hoursTrainedThisTerm}', valueColor: LCColors.primary, sub: 'this term'),
          LCStatBox(label: 'Hours studied', value: '${s.hoursStudiedThisTerm}', valueColor: LCColors.blue, sub: 'this term'),
          LCStatBox(label: 'Tests written', value: '${s.testsWrittenThisTerm}', valueColor: LCColors.gold, sub: 'avg ${s.avgTestScore.toInt()}%'),
          LCStatBox(label: 'Career goals', value: '${s.sports.isNotEmpty ? s.sports.first.careerGoals : 0}', valueColor: LCColors.primary, sub: 'all time ⚽'),
        ],
      ),

      // Grades
      const LCSectionLabel('Academic record'),
      LCCard(child: Column(children: [
        Row(children: [
          const Text('Current grades', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          LCPill('✓ Verified', LCColors.primary),
        ]),
        const SizedBox(height: 12),
        ...s.grades.map((g) {
          final subjectTier = s.getSubjectTier(g.subject);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Expanded(child: Text(g.subject, style: const TextStyle(fontSize: 13))),
                    LCTierBadge(tier: subjectTier, imageSize: 14, compact: true),
                  ],
                ),
                const SizedBox(height: 4),
                LCProgressBar(value: g.score / 100, color: gradeColor(g.grade), height: 5),
              ])),
              const SizedBox(width: 12),
              Text('${g.grade}  ${g.score.toInt()}%',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: gradeColor(g.grade))),
            ]),
          );
        }),
      ])),

      // Sport stats
      if (s.sports.isNotEmpty) ...[
        const LCSectionLabel('Sports record'),
        ...List.generate(s.sports.length, (idx) {
          final sp = s.sports[idx];
          final sportTier = s.getSpecificSportTier(idx);
          final sportPerformance = s.calculateSportsPerformancePercentage(idx);
          return LCCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(
                color: LCColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text('⚽', style: TextStyle(fontSize: 20)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${sp.sport} · ${sp.position}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text('${sp.tournamentsAttended} tournaments · ${sp.hoursTrainedThisTerm} hrs trained', style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
              ])),
              LCTierBadge(tier: sportTier, imageSize: 16),
            ]),
            const SizedBox(height: 12),
            // Performance bar
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Performance', style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: sportPerformance / 100,
                        minHeight: 6,
                        backgroundColor: LCColors.border,
                        valueColor: AlwaysStoppedAnimation(sportTier.color),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 12),
                Text('${sportPerformance.toInt()}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sportTier.color)),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.0,
              children: [
                LCStatBox(label: 'Career goals', value: '${sp.careerGoals}', valueColor: LCColors.primary),
                LCStatBox(label: 'This season', value: '${sp.goals} goals', valueColor: LCColors.primary),
                LCStatBox(label: 'Assists', value: '${sp.assists}', valueColor: LCColors.blue),
                LCStatBox(label: 'Top speed', value: '${sp.topSpeed} km/h', valueColor: LCColors.red),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Season highlights', style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
            const SizedBox(height: 6),
            ...sp.achievementsThisSeason.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(children: [
                const Icon(Icons.star_outline, size: 14, color: LCColors.gold),
                const SizedBox(width: 6),
                Text(a, style: const TextStyle(fontSize: 12)),
              ]),
            )),
          ]));
        }),
      ],

      // Clubs
      const LCSectionLabel('Clubs & extracurriculars'),
      LCCard(child: Column(children: s.clubs.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.clubName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('${c.sessionsAttended}/${c.totalSessions} sessions · ${c.category}',
                style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
            ])),
            Text('${(c.attendanceRate * 100).toInt()}%',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                color: c.attendanceRate > 0.7 ? LCColors.primary : LCColors.gold)),
          ]),
          const SizedBox(height: 6),
          LCProgressBar(value: c.attendanceRate, color: c.attendanceRate > 0.7 ? LCColors.primary : LCColors.gold),
        ]),
      )).toList())),

      // Schools attended
      const LCSectionLabel('Schools attended'),
      LCCard(child: Column(children: s.schoolHistory.map((sch) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(
              shape: BoxShape.circle, color: sch.current ? LCColors.primary : LCColors.textDim)),
            if (!sch.current) Container(width: 2, height: 30, color: LCColors.border),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(sch.schoolName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              if (sch.current) LCPill('Current', LCColors.primary),
            ]),
            Text('${sch.grade} · ${sch.fromYear}–${sch.toYear} · ${sch.location}',
              style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
          ])),
        ]),
      )).toList())),

      const SizedBox(height: 20),
    ]);
  }

  /// Build a tier card showing tier status and performance
  Widget _buildTierCard({
    required String title,
    required TierDefinition tier,
    required double performance,
    required String icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: tier.color.withOpacity(0.3), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tier.color.withOpacity(0.08),
            tier.color.withOpacity(0.02),
          ],
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
              const SizedBox(height: 6),
              Row(
                children: [
                  LCTierImage(tier: tier, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(tier.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: tier.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: performance / 100,
                        minHeight: 4,
                        backgroundColor: LCColors.border,
                        valueColor: AlwaysStoppedAnimation(tier.color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('${performance.toInt()}%',
                    style: TextStyle(fontSize: 10, color: tier.color, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: LCColors.textSecondary))),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: valueColor)),
      ]),
    );
  }
}
