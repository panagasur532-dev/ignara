import 'package:flutter/material.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';

class SchoolDashboard extends StatefulWidget {
  const SchoolDashboard({super.key});
  @override
  State<SchoolDashboard> createState() => _SchoolDashboardState();
}

class _SchoolDashboardState extends State<SchoolDashboard> {
  int _tab = 0;
  static const _tabs = [
    _Tab(Icons.dashboard_outlined, 'Overview'),
    _Tab(Icons.people_outline, 'Students'),
    _Tab(Icons.insights_outlined, 'Analytics'),
    _Tab(Icons.settings_outlined, 'Admin'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LCColors.bg,
      body: Column(children: [
        LCTopBar(
          brand: 'Life Cycle',
          title: _tabs[_tab].label,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: LCColors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LCColors.red.withOpacity(0.3)),
            ),
            child: const Text('School Admin', style: TextStyle(fontSize: 11, color: LCColors.red, fontWeight: FontWeight.w500)),
          ),
        ),
        const Divider(height: 1, color: LCColors.border),
        Expanded(child: IndexedStack(index: _tab, children: const [
          _OverviewTab(),
          _StudentsTab(),
          _AnalyticsTab(),
          _AdminTab(),
        ])),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LCColors.bg,
          border: Border(top: BorderSide(color: LCColors.border)),
        ),
        child: SafeArea(child: Row(children: List.generate(_tabs.length, (i) {
          final active = i == _tab;
          final color = active ? LCColors.red : LCColors.textDim;
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => _tab = i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(_tabs[i].icon, color: color, size: 22),
                const SizedBox(height: 3),
                Text(_tabs[i].label, style: TextStyle(fontSize: 10, color: color,
                  fontWeight: active ? FontWeight.w500 : FontWeight.w400)),
              ]),
            ),
          ));
        }))),
      ),
    );
  }
}

class _Tab { final IconData icon; final String label; const _Tab(this.icon, this.label); }

// ─── OVERVIEW ────────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      // School identity
      LCCard(child: Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(
          color: LCColors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LCColors.red.withOpacity(0.3))),
          child: const Center(child: Text('🏫', style: TextStyle(fontSize: 26)))),
        const SizedBox(width: 14),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Watershed College', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Text('Marondera, Zimbabwe · Est. 1947', style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          SizedBox(height: 6),
        ])),
      ])),

      // Key numbers
      const LCSectionLabel('School overview'),
      GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        children: const [
          LCStatBox(label: 'Total students', value: '847', valueColor: LCColors.red, sub: 'enrolled'),
          LCStatBox(label: 'Active teachers', value: '64', valueColor: LCColors.blue, sub: 'on platform'),
          LCStatBox(label: 'Scout views', value: '238', valueColor: LCColors.gold, sub: 'this month'),
          LCStatBox(label: 'Avg school GPA', value: '3.41', valueColor: LCColors.primary, sub: 'all students'),
          LCStatBox(label: 'Tasks completed', value: '6,421', valueColor: LCColors.primary, sub: 'this term'),
          LCStatBox(label: 'Opportunities', value: '14', valueColor: LCColors.purple, sub: 'this month'),
        ],
      ),

      // Top students
      const LCSectionLabel('Top students this term'),
      LCCard(child: Column(children: [
        _topRow('🥇', 'Takudzwa Moyo', 'Football · Africa #3', LCColors.primary, 'Scouted'),
        _topRow('🥈', 'Rudo Langa', 'Academics · GPA 3.97', LCColors.blue, 'Scholarship'),
        _topRow('🥉', 'Anesu Kapoor', 'Chess · Zim #2', LCColors.gold, 'Rising'),
        _topRow('#4', 'Nyasha Mutasa', 'Athletics · Prov #1', LCColors.red, 'Tracked'),
      ])),

      // Department performance
      const LCSectionLabel('Department performance'),
      LCCard(child: Column(children: [
        _deptRow('Sciences', 0.82, LCColors.primary, '82%'),
        _deptRow('Mathematics', 0.78, LCColors.blue, '78%'),
        _deptRow('English', 0.71, LCColors.gold, '71%'),
        _deptRow('Sports overall', 0.91, LCColors.red, '91%'),
        _deptRow('Arts & Music', 0.74, LCColors.purple, '74%'),
      ])),

      // Scout activity
      const LCSectionLabel('Recent scout activity'),
      LCCard(child: Column(children: [
        _scoutRow('FC Dynamos Academy', 'Takudzwa Moyo · Striker', '3 days ago', 'Zimbabwe'),
        _scoutRow('Unknown scout', 'Profile viewed anonymously', '1 week ago', 'Europe'),
        _scoutRow('BAL Development', 'Basketball prospects', '2 weeks ago', 'Continental'),
      ])),
    ]);
  }

  Widget _topRow(String rank, String name, String sub, Color color, String badge) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child:
      Row(children: [
        Text(rank, style: TextStyle(fontSize: rank.startsWith('#') ? 13 : 18,
          color: rank == '🥇' ? LCColors.gold1 : rank == '🥈' ? LCColors.silver2 : LCColors.bronze3)),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(sub, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        ])),
        LCPill(badge, color),
      ]));
  }

  Widget _deptRow(String label, double val, Color color, String pct) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child:
      Column(children: [
        Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(pct, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
        ]),
        const SizedBox(height: 5),
        LCProgressBar(value: val, color: color),
      ]));
  }

  Widget _scoutRow(String org, String detail, String time, String region) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child:
      Row(children: [
        const Icon(Icons.remove_red_eye_outlined, size: 16, color: LCColors.gold),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(org, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(detail, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          LCPill(region, LCColors.gold),
          Text(time, style: const TextStyle(fontSize: 10, color: LCColors.textDim)),
        ]),
      ]));
  }
}

