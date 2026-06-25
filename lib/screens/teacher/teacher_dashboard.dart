import 'package:flutter/material.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});
  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _tab = 0;
  static const _tabs = [
    _Tab(Icons.people_outline, 'Students'),
    _Tab(Icons.edit_note_outlined, 'Log'),
    _Tab(Icons.check_circle_outline, 'Verify'),
    _Tab(Icons.bar_chart_outlined, 'Stats'),
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
              color: LCColors.blue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LCColors.blue.withOpacity(0.3)),
            ),
            child: const Text('Teacher', style: TextStyle(fontSize: 11, color: LCColors.blue, fontWeight: FontWeight.w500)),
          ),
        ),
        const Divider(height: 1, color: LCColors.border),
        Expanded(child: IndexedStack(index: _tab, children: const [
          _StudentsTab(),
          _LogTab(),
          _VerifyTab(),
          _StatsTab(),
        ])),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LCColors.bg,
          border: Border(top: BorderSide(color: LCColors.border)),
        ),
        child: SafeArea(child: Row(children: List.generate(_tabs.length, (i) {
          final active = i == _tab;
          final color = active ? LCColors.blue : LCColors.textDim;
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

// ─── STUDENTS TAB ────────────────────────────────────────────────────────────
class _StudentsTab extends StatelessWidget {
  const _StudentsTab();

  static const _students = [
    _Student('Takudzwa Moyo', 'TM', LCColors.primary, 'Form 6A', 'A · 92%', 'Zim #1 ⚽'),
    _Student('Rudo Langa', 'RL', LCColors.purple, 'Form 6A', 'A- · 85%', 'GPA 3.97'),
    _Student('Anesu Kapoor', 'AK', LCColors.red, 'Form 6A', 'B+ · 81%', 'Chess Zim #2'),
    _Student('Nyasha Mutasa', 'NM', LCColors.gold, 'Form 6A', 'B · 76%', ''),
    _Student('Tatenda Chiwara', 'TC', LCColors.blue, 'Form 6A', 'B- · 72%', ''),
    _Student('Simba Dube', 'SD', LCColors.orange, 'Form 6A', 'C+ · 68%', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      // Teacher profile
      LCCard(child: Row(children: [
        LCAvatar(initials: 'RC', size: 48, color: LCColors.blue),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Mr R. Chikwanda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const Text('Mathematics · Football Coach', style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, children: [
            LCPill('Teacher', LCColors.blue),
            LCPill('Coach', LCColors.primary),
            LCPill('Watershed College', LCColors.textSecondary),
          ]),
        ])),
      ])),

      // Class stats
      const LCSectionLabel('My classes'),
      GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        children: const [
          LCStatBox(label: 'Form 6A · Maths', value: '32', valueColor: LCColors.blue, sub: 'students'),
          LCStatBox(label: 'Form 5B · Maths', value: '28', valueColor: LCColors.blue, sub: 'students'),
          LCStatBox(label: 'Football team', value: '22', valueColor: LCColors.primary, sub: 'players'),
          LCStatBox(label: 'Pending verify', value: '4', valueColor: LCColors.red, sub: 'to confirm'),
        ],
      ),

      // Student list
      const LCSectionLabel('Form 6A · Students'),
      LCCard(child: Column(children: _students.map((s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          LCAvatar(initials: s.initials, size: 36, color: s.color),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(s.grade, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
            if (s.badge.isNotEmpty) ...[
              const SizedBox(height: 3),
              LCPill(s.badge, s.color),
            ],
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(s.currentGrade,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                color: _gradeColor(s.currentGrade))),
            const SizedBox(height: 4),
            OutlinedButton(
              onPressed: () => _showLogDialog(context, s.name),
              style: OutlinedButton.styleFrom(
                foregroundColor: LCColors.blue,
                side: const BorderSide(color: LCColors.blue),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Log grade', style: TextStyle(fontSize: 11)),
            ),
          ]),
        ]),
      )).toList())),
    ]);
  }

  Color _gradeColor(String g) {
    if (g.startsWith('A')) return LCColors.primary;
    if (g.startsWith('B')) return LCColors.blue;
    return LCColors.gold;
  }

  void _showLogDialog(BuildContext context, String studentName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log grade'),
        content: Text('Start logging a grade for $studentName.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _Student {
  final String name, initials, grade, currentGrade, badge;
  final Color color;
  const _Student(this.name, this.initials, this.color, this.grade, this.currentGrade, this.badge);
}

// ─── LOG TAB ─────────────────────────────────────────────────────────────────
class _LogTab extends StatefulWidget {
  const _LogTab();
  @override
  State<_LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<_LogTab> {
  String _logType = '';
  bool _saved = false;
  final Map<String, String> _dropdownValues = {};
  final Map<String, TextEditingController> _textControllers = {};

  static const _types = [
    _LogType('Grade', Icons.edit_note, LCColors.blue),
    _LogType('Sport stat', Icons.sports_soccer, LCColors.primary),
    _LogType('Coaching', Icons.directions_run, LCColors.primary),
    _LogType('Test marked', Icons.check_box_outlined, LCColors.gold),
    _LogType('Project', Icons.assignment_outlined, LCColors.purple),
    _LogType('Lesson', Icons.school_outlined, LCColors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      const Text('What would you like to log?',
        style: TextStyle(fontSize: 13, color: LCColors.textSecondary)),
      const SizedBox(height: 12),

      // Type selector
      GridView.count(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.4,
        children: _types.map((t) {
          final active = _logType == t.label;
          return GestureDetector(
            onTap: () => setState(() { _logType = t.label; _saved = false; }),
            child: Container(
              decoration: BoxDecoration(
                color: active ? t.color.withOpacity(0.12) : LCColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: active ? t.color.withOpacity(0.4) : LCColors.border),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(t.icon, color: active ? t.color : LCColors.textSecondary, size: 22),
                const SizedBox(height: 6),
                Text(t.label, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                    color: active ? t.color : LCColors.textSecondary)),
              ]),
            ),
          );
        }).toList(),
      ),

      if (_logType.isNotEmpty && !_saved) ...[
        const SizedBox(height: 16),
        _buildForm(),
      ],

      if (_saved) ...[
        const SizedBox(height: 16),
        LCCard(
          borderColor: LCColors.primary.withOpacity(0.4),
          child: Column(children: [
            const Icon(Icons.check_circle_outline, color: LCColors.primary, size: 32),
            const SizedBox(height: 8),
            const Text('Logged & verified', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: LCColors.primary)),
            const SizedBox(height: 4),
            const Text('Added to student\'s permanent Life Cycle record',
              style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() { _logType = ''; _saved = false; }),
              child: LCPill('Log another', LCColors.primary),
            ),
          ]),
        ),
      ],
    ]);
  }

  Widget _buildForm() {
    final logType = _types.firstWhere((t) => t.label == _logType);
    return LCCard(
      borderColor: logType.color.withOpacity(0.35),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(logType.icon, color: logType.color, size: 16),
          const SizedBox(width: 8),
          Text('Log $_logType', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: logType.color)),
        ]),
        const SizedBox(height: 14),
        _field('Student', isDropdown: true,
          items: ['Takudzwa Moyo', 'Rudo Langa', 'Anesu Kapoor', 'Nyasha Mutasa', 'Tatenda Chiwara']),
        if (_logType == 'Grade' || _logType == 'Test marked') ...[
          _field('Subject', isDropdown: true, items: ['Mathematics', 'Physics', 'Chemistry', 'English', 'Biology', 'History']),
          _field('Score / grade', hint: 'e.g. 88% or A-'),
          _field('Term', isDropdown: true, items: ['Term 1, 2025', 'Term 2, 2025', 'Term 3, 2025']),
          if (_logType == 'Test marked') _field('Hours spent marking', hint: 'e.g. 3'),
        ],
        if (_logType == 'Sport stat') ...[
          _field('Sport', isDropdown: true, items: ['Football', 'Basketball', 'Athletics', 'Chess', 'Tennis']),
          _field('Stat type', isDropdown: true, items: ['Goals scored', 'Assists', 'Match result', 'Personal best', 'Tournament placing']),
          _field('Value', hint: 'e.g. 3 goals, Win, 10.8s'),
          _field('Date', hint: 'e.g. 12 June 2025'),
        ],
        if (_logType == 'Coaching') ...[
          _field('Team', isDropdown: true, items: ['Football First XI', 'Football U16', 'Basketball', 'Athletics']),
          _field('Session type', isDropdown: true, items: ['Team training', 'Match day', 'Tactics', 'Individual coaching']),
          _field('Duration (hours)', hint: 'e.g. 2'),
          _field('Players present', hint: 'e.g. 22'),
        ],
        if (_logType == 'Project') ...[
          _field('Project name', hint: 'e.g. Solar cell efficiency'),
          _field('Class', isDropdown: true, items: ['Form 6A', 'Form 5B', 'Both']),
          _field('Groups supervised', hint: 'e.g. 4'),
          _field('Duration (weeks)', hint: 'e.g. 3'),
        ],
        if (_logType == 'Lesson') ...[
          _field('Class', isDropdown: true, items: ['Form 6A · Mathematics', 'Form 5B · Mathematics']),
          _field('Topic covered', hint: 'e.g. Integration by parts'),
          _field('Duration (hours)', hint: 'e.g. 2'),
          _field('Students present', hint: 'e.g. 30'),
        ],
        const SizedBox(height: 4),
        SizedBox(width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _saved = true),
            style: ElevatedButton.styleFrom(backgroundColor: logType.color,
              foregroundColor: logType.color == LCColors.gold ? LCColors.bg : Colors.white),
            child: const Text('Verify & save to record'),
          )),
      ]),
    );
  }

  Widget _field(String label, {bool isDropdown = false, List<String>? items, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        const SizedBox(height: 4),
        isDropdown
          ? DropdownButtonFormField<String>(
              value: _dropdownValue(label, items!),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: (newValue) => setState(() => _setDropdownValue(label, newValue ?? items.first)),
              dropdownColor: LCColors.surface,
              style: const TextStyle(fontSize: 13, color: LCColors.textPrimary),
              decoration: const InputDecoration(),
            )
          : TextFormField(
              controller: _controller(label),
              decoration: InputDecoration(hintText: hint),
              style: const TextStyle(fontSize: 13),
            ),
      ]),
    );
  }

  String _dropdownValue(String label, List<String> items) =>
      _dropdownValues[label] ?? items.first;

  void _setDropdownValue(String label, String value) {
    _dropdownValues[label] = value;
  }

  TextEditingController _controller(String label) =>
      _textControllers.putIfAbsent(label, () => TextEditingController());

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _LogType { final String label; final IconData icon; final Color color;
  const _LogType(this.label, this.icon, this.color); }

