import 'package:flutter/material.dart';
import '../../widgets/common.dart';
import '../../theme/theme.dart';

class ScoutDashboard extends StatefulWidget {
  const ScoutDashboard({super.key});
  @override
  State<ScoutDashboard> createState() => _ScoutDashboardState();
}

class _ScoutDashboardState extends State<ScoutDashboard> {
  int _tab = 0;
  static const _tabs = [
    _Tab(Icons.search_outlined, 'Search'),
    _Tab(Icons.star_outline, 'Saved'),
    _Tab(Icons.leaderboard_outlined, 'Rankings'),
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
              color: LCColors.gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LCColors.gold.withOpacity(0.3)),
            ),
            child: const Text('Scout · Premium', style: TextStyle(fontSize: 11, color: LCColors.gold, fontWeight: FontWeight.w500)),
          ),
        ),
        const Divider(height: 1, color: LCColors.border),
        Expanded(child: IndexedStack(index: _tab, children: const [
          _SearchTab(),
          _SavedTab(),
          _RankingsTab(),
        ])),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LCColors.bg,
          border: Border(top: BorderSide(color: LCColors.border)),
        ),
        child: SafeArea(child: Row(children: List.generate(_tabs.length, (i) {
          final active = i == _tab;
          final color = active ? LCColors.gold : LCColors.textDim;
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

class _SearchTab extends StatefulWidget {
  const _SearchTab();
  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  bool _searched = false;
  String? _selectedProfile;
  String _selectedSport = 'Football';
  String _selectedRegion = 'All Africa';
  String _selectedAgeGroup = 'Under 18';
  String _selectedPosition = 'Any position';

  static const _results = [
    _Prospect('Takudzwa Moyo', 'TM', LCColors.primary, 'Watershed College', 'Striker · Age 17', '147 goals · 31.4 km/h', 'Zim #1', true),
    _Prospect('Tendai Rusike', 'TR', LCColors.red, 'St Georges College', 'Striker · Age 16', '98 goals · 30.1 km/h', 'Zim #2', false),
    _Prospect('Kudakwashe Mwale', 'KM', LCColors.gold, 'Churchill Boys', 'Striker · Age 17', '87 goals · 29.8 km/h', 'Zim #3', false),
    _Prospect('Panashe Dube', 'PD', LCColors.blue, 'Peterhouse', 'Striker · Age 16', '76 goals · 29.2 km/h', 'Zim #4', false),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      // Scout profile
      LCCard(child: Row(children: [
        LCAvatar(initials: 'JK', size: 44, color: LCColors.gold),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('James Kowalski', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text('FC Dynamos Academy · Head Scout', style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
        ])),
        LCPill('Africa access', LCColors.gold),
      ])),

      // Filters
      const LCSectionLabel('Search talent'),
      LCCard(child: Column(children: [
        _dropdown('Sport / category', ['Football', 'Basketball', 'Athletics', 'Chess', 'Academics', 'Music & Arts']),
        Row(children: [
          Expanded(child: _dropdown('Region', ['All Africa', 'Zimbabwe', 'Nigeria', 'Ghana', 'South Africa', 'Kenya'])),
          const SizedBox(width: 8),
          Expanded(child: _dropdown('Age group', ['Under 18', 'Under 16', 'Under 21', 'All ages'])),
        ]),
        _dropdown('Position', ['Any position', 'Striker', 'Midfielder', 'Defender', 'Goalkeeper']),
        const SizedBox(height: 4),
        SizedBox(width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() { _searched = true; _selectedProfile = null; }),
            style: ElevatedButton.styleFrom(backgroundColor: LCColors.gold, foregroundColor: LCColors.bg),
            child: const Text('Search database'),
          )),
      ])),

      if (_searched) ...[
        const LCSectionLabel('Top results · Zimbabwe U18 strikers'),
        if (_selectedProfile == null) ...[
          ...List.generate(_results.length, (i) {
            final r = _results[i];
            final medal = ['🥇', '🥈', '🥉', '#4'][i];
            return GestureDetector(
              onTap: () => setState(() => _selectedProfile = r.name),
              child: LCCard(child: Row(children: [
                Text(medal, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                LCAvatar(initials: r.initials, size: 38, color: r.color),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(r.school, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                  Text(r.position, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  LCPill(r.rank, LCColors.gold),
                  const SizedBox(height: 4),
                  Text(r.stats, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
                ]),
              ])),
            );
          }),
        ] else ...[
          // Full scout report
          LCCard(
            borderColor: LCColors.gold.withOpacity(0.35),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                LCAvatar(initials: 'TM', size: 48, color: LCColors.primary),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Takudzwa Moyo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  Text('Watershed College · DOB: 14 Mar 2007', style: TextStyle(fontSize: 12, color: LCColors.textSecondary)),
                ])),
              ]),
              const SizedBox(height: 14),
              _verifiedStat('Career goals', '147', LCColors.primary),
              _verifiedStat('Games played', '203', LCColors.textPrimary),
              _verifiedStat('Top speed', '31.4 km/h', LCColors.red),
              _verifiedStat('GPA', '3.2', LCColors.blue),
              _verifiedStat('Africa rank (strikers U18)', '#3', LCColors.gold),
              _verifiedStat('Coach comment', '"Elite mentality"', LCColors.textPrimary),
              _verifiedStat('Hours trained this term', '184 hrs', LCColors.primary),
              _verifiedStat('Tournaments attended', '6', LCColors.primary),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: OutlinedButton(
                  onPressed: () => setState(() => _selectedProfile = null),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: LCColors.border)),
                  child: const Text('Back', style: TextStyle(color: LCColors.textSecondary)),
                )),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Contact school'),
                        content: const Text('This action will open the contact workflow in the next release.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.mail_outline, size: 14),
                  label: const Text('Contact school'),
                  style: ElevatedButton.styleFrom(backgroundColor: LCColors.gold, foregroundColor: LCColors.bg),
                )),
              ]),
            ]),
          ),
        ],
      ],
    ]);
  }

  Widget _dropdown(String label, List<String> items) {
    late String selectedValue;
    late ValueChanged<String?> onChanged;

    switch (label) {
      case 'Sport / category':
        selectedValue = _selectedSport;
        onChanged = (value) => setState(() {
          _selectedSport = value ?? _selectedSport;
        });
        break;
      case 'Region':
        selectedValue = _selectedRegion;
        onChanged = (value) => setState(() {
          _selectedRegion = value ?? _selectedRegion;
        });
        break;
      case 'Age group':
        selectedValue = _selectedAgeGroup;
        onChanged = (value) => setState(() {
          _selectedAgeGroup = value ?? _selectedAgeGroup;
        });
        break;
      case 'Position':
        selectedValue = _selectedPosition;
        onChanged = (value) => setState(() {
          _selectedPosition = value ?? _selectedPosition;
        });
        break;
      default:
        selectedValue = items.first;
        onChanged = (_) {};
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
          dropdownColor: LCColors.surface,
          style: const TextStyle(fontSize: 13, color: LCColors.textPrimary),
          decoration: const InputDecoration(),
        ),
      ]),
    );
  }

  Widget _verifiedStat(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: LCColors.textSecondary))),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
        const SizedBox(width: 6),
        const Text('✓', style: TextStyle(fontSize: 11, color: LCColors.primary)),
      ]),
    );
  }
}

