import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../theme/theme.dart';
import 'student/dashboard.dart';
import 'teacher/teacher_dashboard.dart';
import 'scout/scout_dashboard.dart';
import 'school/school_dashboard.dart';

class PortalSelector extends StatelessWidget {
  const PortalSelector({super.key});

  static const _portals = [
    _Portal('student', 'Student', 'View your profile, goals & career path',
      Icons.person_outline, LCColors.primary),
    _Portal('teacher', 'Teacher / Coach', 'Log grades, stats & manage your students',
      Icons.school_outlined, LCColors.blue),
    _Portal('scout', 'Scout / Recruiter', 'Search & discover verified talent across Africa',
      Icons.search_outlined, LCColors.gold),
    _Portal('school', 'School / Institution', 'Institution-wide overview and admin tools',
      Icons.account_balance_outlined, LCColors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LCColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            // Logo and Brand
            Center(
              child: Column(children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: LCColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'favicon/app logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
            // Brand
            const Text('LIFE CYCLE', style: TextStyle(
              fontSize: 11, letterSpacing: 3, color: LCColors.primary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('Africa\'s youth\ntalent platform.', style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w500, height: 1.2)),
            const SizedBox(height: 8),
            const Text('One record. From primary school to the world.',
              style: TextStyle(fontSize: 14, color: LCColors.textSecondary)),
            const SizedBox(height: 36),
            const Text('Who are you signing in as?',
              style: TextStyle(fontSize: 13, color: LCColors.textSecondary)),
            const SizedBox(height: 14),
            ..._portals.map((p) => _PortalButton(portal: p)),
            const Spacer(),
            // Footer
            const Center(child: Text('Life Cycle · Built in Zimbabwe 🇿🇼',
              style: TextStyle(fontSize: 11, color: LCColors.textDim))),
          ]),
        ),
      ),
    );
  }
}

class _PortalButton extends StatelessWidget {
  final _Portal portal;
  const _PortalButton({super.key, required this.portal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppState>().setUserType(portal.id);
        Widget screen;
        switch (portal.id) {
          case 'student': screen = const StudentDashboard(); break;
          case 'teacher': screen = const TeacherDashboard(); break;
          case 'scout': screen = const ScoutDashboard(); break;
          case 'school': screen = const SchoolDashboard(); break;
          default: screen = const StudentDashboard();
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LCColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: portal.color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: portal.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(portal.icon, color: portal.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(portal.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(portal.subtitle, style: const TextStyle(fontSize: 12, color: LCColors.textSecondary)),
          ])),
          Icon(Icons.arrow_forward_ios, size: 14, color: portal.color.withOpacity(0.6)),
        ]),
      ),
    );
  }
}

class _Portal {
  final String id, label, subtitle;
  final IconData icon;
  final Color color;
  const _Portal(this.id, this.label, this.subtitle, this.icon, this.color);
}