// ─── VERIFY TAB ──────────────────────────────────────────────────────────────
class _VerifyTab extends StatefulWidget {
  const _VerifyTab();
  @override
  State<_VerifyTab> createState() => _VerifyTabState();
}

class _VerifyTabState extends State<_VerifyTab> {
  final _pending = [
    _Pending('Takudzwa Moyo', 'TM', LCColors.primary, 'Hat-trick vs St Georges', 'Football · Self-logged', '3 goals'),
    _Pending('Anesu Kapoor', 'AK', LCColors.red, 'Science olympiad bronze', 'Achievement · Self-logged', 'National'),
    _Pending('Rudo Langa', 'RL', LCColors.purple, 'Community service hours', 'Extracurricular · Self-logged', '4 hrs'),
    _Pending('Nyasha Mutasa', 'NM', LCColors.gold, 'Personal best 100m', 'Athletics · Self-logged', '11.8s'),
  ];
  final _confirmed = <String>{};
  final _rejected = <String>{};

  @override
  Widget build(BuildContext context) {
    final active = _pending.where((p) => !_confirmed.contains(p.name+p.title) && !_rejected.contains(p.name+p.title)).toList();
    return ListView(padding: const EdgeInsets.all(14), children: [
      LCCard(child: Row(children: [
        const Icon(Icons.pending_outlined, color: LCColors.gold, size: 20),
        const SizedBox(width: 10),
        Text('${active.length} items awaiting your verification',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ])),
      const LCSectionLabel('Pending verification'),
      ...active.map((p) {
        final key = p.name + p.title;
        return LCCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            LCAvatar(initials: p.initials, size: 36, color: p.color),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(p.category, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
            ])),
            LCPill(p.value, p.color),
          ]),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
            color: LCColors.surfaceAlt, borderRadius: BorderRadius.circular(8),
            border: Border.all(color: LCColors.border)),
            child: Row(children: [
              const Icon(Icons.info_outline, size: 14, color: LCColors.textSecondary),
              const SizedBox(width: 8),
              Text(p.title, style: const TextStyle(fontSize: 12)),
            ])),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () => setState(() => _rejected.add(key)),
              icon: const Icon(Icons.close, size: 14),
              label: const Text('Reject'),
              style: OutlinedButton.styleFrom(
                foregroundColor: LCColors.red,
                side: const BorderSide(color: LCColors.red),
              ),
            )),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: ElevatedButton.icon(
              onPressed: () => setState(() => _confirmed.add(key)),
              icon: const Icon(Icons.check, size: 14),
              label: const Text('Confirm & verify'),
            )),
          ]),
        ]));
      }),
      if (_confirmed.isNotEmpty || _rejected.isNotEmpty) ...[
        const LCSectionLabel('Resolved'),
        ..._pending.where((p) => _confirmed.contains(p.name+p.title) || _rejected.contains(p.name+p.title)).map((p) {
          final key = p.name + p.title;
          final isConfirmed = _confirmed.contains(key);
          return LCCard(child: Row(children: [
            LCAvatar(initials: p.initials, size: 34, color: p.color),
            const SizedBox(width: 10),
            Expanded(child: Text(p.title, style: const TextStyle(fontSize: 13))),
            LCPill(isConfirmed ? '✓ Verified' : '✗ Rejected',
              isConfirmed ? LCColors.primary : LCColors.red),
          ]));
        }),
      ],
    ]);
  }
}