// ─── STUDENTS ────────────────────────────────────────────────────────────────
class _StudentsTab extends StatelessWidget {
  const _StudentsTab();
  static const _students = [
    _S('Takudzwa Moyo', 'TM', LCColors.primary, 'Form 6', '3.2', 'Football · Zim #1'),
    _S('Rudo Langa', 'RL', LCColors.purple, 'Form 6', '3.97', 'Academics top'),
    _S('Anesu Kapoor', 'AK', LCColors.red, 'Form 6', '3.5', 'Chess · Zim #2'),
    _S('Nyasha Mutasa', 'NM', LCColors.gold, 'Form 6', '3.1', 'Athletics'),
    _S('Tatenda Chiwara', 'TC', LCColors.blue, 'Form 5', '2.9', ''),
    _S('Simba Dube', 'SD', LCColors.orange, 'Form 4', '2.7', ''),
    _S('Rudo Kambarami', 'RK', LCColors.primary, 'Form 3', '3.4', 'Music'),
    _S('Farai Nzima', 'FN', LCColors.purple, 'Form 2', '3.8', 'Academics'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      Row(children: [
        Expanded(child: TextField(
          decoration: const InputDecoration(
            hintText: 'Search students...',
            prefixIcon: Icon(Icons.search, size: 18, color: LCColors.textSecondary),
          ),
        )),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: LCColors.surface, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: LCColors.border)),
          child: const Icon(Icons.filter_list, size: 18, color: LCColors.textSecondary),
        ),
      ]),
      const SizedBox(height: 14),
      LCCard(child: Column(children: _students.map((s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          LCAvatar(initials: s.initials, size: 36, color: s.color),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text('${s.grade} · GPA ${s.gpa}', style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
            if (s.highlight.isNotEmpty) LCPill(s.highlight, s.color),
          ])),
          const Icon(Icons.chevron_right, size: 16, color: LCColors.textDim),
        ]),
      )).toList())),
    ]);
  }
}

class _S { final String name, initials, grade, gpa, highlight; final Color color;
  const _S(this.name, this.initials, this.color, this.grade, this.gpa, this.highlight); }