class _Prospect {
  final String name, initials, school, position, stats, rank;
  final Color color;
  final bool top;
  const _Prospect(this.name, this.initials, this.color, this.school, this.position, this.stats, this.rank, this.top);
}

class _SavedTab extends StatelessWidget {
  const _SavedTab();
  static const _saved = [
    _Prospect('Takudzwa Moyo', 'TM', LCColors.primary, 'Watershed College', 'Striker · Age 17', '147 goals', 'Zim #1', true),
    _Prospect('Chidi Okafor', 'CO', LCColors.gold, 'King\'s College Lagos', 'Striker · Age 16', '98 goals', 'Nigeria #1', false),
    _Prospect('Sipho Ndlovu', 'SN', LCColors.blue, 'Hilton College', 'Midfielder · Age 17', '45 assists', 'SA #2', false),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      const LCSectionLabel('Saved prospects'),
      ..._saved.map((p) => LCCard(child: Row(children: [
        LCAvatar(initials: p.initials, size: 38, color: p.color),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(p.school, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
          Text(p.position, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          LCPill(p.top ? 'Top target' : 'Watching', p.top ? LCColors.primary : LCColors.blue),
          const SizedBox(height: 4),
          Text(p.stats, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
        ]),
      ]))),
    ]);
  }
}