class _Pending { final String name, initials, title, category, value; final Color color;
  const _Pending(this.name, this.initials, this.color, this.title, this.category, this.value); }

// ─── STATS TAB ───────────────────────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      const LCSectionLabel('My activity this term'),
      GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        children: const [
          LCStatBox(label: 'Hours taught', value: '142', valueColor: LCColors.blue, sub: 'this term'),
          LCStatBox(label: 'Tests marked', value: '38', valueColor: LCColors.gold, sub: 'this term'),
          LCStatBox(label: 'Projects overseen', value: '9', valueColor: LCColors.purple, sub: 'this term'),
          LCStatBox(label: 'Coaching hours', value: '68', valueColor: LCColors.primary, sub: 'this term'),
          LCStatBox(label: 'Grades logged', value: '124', valueColor: LCColors.blue, sub: 'verified entries'),
          LCStatBox(label: 'Matches coached', value: '18', valueColor: LCColors.primary, sub: 'this season'),
        ],
      ),
      const LCSectionLabel('Class performance'),
      LCCard(child: Column(children: [
        _perfRow('Form 6A Average', 0.78, LCColors.primary, '78%'),
        _perfRow('Form 5B Average', 0.71, LCColors.blue, '71%'),
        _perfRow('Football team win rate', 0.82, LCColors.primary, '82%'),
        _perfRow('Student task completion', 0.67, LCColors.gold, '67%'),
      ])),
      const LCSectionLabel('Recent teaching log'),
      LCCard(child: Column(children: [
        _logRow('Mon · Form 6A · Calculus', '2 hrs', LCColors.blue),
        _logRow('Mon · Form 5B · Algebra', '1.5 hrs', LCColors.blue),
        _logRow('Tue · Football training', '2 hrs', LCColors.primary),
        _logRow('Wed · Project review · 4 groups', '3 hrs', LCColors.purple),
        _logRow('Thu · Form 6A · Test marked', '4 hrs', LCColors.gold),
      ])),
    ]);
  }

  Widget _perfRow(String label, double val, Color color, String pct) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child:
      Column(children: [
        Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(pct, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
        ]),
        const SizedBox(height: 6),
        LCProgressBar(value: val, color: color),
      ]));
  }

  Widget _logRow(String label, String value, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
      ]));
  }
}