// ─── ANALYTICS ───────────────────────────────────────────────────────────────
class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      const LCSectionLabel('Term summary'),
      GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        children: const [
          LCStatBox(label: 'Grades logged', value: '3,241', valueColor: LCColors.blue, sub: 'verified'),
          LCStatBox(label: 'Sport entries', value: '1,822', valueColor: LCColors.primary, sub: 'verified'),
          LCStatBox(label: 'Club sessions', value: '448', valueColor: LCColors.gold, sub: 'attended'),
          LCStatBox(label: 'Tasks done', value: '6,421', valueColor: LCColors.primary, sub: 'total'),
        ],
      ),
      const LCSectionLabel('Career goals distribution'),
      LCCard(child: Column(children: [
        _careersRow('Professional footballer', 0.28, LCColors.primary, '28%'),
        _careersRow('Software engineer', 0.19, LCColors.blue, '19%'),
        _careersRow('Doctor / Medicine', 0.15, LCColors.red, '15%'),
        _careersRow('Entrepreneur', 0.12, LCColors.gold, '12%'),
        _careersRow('Lawyer', 0.08, LCColors.purple, '8%'),
        _careersRow('Other', 0.18, LCColors.textDim, '18%'),
      ])),
      const LCSectionLabel('Grade distribution this term'),
      LCCard(child: Column(children: [
        _careersRow('A (85%+)', 0.22, LCColors.primary, '22%'),
        _careersRow('B (70–84%)', 0.35, LCColors.blue, '35%'),
        _careersRow('C (55–69%)', 0.28, LCColors.gold, '28%'),
        _careersRow('D / Below 55%', 0.15, LCColors.red, '15%'),
      ])),
      const LCSectionLabel('Scout interest by sport'),
      LCCard(child: Column(children: [
        _careersRow('Football', 0.61, LCColors.primary, '61%'),
        _careersRow('Basketball', 0.18, LCColors.orange, '18%'),
        _careersRow('Athletics', 0.12, LCColors.red, '12%'),
        _careersRow('Chess', 0.05, LCColors.gold, '5%'),
        _careersRow('Academics', 0.04, LCColors.blue, '4%'),
      ])),
    ]);
  }

  Widget _careersRow(String label, double val, Color color, String pct) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child:
      Column(children: [
        Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(pct, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
        ]),
        const SizedBox(height: 5),
        LCProgressBar(value: val, color: color),
      ]));
  }
}

// ─── ADMIN ───────────────────────────────────────────────────────────────────
class _AdminTab extends StatelessWidget {
  const _AdminTab();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      const LCSectionLabel('Admin actions'),
      ...[
        _Action(Icons.person_add_outlined, 'Enrol new student', 'Add a student to the platform', LCColors.primary),
        _Action(Icons.group_add_outlined, 'Manage staff accounts', 'Add or remove teachers and coaches', LCColors.blue),
        _Action(Icons.download_outlined, 'Export term report', 'Download full school report as PDF', LCColors.primary),
        _Action(Icons.remove_red_eye_outlined, 'View scout activity', 'See who has been scouting your students', LCColors.gold),
        _Action(Icons.school_outlined, 'Manage classes', 'Assign teachers to classes', LCColors.blue),
        _Action(Icons.notifications_outlined, 'Send announcement', 'Notify all students or staff', LCColors.purple),
        _Action(Icons.verified_outlined, 'Verify school data', 'Confirm school information on the platform', LCColors.red),
        _Action(Icons.bar_chart_outlined, 'Full analytics report', 'Detailed performance breakdown', LCColors.orange),
      ].map((a) => LCCard(
        onTap: () => _showAdminDialog(context, a),
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(
              color: a.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(a.icon, color: a.color, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text(a.sub, style: const TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          ])),
          const Icon(Icons.chevron_right, size: 18, color: LCColors.textDim),
        ]),
      )),
    ]);
  }
}

class _Action { final IconData icon; final String label, sub; final Color color;
  const _Action(this.icon, this.label, this.sub, this.color);
}

void _showAdminDialog(BuildContext context, _Action action) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(action.label),
      content: Text('${action.label} is available in the next release.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    ),
  );
}