class _RankingsTab extends StatelessWidget {
  const _RankingsTab();
  static const _categories = ['Football', 'Basketball', 'Athletics', 'Chess', 'Academics', 'Music'];
  static const _scopes = ['School', 'Zimbabwe', 'Africa', 'Global'];
  static const _data = [
    _RankEntry('Takudzwa Moyo', 'TM', LCColors.primary, 'Watershed College', '34 goals', 'Zim #1'),
    _RankEntry('Tendai Rusike', 'TR', LCColors.red, 'St Georges', '31 goals', 'Zim #2'),
    _RankEntry('Chidi Okafor', 'CO', LCColors.gold, 'King\'s Lagos', '28 goals', 'Nigeria #1'),
    _RankEntry('Amara Diallo', 'AD', LCColors.blue, 'Lycée Dakar', '26 goals', 'Senegal #1'),
    _RankEntry('Lethabo Khumalo', 'LK', LCColors.purple, 'Parktown Boys', '25 goals', 'SA #3'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(14), children: [
      // Category chips
      SizedBox(height: 38, child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemCount: _categories.length,
        itemBuilder: (_, i) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: i == 0 ? LCColors.primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: i == 0 ? LCColors.primary.withOpacity(0.5) : LCColors.border),
          ),
          child: Text(_categories[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
            color: i == 0 ? LCColors.primary : LCColors.textSecondary)),
        ),
      )),
      const SizedBox(height: 12),
      // Scope
      Row(children: _scopes.map((s) => Expanded(child: Container(
        margin: EdgeInsets.only(right: s != _scopes.last ? 6 : 0),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: s == 'Africa' ? LCColors.gold.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: s == 'Africa' ? LCColors.gold.withOpacity(0.5) : LCColors.border),
        ),
        child: Text(s, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
          color: s == 'Africa' ? LCColors.gold : LCColors.textSecondary)),
      ))).toList()),
      const SizedBox(height: 16),
      const Text('Football · Africa', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      Text('${DateTime.now().year} season · ${2847} tracked students', style: const TextStyle(fontSize: 12, color: LCColors.textSecondary)),
      const SizedBox(height: 10),
      ..._data.asMap().entries.map((e) {
        final i = e.key;
        final r = e.value;
        final medals = ['🥇', '🥈', '🥉'];
        return LCCard(child: Row(children: [
          SizedBox(width: 32, child: Text(i < 3 ? medals[i] : '#${i+1}',
            style: TextStyle(fontSize: i < 3 ? 18 : 13,
              color: [LCColors.gold1, LCColors.silver2, LCColors.bronze3, LCColors.textDim, LCColors.textDim][i]))),
          LCAvatar(initials: r.initials, size: 36, color: r.color),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(r.school, style: const TextStyle(fontSize: 11, color: LCColors.textSecondary)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(r.stats, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: LCColors.primary)),
            LCPill(r.region, LCColors.primary),
          ]),
        ]));
      }),
    ]);
  }
}

class _RankEntry {
  final String name, initials, school, stats, region;
  final Color color;
  const _RankEntry(this.name, this.initials, this.color, this.school, this.stats, this.region);
}
