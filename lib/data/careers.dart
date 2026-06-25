import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum CareerStatus { strong, onTrack, possible, atRisk }
enum GoalFrequency { daily, weekly, monthly }
enum GoalCategory { academic, sport, extracurricular, entrepreneurship, leadership, creative, technical }

class CareerGoal {
  final String id;
  final String title;
  final String description;
  final GoalFrequency frequency;
  final GoalCategory category;
  bool completed;

  CareerGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.category,
    this.completed = false,
  });
}

class CareerPath {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final double minGPA;
  final double minSportRank;
  final String trainingYears;
  final String description;
  final List<String> requiredSubjects;
  final List<String> recommendedClubs;
  final List<CareerGoal> dailyGoals;
  final List<CareerGoal> weeklyGoals;
  final List<CareerGoal> monthlyGoals;
  final List<String> targetUniversities;
  final List<String> scholarshipTypes;

  CareerPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.minGPA,
    this.minSportRank = 0,
    required this.trainingYears,
    required this.description,
    required this.requiredSubjects,
    required this.recommendedClubs,
    required this.dailyGoals,
    required this.weeklyGoals,
    required this.monthlyGoals,
    required this.targetUniversities,
    required this.scholarshipTypes,
  });

  CareerStatus getStatus(double currentGPA, int sportRank) {
    if (minSportRank > 0) {
      if (sportRank <= 3) return CareerStatus.strong;
      if (sportRank <= 10) return CareerStatus.onTrack;
      if (sportRank <= 50) return CareerStatus.possible;
      return CareerStatus.atRisk;
    }
    final gap = currentGPA - minGPA;
    if (gap >= 0.3) return CareerStatus.strong;
    if (gap >= 0) return CareerStatus.onTrack;
    if (gap >= -0.3) return CareerStatus.possible;
    return CareerStatus.atRisk;
  }

  double getReadiness(double currentGPA, int sportRank) {
    if (minSportRank > 0) {
      if (sportRank <= 1) return 0.98;
      if (sportRank <= 5) return 0.90;
      if (sportRank <= 20) return 0.75;
      return 0.50;
    }
    final ratio = (currentGPA / minGPA).clamp(0.0, 1.2);
    return (ratio * 0.85).clamp(0.0, 1.0);
  }
}

// Helper to build goals
CareerGoal _g(String id, String title, String desc, GoalFrequency freq, GoalCategory cat) =>
    CareerGoal(id: id, title: title, description: desc, frequency: freq, category: cat);

class CareerData {
  static List<CareerPath> all = [

    // ── MEDICINE ────────────────────────────────────────────
    CareerPath(
      id: 'neurosurgeon', title: 'Neurosurgeon', subtitle: 'Medicine · 12+ years',
      category: 'Medicine', icon: Icons.psychology, color: LCColors.red,
      minGPA: 3.8, trainingYears: '12+ years',
      description: 'One of the most demanding medical specialisations. Requires exceptional academic performance and a commitment to lifelong learning.',
      requiredSubjects: ['Biology', 'Chemistry', 'Physics', 'Mathematics'],
      recommendedClubs: ['Science club', 'Community service', 'Debate', 'First aid'],
      targetUniversities: ['University of Zimbabwe', 'UCT', 'Wits', 'Makerere', 'University of Ghana'],
      scholarshipTypes: ['Merit scholarship', 'Medical bursary', 'African Development Bank'],
      dailyGoals: [
        _g('d1','Study Biology · 2 hrs','Focus: human anatomy and nervous system',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Chemistry revision · 1 hr','Organic chemistry and biochemistry',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Mathematics practice · 45 min','Statistics and calculus — required for med school',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','Read a medical article','Stay current with medicine news — 1 article/day',GoalFrequency.daily,GoalCategory.academic),
        _g('d5','Physical exercise · 30 min','Surgeons need stamina — daily movement required',GoalFrequency.daily,GoalCategory.sport),
      ],
      weeklyGoals: [
        _g('w1','Attend science club','Weekly science club session',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Community service · 2 hrs','Volunteering — critical for med school applications',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w3','Complete one past paper','Biology or Chemistry past exam paper',GoalFrequency.weekly,GoalCategory.academic),
        _g('w4','Debate club session','Builds communication — essential for doctors',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w5','Review week\'s study notes','Consolidate what you learned this week',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Sit a full mock exam','All core STEM subjects',GoalFrequency.monthly,GoalCategory.academic),
        _g('m2','Visit a clinic or hospital','Shadow a doctor or attend a talk',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m3','Read one medical biography','Learn from people who made it',GoalFrequency.monthly,GoalCategory.academic),
        _g('m4','Track GPA progress','Ensure you are on 3.8+ trajectory',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    CareerPath(
      id: 'gp', title: 'General Practitioner', subtitle: 'Medicine · 6 years',
      category: 'Medicine', icon: Icons.local_hospital, color: LCColors.red,
      minGPA: 3.5, trainingYears: '6 years',
      description: 'Front-line doctor for communities. High demand across Africa.',
      requiredSubjects: ['Biology', 'Chemistry', 'Mathematics'],
      recommendedClubs: ['Science club', 'First aid', 'Community service'],
      targetUniversities: ['University of Zimbabwe', 'UCT', 'University of Nairobi', 'Makerere'],
      scholarshipTypes: ['Medical bursary', 'Government scholarship'],
      dailyGoals: [
        _g('d1','Study Biology · 1.5 hrs','Human systems — digestive, respiratory, immune',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Chemistry revision · 1 hr','Pharmacology basics and biochemistry',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Physical exercise · 30 min','Health and stamina maintenance',GoalFrequency.daily,GoalCategory.sport),
      ],
      weeklyGoals: [
        _g('w1','Community service · 2 hrs','Patient-facing experience builds empathy',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Science club session','Build your science peer network',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w3','Past paper practice','One Biology or Chemistry paper',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Mock exam — all subjects','Track your readiness',GoalFrequency.monthly,GoalCategory.academic),
        _g('m2','Hospital/clinic visit','Real-world exposure to medicine',GoalFrequency.monthly,GoalCategory.extracurricular),
      ],
    ),

    // ── TECH & ENGINEERING ───────────────────────────────────
    CareerPath(
      id: 'software_engineer', title: 'Software Engineer', subtitle: 'Technology · 4 years',
      category: 'Technology', icon: Icons.code, color: LCColors.blue,
      minGPA: 3.0, trainingYears: '4 years',
      description: 'Build the software that powers the world. One of the fastest-growing career paths globally and across Africa.',
      requiredSubjects: ['Mathematics', 'Computer Science', 'Physics'],
      recommendedClubs: ['Coding club', 'Robotics', 'Science club', 'Hackathon team'],
      targetUniversities: ['University of Zimbabwe', 'UCT', 'University of Cape Town', 'University of Lagos', 'Ashesi'],
      scholarshipTypes: ['ALX scholarship', 'Google Africa scholarship', 'STEM bursary'],
      dailyGoals: [
        _g('d1','Code practice · 1 hr','Solve at least 1 coding problem daily',GoalFrequency.daily,GoalCategory.technical),
        _g('d2','Mathematics · 45 min','Algebra, logic, and discrete maths',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Read tech content · 20 min','1 article or tutorial on software',GoalFrequency.daily,GoalCategory.technical),
        _g('d4','Work on personal project · 30 min','Build something — a website, app, or tool',GoalFrequency.daily,GoalCategory.technical),
      ],
      weeklyGoals: [
        _g('w1','Attend coding club','Collaborate and learn with peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Complete one mini-project','A small but complete piece of software',GoalFrequency.weekly,GoalCategory.technical),
        _g('w3','Mathematics past paper','One full paper per week',GoalFrequency.weekly,GoalCategory.academic),
        _g('w4','Watch a tech tutorial','YouTube, freeCodeCamp, or similar',GoalFrequency.weekly,GoalCategory.technical),
      ],
      monthlyGoals: [
        _g('m1','Launch one project online','Put something on GitHub or the web',GoalFrequency.monthly,GoalCategory.technical),
        _g('m2','Enter a hackathon or competition','Apply skills competitively',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m3','Review all subject grades','Maintain 3.0+ GPA',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    CareerPath(
      id: 'mechanical_engineer', title: 'Mechanical Engineer', subtitle: 'Engineering · 4 years',
      category: 'Engineering', icon: Icons.settings, color: LCColors.blue,
      minGPA: 3.0, trainingYears: '4 years',
      description: 'Design and build the physical systems that power industry.',
      requiredSubjects: ['Physics', 'Mathematics', 'Chemistry'],
      recommendedClubs: ['Robotics', 'Science club', 'Design team'],
      targetUniversities: ['UZ', 'UCT', 'Wits', 'University of Lagos'],
      scholarshipTypes: ['STEM bursary', 'Engineering scholarship'],
      dailyGoals: [
        _g('d1','Physics · 1.5 hrs','Mechanics and forces — core of engineering',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Mathematics · 1 hr','Calculus and trigonometry',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Sketch or design something','Draw a machine, gadget, or mechanism',GoalFrequency.daily,GoalCategory.technical),
      ],
      weeklyGoals: [
        _g('w1','Robotics club session','Hands-on building experience',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Physics past paper','One full paper per week',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Watch engineering documentary','Learn about real engineering projects',GoalFrequency.weekly,GoalCategory.technical),
      ],
      monthlyGoals: [
        _g('m1','Build a working prototype','Small physical project from materials available',GoalFrequency.monthly,GoalCategory.technical),
        _g('m2','Mock exam all STEM subjects','Track readiness',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── SPORTS ──────────────────────────────────────────────
    CareerPath(
      id: 'pro_footballer', title: 'Professional Footballer', subtitle: 'Sports · ongoing career',
      category: 'Sports', icon: Icons.sports_soccer, color: LCColors.primary,
      minGPA: 2.0, minSportRank: 10, trainingYears: 'Ongoing',
      description: 'Become a professional footballer — one of the most competitive career paths in the world. Africa produces world-class talent.',
      requiredSubjects: ['Physical Education', 'Biology'],
      recommendedClubs: ['Football team', 'Gym', 'Athletics'],
      targetUniversities: ['Sports academies', 'FCZ Academy', 'COSAFA youth programmes'],
      scholarshipTypes: ['Sports scholarship', 'CAF development programme'],
      dailyGoals: [
        _g('d1','Football training · 2 hrs','Team or individual session — never miss',GoalFrequency.daily,GoalCategory.sport),
        _g('d2','Gym / strength training · 45 min','Build strength and power',GoalFrequency.daily,GoalCategory.sport),
        _g('d3','Watch match footage · 30 min','Study professional players in your position',GoalFrequency.daily,GoalCategory.sport),
        _g('d4','Recovery · stretching · 20 min','Prevent injury — stretching is non-negotiable',GoalFrequency.daily,GoalCategory.sport),
        _g('d5','Maintain academic minimum · 1 hr','GPA 2.0+ protects your future',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Log all match stats','Goals, assists, distance, speed via Life Cycle',GoalFrequency.weekly,GoalCategory.sport),
        _g('w2','Skills drill session · 1 hr','Focus on one weak area per week',GoalFrequency.weekly,GoalCategory.sport),
        _g('w3','Review leaderboard position','Track Africa rank progression',GoalFrequency.weekly,GoalCategory.sport),
        _g('w4','Nutrition and diet check','Track meals and hydration',GoalFrequency.weekly,GoalCategory.sport),
      ],
      monthlyGoals: [
        _g('m1','Compete in at least one match','Match exposure is critical',GoalFrequency.monthly,GoalCategory.sport),
        _g('m2','Review personal best stats','Top speed, distance, goals per game',GoalFrequency.monthly,GoalCategory.sport),
        _g('m3','Contact or research one academy','Proactively pursue opportunities',GoalFrequency.monthly,GoalCategory.sport),
      ],
    ),

    CareerPath(
      id: 'pro_basketball', title: 'Professional Basketball Player', subtitle: 'Sports · ongoing career',
      category: 'Sports', icon: Icons.sports_basketball, color: LCColors.orange,
      minGPA: 2.0, minSportRank: 10, trainingYears: 'Ongoing',
      description: 'Build a career in basketball — BAL (Basketball Africa League) is growing rapidly.',
      requiredSubjects: ['Physical Education'],
      recommendedClubs: ['Basketball team', 'Gym', 'Athletics'],
      targetUniversities: ['BAL academies', 'NBA Africa development'],
      scholarshipTypes: ['Sports scholarship', 'BAL development programme'],
      dailyGoals: [
        _g('d1','Basketball training · 2 hrs','Team or solo session',GoalFrequency.daily,GoalCategory.sport),
        _g('d2','Shooting drills · 30 min','100 shots — free throws, mid-range, threes',GoalFrequency.daily,GoalCategory.sport),
        _g('d3','Strength training · 45 min','Power and speed',GoalFrequency.daily,GoalCategory.sport),
        _g('d4','Study professional games · 30 min','Watch and learn from pro players',GoalFrequency.daily,GoalCategory.sport),
      ],
      weeklyGoals: [
        _g('w1','Log all game stats','Points, rebounds, assists, steals, blocks',GoalFrequency.weekly,GoalCategory.sport),
        _g('w2','One-on-one skills session','Work on ball handling and footwork',GoalFrequency.weekly,GoalCategory.sport),
        _g('w3','Track leaderboard rank','Zimbabwe → Africa → Global',GoalFrequency.weekly,GoalCategory.sport),
      ],
      monthlyGoals: [
        _g('m1','Compete in a tournament','Tournament experience is irreplaceable',GoalFrequency.monthly,GoalCategory.sport),
        _g('m2','Personal best review','Height, vertical jump, speed',GoalFrequency.monthly,GoalCategory.sport),
      ],
    ),

    CareerPath(
      id: 'athlete', title: 'Professional Athlete (Athletics)', subtitle: 'Sports · ongoing career',
      category: 'Sports', icon: Icons.directions_run, color: LCColors.red,
      minGPA: 2.0, minSportRank: 5, trainingYears: 'Ongoing',
      description: 'Represent your country at continental and global athletics competitions.',
      requiredSubjects: ['Physical Education', 'Biology'],
      recommendedClubs: ['Athletics club', 'Gym', 'Nutrition club'],
      targetUniversities: ['Sports academies', 'Athletics programmes'],
      scholarshipTypes: ['Sports scholarship', 'Olympic committee bursary'],
      dailyGoals: [
        _g('d1','Track training · 2 hrs','Sprint, endurance, or field events',GoalFrequency.daily,GoalCategory.sport),
        _g('d2','Strength and conditioning · 45 min','Sport-specific gym work',GoalFrequency.daily,GoalCategory.sport),
        _g('d3','Stretching and recovery · 30 min','Prevent injury',GoalFrequency.daily,GoalCategory.sport),
        _g('d4','Log personal bests','100m, 200m, or field event PBs',GoalFrequency.daily,GoalCategory.sport),
      ],
      weeklyGoals: [
        _g('w1','Speed and time trials','Measured race efforts',GoalFrequency.weekly,GoalCategory.sport),
        _g('w2','Video review of technique','Analyse your form',GoalFrequency.weekly,GoalCategory.sport),
        _g('w3','Nutrition plan review','Track food and supplements',GoalFrequency.weekly,GoalCategory.sport),
      ],
      monthlyGoals: [
        _g('m1','Compete in an event','Race or field competition',GoalFrequency.monthly,GoalCategory.sport),
        _g('m2','Log all personal bests','Compare to continental standards',GoalFrequency.monthly,GoalCategory.sport),
      ],
    ),

    // ── ENTREPRENEURSHIP ────────────────────────────────────
    CareerPath(
      id: 'entrepreneur', title: 'Entrepreneur', subtitle: 'Business · self-directed',
      category: 'Entrepreneurship', icon: Icons.rocket_launch, color: LCColors.gold,
      minGPA: 2.5, trainingYears: 'Self-paced',
      description: 'Build businesses that solve real African problems. The continent needs entrepreneurs more than almost anything else.',
      requiredSubjects: ['Business Studies', 'Mathematics', 'Economics'],
      recommendedClubs: ['Business club', 'Debate', 'Coding club', 'Student council'],
      targetUniversities: ['Ashesi University', 'USIU Africa', 'UCT GSB', 'ALX Africa'],
      scholarshipTypes: ['Tony Elumelu Foundation', 'Anzisha Prize', 'Jack Ma Africa scholarship'],
      dailyGoals: [
        _g('d1','Read business content · 30 min','1 article — entrepreneurship, business, economics',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d2','Work on your business idea · 1 hr','Research, plan, or build something',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d3','Network with one person','Talk to someone new — build your network',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d4','Journal a business observation','What problem did you notice today?',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d5','Study Mathematics · 45 min','Financial literacy starts with maths',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Business club session','Connect with like-minded peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Write one business concept','One page: problem, solution, market',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w3','Read one chapter of a business book','Suggested: Rich Dad Poor Dad, Zero to One, The Lean Startup',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w4','Pitch your idea to someone','Practice pitching — get feedback',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w5','Review your finances/savings','Track what you have and where it goes',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Enter a business competition','Anzisha, school competitions, hackathons',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m2','Build a minimum viable product','Something real — even a simple one',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m3','Interview one entrepreneur','Ask about their journey and lessons',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m4','Set next month\'s business milestones','Written goals with deadlines',GoalFrequency.monthly,GoalCategory.entrepreneurship),
      ],
    ),

    CareerPath(
      id: 'tech_entrepreneur', title: 'Tech Entrepreneur', subtitle: 'Entrepreneurship · Tech',
      category: 'Entrepreneurship', icon: Icons.lightbulb, color: LCColors.gold,
      minGPA: 2.8, trainingYears: 'Self-paced',
      description: 'Build the next African tech startup — like Life Cycle itself.',
      requiredSubjects: ['Computer Science', 'Mathematics', 'Business Studies'],
      recommendedClubs: ['Coding club', 'Business club', 'Hackathon team'],
      targetUniversities: ['ALX Africa', 'Ashesi', 'UCT', 'Carnegie Mellon Africa'],
      scholarshipTypes: ['Google Africa scholarship', 'Tony Elumelu Foundation', 'Anzisha Prize'],
      dailyGoals: [
        _g('d1','Code for 1.5 hrs','Build something — an app, tool, or feature',GoalFrequency.daily,GoalCategory.technical),
        _g('d2','Learn one new tech concept · 30 min','YouTube, docs, or a course',GoalFrequency.daily,GoalCategory.technical),
        _g('d3','Business problem journal','What African problem can tech solve?',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d4','Follow one startup founder online','Learn from their journey in real time',GoalFrequency.daily,GoalCategory.entrepreneurship),
      ],
      weeklyGoals: [
        _g('w1','Attend hackathon or coding club','Build and compete',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Ship one product update','Push something live — no matter how small',GoalFrequency.weekly,GoalCategory.technical),
        _g('w3','Talk to potential users','Validate your idea with real people',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w4','Competitive research · 1 hr','Who else is solving your problem?',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Launch or update your product','Something live and usable',GoalFrequency.monthly,GoalCategory.technical),
        _g('m2','Write a business model canvas','One-page plan for your startup',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m3','Apply to one accelerator or competition','YC, Anzisha, Seedstars Africa, etc.',GoalFrequency.monthly,GoalCategory.entrepreneurship),
      ],
    ),

    CareerPath(
      id: 'social_entrepreneur', title: 'Social Entrepreneur', subtitle: 'Entrepreneurship · Impact',
      category: 'Entrepreneurship', icon: Icons.volunteer_activism, color: LCColors.gold,
      minGPA: 2.5, trainingYears: 'Self-paced',
      description: 'Build organisations that solve social problems — not just for profit, but for people.',
      requiredSubjects: ['Business Studies', 'Social Studies', 'Economics'],
      recommendedClubs: ['Community service', 'Student council', 'Debate', 'Environment club'],
      targetUniversities: ['USIU Africa', 'Ashesi', 'African Leadership University'],
      scholarshipTypes: ['Mastercard Foundation', 'African Leadership Academy', 'Tony Elumelu Foundation'],
      dailyGoals: [
        _g('d1','Community problem observation · 30 min','Document one social problem you see today',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d2','Read social impact news · 20 min','NGOs, social enterprises, development work',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d3','Academic study · 1 hr','Keep grades strong for scholarship access',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','Volunteer or community task · 30 min','Show up for your community daily',GoalFrequency.daily,GoalCategory.extracurricular),
      ],
      weeklyGoals: [
        _g('w1','Community service session · 2 hrs','Hands-on service',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Work on your social project','Develop your solution this week',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w3','Speak to someone your project affects','User research — listen to real people',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Present your social project','To class, club, or community',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m2','Apply to a leadership programme','African Leadership Academy, etc.',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m3','Measure your impact','How many people did you reach this month?',GoalFrequency.monthly,GoalCategory.entrepreneurship),
      ],
    ),

    // ── POLITICS & LEADERSHIP ────────────────────────────────
    CareerPath(
      id: 'politician', title: 'Politician / Public Servant', subtitle: 'Leadership · Law & Politics',
      category: 'Politics & Leadership', icon: Icons.account_balance, color: LCColors.purple,
      minGPA: 3.0, trainingYears: '5+ years',
      description: 'Shape policy and lead your nation. Africa needs ethical, educated leaders in government.',
      requiredSubjects: ['History', 'English', 'Social Studies', 'Economics'],
      recommendedClubs: ['Student council', 'Debate', 'Community service', 'Model UN'],
      targetUniversities: ['University of Zimbabwe', 'UCT', 'SOAS London', 'Georgetown', 'ALA'],
      scholarshipTypes: ['Chevening', 'MasterCard Foundation', 'African Presidential Scholars'],
      dailyGoals: [
        _g('d1','Read current affairs · 30 min','Local and African politics — know what\'s happening',GoalFrequency.daily,GoalCategory.leadership),
        _g('d2','History study · 1 hr','Understand the past to shape the future',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Public speaking practice · 20 min','Record yourself speaking on a topic',GoalFrequency.daily,GoalCategory.leadership),
        _g('d4','English and writing · 1 hr','Policy makers must write and communicate clearly',GoalFrequency.daily,GoalCategory.academic),
        _g('d5','Community engagement','Talk to someone outside your usual circle',GoalFrequency.daily,GoalCategory.leadership),
      ],
      weeklyGoals: [
        _g('w1','Student council meeting','Build leadership experience now',GoalFrequency.weekly,GoalCategory.leadership),
        _g('w2','Debate club session','Practise persuasion and argument',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w3','Write a policy opinion piece','1 page on any current issue',GoalFrequency.weekly,GoalCategory.leadership),
        _g('w4','Community service · 2 hrs','Future leaders serve their communities',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w5','Study one African political figure','Learn from their path',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Lead a school initiative','Organise or chair something',GoalFrequency.monthly,GoalCategory.leadership),
        _g('m2','Attend a community meeting or event','Observe how decisions get made',GoalFrequency.monthly,GoalCategory.leadership),
        _g('m3','Apply for a leadership programme','ALA, Model African Union, etc.',GoalFrequency.monthly,GoalCategory.leadership),
        _g('m4','Write your vision for your community','What do you want to change?',GoalFrequency.monthly,GoalCategory.leadership),
      ],
    ),

    CareerPath(
      id: 'diplomat', title: 'Diplomat / Foreign Affairs', subtitle: 'Leadership · International Relations',
      category: 'Politics & Leadership', icon: Icons.language, color: LCColors.purple,
      minGPA: 3.2, trainingYears: '5+ years',
      description: 'Represent your country on the world stage. One of the most prestigious careers in Africa.',
      requiredSubjects: ['History', 'English', 'Social Studies', 'French or Portuguese'],
      recommendedClubs: ['Debate', 'Model UN', 'Languages club', 'Student council'],
      targetUniversities: ['UCT', 'SOAS London', 'Sciences Po Paris', 'Georgetown', 'UZ'],
      scholarshipTypes: ['Chevening', 'Commonwealth scholarship', 'African Union scholarship'],
      dailyGoals: [
        _g('d1','Read international news · 30 min','Al Jazeera, BBC Africa, The Continent',GoalFrequency.daily,GoalCategory.leadership),
        _g('d2','Language practice · 30 min','French, Portuguese, or Arabic — diplomats are multilingual',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','History study · 1 hr','International history and African geopolitics',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','English writing · 45 min','Diplomatic writing is precise and formal',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Model UN or debate session','Practise international negotiations',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Study one country\'s relationship with Africa','Know the geopolitical landscape',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Write one position paper','On any international issue',GoalFrequency.weekly,GoalCategory.leadership),
      ],
      monthlyGoals: [
        _g('m1','Participate in a Model UN conference','Simulate real diplomacy',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m2','Research scholarship programmes','Chevening, Commonwealth, AU',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── LAW ─────────────────────────────────────────────────
    CareerPath(
      id: 'lawyer', title: 'Lawyer', subtitle: 'Law · 5 years',
      category: 'Law', icon: Icons.gavel, color: LCColors.purple,
      minGPA: 3.3, trainingYears: '5 years',
      description: 'Advocate for justice and navigate the legal systems that shape African societies.',
      requiredSubjects: ['English', 'History', 'Social Studies', 'Mathematics'],
      recommendedClubs: ['Debate', 'Student council', 'Human rights club'],
      targetUniversities: ['UZ Law', 'UCT Law', 'Wits Law', 'University of Lagos Law'],
      scholarshipTypes: ['Law bursary', 'Commonwealth scholarship', 'African Human Rights scholarship'],
      dailyGoals: [
        _g('d1','English and writing · 1.5 hrs','Lawyers live and die by written argument',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Read current legal news · 20 min','Follow court cases and new legislation',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Debate practice · 30 min','Argument and counter-argument daily',GoalFrequency.daily,GoalCategory.leadership),
        _g('d4','History study · 45 min','Law is rooted in history',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Debate club session','Core training for a lawyer',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Read one legal case summary','Research a real or famous case',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Write a persuasive essay','Practice constructing a legal argument',GoalFrequency.weekly,GoalCategory.academic),
        _g('w4','Student council or human rights club','Live leadership and advocacy experience',GoalFrequency.weekly,GoalCategory.extracurricular),
      ],
      monthlyGoals: [
        _g('m1','Mock trial or moot court','Simulate courtroom advocacy',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m2','Visit a court','Observe real proceedings',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m3','Track GPA toward 3.3+','Law school requirements',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── ARTS & CREATIVE ─────────────────────────────────────
    CareerPath(
      id: 'musician', title: 'Professional Musician', subtitle: 'Arts · self-directed',
      category: 'Arts & Creative', icon: Icons.music_note, color: LCColors.purple,
      minGPA: 2.0, trainingYears: 'Ongoing',
      description: 'Build a career in music — Africa\'s music industry is one of the fastest growing in the world.',
      requiredSubjects: ['Music', 'English'],
      recommendedClubs: ['Music club', 'Drama club', 'Choir'],
      targetUniversities: ['Music conservatories', 'AFDA', 'New York Film Academy Africa'],
      scholarshipTypes: ['Arts council grant', 'NFVF bursary'],
      dailyGoals: [
        _g('d1','Instrument practice · 1.5 hrs','Daily practice is how musicians grow',GoalFrequency.daily,GoalCategory.creative),
        _g('d2','Listen and analyse music · 30 min','Study the craft of artists you admire',GoalFrequency.daily,GoalCategory.creative),
        _g('d3','Write or compose · 30 min','Lyrics, melodies, or arrangements',GoalFrequency.daily,GoalCategory.creative),
        _g('d4','Voice or vocal exercises if singer · 20 min','Protect and develop your instrument',GoalFrequency.daily,GoalCategory.creative),
      ],
      weeklyGoals: [
        _g('w1','Music club or choir session','Perform with others weekly',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Record a piece or demo','Document your progress',GoalFrequency.weekly,GoalCategory.creative),
        _g('w3','Study one music artist deeply','How did they build their career?',GoalFrequency.weekly,GoalCategory.creative),
      ],
      monthlyGoals: [
        _g('m1','Perform publicly','School event, church, community — get stage time',GoalFrequency.monthly,GoalCategory.creative),
        _g('m2','Log award nominations or wins','Build your performance record',GoalFrequency.monthly,GoalCategory.creative),
        _g('m3','Release or share a new recording','Online, at school, or to peers',GoalFrequency.monthly,GoalCategory.creative),
      ],
    ),

    CareerPath(
      id: 'actor', title: 'Actor / Performer', subtitle: 'Arts · self-directed',
      category: 'Arts & Creative', icon: Icons.theater_comedy, color: LCColors.purple,
      minGPA: 2.0, trainingYears: 'Ongoing',
      description: 'African cinema is booming — Nollywood, South African film, and streaming are creating enormous opportunity.',
      requiredSubjects: ['English', 'Drama', 'History'],
      recommendedClubs: ['Drama club', 'Debate', 'Choir', 'Film club'],
      targetUniversities: ['AFDA', 'New York Film Academy Africa', 'SADA'],
      scholarshipTypes: ['Arts council grant', 'NFVF bursary'],
      dailyGoals: [
        _g('d1','Script memorisation · 30 min','Or improvisation practice',GoalFrequency.daily,GoalCategory.creative),
        _g('d2','Voice and diction · 20 min','Clear, expressive speech is fundamental',GoalFrequency.daily,GoalCategory.creative),
        _g('d3','Watch a film critically · 45 min','Analyse performances, not just the story',GoalFrequency.daily,GoalCategory.creative),
        _g('d4','Physical movement/dance · 30 min','Actors need physical awareness',GoalFrequency.daily,GoalCategory.creative),
      ],
      weeklyGoals: [
        _g('w1','Drama club session','Perform and rehearse with peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Perform a monologue or scene','Record it and review yourself',GoalFrequency.weekly,GoalCategory.creative),
        _g('w3','Audition for something','School play, community theatre, short film',GoalFrequency.weekly,GoalCategory.creative),
      ],
      monthlyGoals: [
        _g('m1','Perform in a production','School play, musical, or film',GoalFrequency.monthly,GoalCategory.creative),
        _g('m2','Log performances and nominations','Build your acting profile on Life Cycle',GoalFrequency.monthly,GoalCategory.creative),
        _g('m3','Study one African actor','How did they build their career in Africa?',GoalFrequency.monthly,GoalCategory.creative),
      ],
    ),

    // ── FINANCE ─────────────────────────────────────────────
    CareerPath(
      id: 'accountant', title: 'Chartered Accountant', subtitle: 'Finance · 5+ years',
      category: 'Finance', icon: Icons.calculate, color: LCColors.gold,
      minGPA: 3.2, trainingYears: '5+ years',
      description: 'Master the language of business — accounting underpins every organisation on the continent.',
      requiredSubjects: ['Mathematics', 'Accounting', 'Economics', 'Business Studies'],
      recommendedClubs: ['Business club', 'Maths club', 'Debate'],
      targetUniversities: ['UZ', 'UCT Commerce', 'Wits', 'NUST'],
      scholarshipTypes: ['ICAZ bursary', 'ACCA scholarship', 'Big 4 bursary'],
      dailyGoals: [
        _g('d1','Mathematics · 1.5 hrs','Accounting is applied maths',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Accounting practice problems · 1 hr','Ledgers, trial balances, income statements',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Read business/finance news · 20 min','Understand the real world your numbers describe',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Business club session','Financial literacy discussions',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','One past paper — Maths or Accounting','Practise under timed conditions',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Personal budget review','Track your own money',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Mock exam — Maths and Accounting','Track readiness',GoalFrequency.monthly,GoalCategory.academic),
        _g('m2','Research ICAZ or ACCA pathway','Understand the professional qualification route',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    CareerPath(
      id: 'investment_banker', title: 'Investment Banker', subtitle: 'Finance · 4+ years',
      category: 'Finance', icon: Icons.trending_up, color: LCColors.gold,
      minGPA: 3.5, trainingYears: '4+ years',
      description: 'Move capital across Africa — one of the highest-earning careers on the continent.',
      requiredSubjects: ['Mathematics', 'Economics', 'Accounting', 'Business Studies'],
      recommendedClubs: ['Business club', 'Debate', 'Maths club'],
      targetUniversities: ['UCT GSB', 'Wits Business School', 'Lagos Business School'],
      scholarshipTypes: ['Banking sector bursary', 'Merit scholarship'],
      dailyGoals: [
        _g('d1','Mathematics · 1.5 hrs','Investment banking requires strong quantitative skills',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Follow financial markets · 20 min','ZSE, JSE, NSE — track markets daily',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d3','Economics study · 1 hr','Macro and microeconomics',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Business club session','Network and discuss finance',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Analyse one company\'s financials','Revenue, profit, debt — basic analysis',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w3','Mock investment decision','If you had R10,000 — where would you invest?',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Mock exam — Maths and Economics','3.5+ GPA required',GoalFrequency.monthly,GoalCategory.academic),
        _g('m2','Research one top African bank','Their graduate programme and requirements',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── SCIENCE & RESEARCH ──────────────────────────────────
    CareerPath(
      id: 'scientist', title: 'Research Scientist', subtitle: 'Science · 7+ years',
      category: 'Science', icon: Icons.science, color: LCColors.blue,
      minGPA: 3.6, trainingYears: '7+ years',
      description: 'Push the boundaries of human knowledge. Africa needs home-grown scientists urgently.',
      requiredSubjects: ['Biology', 'Chemistry', 'Physics', 'Mathematics'],
      recommendedClubs: ['Science club', 'Robotics', 'Debate', 'Environment club'],
      targetUniversities: ['UCT', 'Wits', 'University of Nairobi', 'Makerere', 'AIMS'],
      scholarshipTypes: ['NRF bursary', 'AIMS scholarship', 'African Science scholarship'],
      dailyGoals: [
        _g('d1','STEM study · 2 hrs','Deep work on your strongest science subject',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Read one scientific paper or article · 30 min','Build research literacy early',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Lab or experiment log','Document any experiments or observations',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','Mathematics practice · 1 hr','Scientists need strong maths',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Science club session','Experiments and peer discussion',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Complete one STEM past paper','Build examination readiness',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','One independent experiment','Curiosity-driven investigation',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Science olympiad or competition','National or school level',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m2','Mock exam — all STEM subjects','3.6+ GPA target',GoalFrequency.monthly,GoalCategory.academic),
        _g('m3','Research AIMS or similar programme','African Institute for Mathematical Sciences',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── EDUCATION ───────────────────────────────────────────
    CareerPath(
      id: 'teacher', title: 'Teacher / Educator', subtitle: 'Education · 4 years',
      category: 'Education', icon: Icons.school, color: LCColors.blue,
      minGPA: 2.8, trainingYears: '4 years',
      description: 'Teachers change everything. Educating Africa\'s children is among the most important work on the continent.',
      requiredSubjects: ['English', 'Mathematics', 'Your chosen subject'],
      recommendedClubs: ['Tutoring club', 'Community service', 'Student council', 'Drama'],
      targetUniversities: ['UZ Education', 'NUST', 'Bindura', 'University of Education Winneba'],
      scholarshipTypes: ['Government teacher bursary', 'HRDC scholarship'],
      dailyGoals: [
        _g('d1','Peer tutoring · 30 min','Teach what you know — it solidifies your own learning',GoalFrequency.daily,GoalCategory.leadership),
        _g('d2','Subject study · 1.5 hrs','Master the content you want to teach',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Read an education article · 20 min','Follow trends in African education',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Tutoring club session','Help peers and build teaching skills',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Prepare a lesson plan','Practise planning and structuring learning',GoalFrequency.weekly,GoalCategory.leadership),
        _g('w3','Community service · 2 hrs','Teachers serve communities',GoalFrequency.weekly,GoalCategory.extracurricular),
      ],
      monthlyGoals: [
        _g('m1','Run a study group or workshop','Lead a group learning session',GoalFrequency.monthly,GoalCategory.leadership),
        _g('m2','Observe a teacher you admire','What makes them effective?',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── ARCHITECTURE & DESIGN ───────────────────────────────
    CareerPath(
      id: 'architect', title: 'Architect', subtitle: 'Design · 5+ years',
      category: 'Architecture & Design', icon: Icons.architecture, color: LCColors.orange,
      minGPA: 3.0, trainingYears: '5+ years',
      description: 'Design the built environment of Africa\'s rapidly urbanising cities.',
      requiredSubjects: ['Mathematics', 'Art', 'Physics', 'Technical Drawing'],
      recommendedClubs: ['Art club', 'Design team', 'Science club'],
      targetUniversities: ['UCT Architecture', 'Wits Architecture', 'UZ', 'NUST'],
      scholarshipTypes: ['SACAP bursary', 'Architecture foundation grant'],
      dailyGoals: [
        _g('d1','Draw and sketch · 1 hr','Freehand drawing is core to architecture',GoalFrequency.daily,GoalCategory.creative),
        _g('d2','Mathematics · 1 hr','Geometry and technical maths',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Study architecture · 30 min','Buildings, architects, spatial design',GoalFrequency.daily,GoalCategory.creative),
      ],
      weeklyGoals: [
        _g('w1','Art club session','Develop visual skills',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Design one space or building concept','Sketch a complete idea',GoalFrequency.weekly,GoalCategory.creative),
        _g('w3','Past paper — Maths or Technical Drawing','3.0+ GPA required',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Build a physical or digital model','3D model of something you designed',GoalFrequency.monthly,GoalCategory.creative),
        _g('m2','Visit a notable building in your city','Study architecture in real life',GoalFrequency.monthly,GoalCategory.extracurricular),
      ],
    ),

    // ── JOURNALISM & MEDIA ──────────────────────────────────
    CareerPath(
      id: 'journalist', title: 'Journalist / Media', subtitle: 'Media · 4 years',
      category: 'Media & Journalism', icon: Icons.article, color: LCColors.orange,
      minGPA: 2.8, trainingYears: '4 years',
      description: 'Tell Africa\'s stories. Journalism is democracy\'s backbone.',
      requiredSubjects: ['English', 'History', 'Social Studies'],
      recommendedClubs: ['School newspaper', 'Debate', 'Drama', 'Photography club'],
      targetUniversities: ['Wits Journalism', 'Rhodes Journalism', 'NUST Media', 'AUC'],
      scholarshipTypes: ['Media institute scholarship', 'Press freedom foundation grant'],
      dailyGoals: [
        _g('d1','Read three news sources · 30 min','Stay informed — journalists are current',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Write daily · 30 min','A news report, opinion piece, or blog',GoalFrequency.daily,GoalCategory.creative),
        _g('d3','English study · 45 min','Writing accuracy and clarity',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','Photograph or film something · 15 min','Visual storytelling is journalism too',GoalFrequency.daily,GoalCategory.creative),
      ],
      weeklyGoals: [
        _g('w1','School newspaper contribution','Write or edit for publication',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Debate club session','Arguments and rhetoric',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w3','Interview someone','Practice the craft of journalism',GoalFrequency.weekly,GoalCategory.creative),
        _g('w4','Produce one piece of content','Article, video, or podcast episode',GoalFrequency.weekly,GoalCategory.creative),
      ],
      monthlyGoals: [
        _g('m1','Publish something publicly','School paper, blog, social media long-form',GoalFrequency.monthly,GoalCategory.creative),
        _g('m2','Attend a community event to report on','Journalism is showing up',GoalFrequency.monthly,GoalCategory.extracurricular),
      ],
    ),

    // ── AGRICULTURE ─────────────────────────────────────────
    CareerPath(
      id: 'agri_entrepreneur', title: 'Agricultural Entrepreneur', subtitle: 'Agriculture · Business',
      category: 'Entrepreneurship', icon: Icons.grass, color: LCColors.primary,
      minGPA: 2.5, trainingYears: 'Self-paced',
      description: 'Agriculture is Africa\'s largest sector. AgriTech and commercial farming create generational wealth.',
      requiredSubjects: ['Biology', 'Chemistry', 'Business Studies', 'Geography'],
      recommendedClubs: ['Agriculture club', 'Environment club', 'Business club'],
      targetUniversities: ['UZ Agriculture', 'Chinhoyi University', 'University of Nairobi Agriculture'],
      scholarshipTypes: ['AgDevCo grant', 'AGRA scholarship', 'Africa Agriculture scholarship'],
      dailyGoals: [
        _g('d1','Biology · 1 hr','Soil science, plant biology, ecology',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Agriculture news · 20 min','Follow African farming and food systems',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d3','Business planning · 30 min','Develop your farm or agribusiness concept',GoalFrequency.daily,GoalCategory.entrepreneurship),
      ],
      weeklyGoals: [
        _g('w1','Agriculture or environment club','Hands-on practical experience',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Research one agri opportunity','What crop, product, or service is in demand?',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w3','Talk to a farmer or agri-business owner','Real-world insight',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Start a small growing project','Even a pot of tomatoes counts',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m2','Develop a business plan for your farm concept','One page',GoalFrequency.monthly,GoalCategory.entrepreneurship),
      ],
    ),

    // ── PSYCHOLOGY ──────────────────────────────────────────
    CareerPath(
      id: 'psychologist', title: 'Psychologist / Counsellor', subtitle: 'Health · 6 years',
      category: 'Medicine', icon: Icons.sentiment_satisfied, color: LCColors.red,
      minGPA: 3.3, trainingYears: '6 years',
      description: 'Mental health is one of the most underserved areas across Africa. The need is enormous and growing.',
      requiredSubjects: ['Biology', 'English', 'Social Studies', 'Mathematics'],
      recommendedClubs: ['Community service', 'Peer support group', 'Debate', 'Science club'],
      targetUniversities: ['UCT', 'Wits', 'UZ', 'University of Ghana'],
      scholarshipTypes: ['Mental health foundation bursary', 'Health sciences scholarship'],
      dailyGoals: [
        _g('d1','Biology and social science · 1.5 hrs','Human behaviour and brain science',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Empathy practice','Actively listen to someone today — no advice, just listen',GoalFrequency.daily,GoalCategory.leadership),
        _g('d3','Journal your own emotional observations','Self-awareness is core to psychology',GoalFrequency.daily,GoalCategory.creative),
        _g('d4','English reading and writing · 45 min','Psychologists must communicate with precision',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Community service or peer support · 2 hrs','Service to people is central to this path',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Read about a psychology concept','One article or book chapter',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Conflict resolution practice','Mediate or help resolve a disagreement',GoalFrequency.weekly,GoalCategory.leadership),
      ],
      monthlyGoals: [
        _g('m1','Research psychology programmes in Africa','UCT, Wits, UZ, Ghana',GoalFrequency.monthly,GoalCategory.academic),
        _g('m2','Lead a wellbeing initiative at school','Mental health awareness campaign, etc.',GoalFrequency.monthly,GoalCategory.leadership),
      ],
    ),

    // ── AVIATION ────────────────────────────────────────────
    CareerPath(
      id: 'pilot', title: 'Pilot / Aviation', subtitle: 'Aviation · 4+ years',
      category: 'Engineering', icon: Icons.flight, color: LCColors.blue,
      minGPA: 3.0, trainingYears: '4+ years',
      description: 'Africa\'s aviation sector is growing fast. Pilots are in high demand across the continent.',
      requiredSubjects: ['Mathematics', 'Physics', 'Geography'],
      recommendedClubs: ['Science club', 'Robotics', 'Geography club'],
      targetUniversities: ['Zimbabwean Aviation College', 'SACAA', 'Kenya Aviation Training Institute'],
      scholarshipTypes: ['Aviation scholarship', 'Air Force bursary'],
      dailyGoals: [
        _g('d1','Mathematics · 1.5 hrs','Navigation and aerodynamics demand strong maths',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Physics · 1 hr','Forces, motion, and atmosphere',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Geography · 30 min','Meteorology and navigation',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','Physical fitness · 45 min','Pilots must pass medical fitness standards',GoalFrequency.daily,GoalCategory.sport),
      ],
      weeklyGoals: [
        _g('w1','Flight simulator practice if available','Even a mobile simulator helps',GoalFrequency.weekly,GoalCategory.technical),
        _g('w2','Physics past paper','Stay on track for required GPA',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Research aviation news','Follow African airline and aviation sector',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Mock exam — Physics and Maths','3.0+ required',GoalFrequency.monthly,GoalCategory.academic),
        _g('m2','Research aviation training colleges','Understand the pathway and costs',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── FASHION & DESIGN ────────────────────────────────────
    CareerPath(
      id: 'fashion_designer', title: 'Fashion Designer', subtitle: 'Creative Industry · self-directed',
      category: 'Arts & Creative', icon: Icons.style, color: LCColors.purple,
      minGPA: 2.0, trainingYears: 'Ongoing',
      description: 'African fashion is a global force. From Lagos to Johannesburg, African designers are reshaping the industry.',
      requiredSubjects: ['Art', 'Textiles', 'Business Studies'],
      recommendedClubs: ['Art club', 'Fashion club', 'Business club'],
      targetUniversities: ['Vaal University of Technology', 'IFR Nairobi', 'LISOF'],
      scholarshipTypes: ['Arts council grant', 'African fashion scholarship'],
      dailyGoals: [
        _g('d1','Sketch designs · 1 hr','Daily design work builds your portfolio',GoalFrequency.daily,GoalCategory.creative),
        _g('d2','Study fashion content · 30 min','African designers, global trends',GoalFrequency.daily,GoalCategory.creative),
        _g('d3','Sew or make something · 30 min','Practical skill development daily',GoalFrequency.daily,GoalCategory.creative),
        _g('d4','Business study · 30 min','Fashion is a business — know margins and markets',GoalFrequency.daily,GoalCategory.entrepreneurship),
      ],
      weeklyGoals: [
        _g('w1','Art club session','Creative development with peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Complete one garment or design piece','Tangible output weekly',GoalFrequency.weekly,GoalCategory.creative),
        _g('w3','Research African fashion markets','Where do opportunities exist?',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Stage or attend a fashion show','See the industry live',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m2','Build your portfolio','Document all completed pieces',GoalFrequency.monthly,GoalCategory.creative),
      ],
    ),

    // ── ENVIRONMENT & CLIMATE ───────────────────────────────
    CareerPath(
      id: 'environmental_scientist', title: 'Environmental Scientist', subtitle: 'Science · 4+ years',
      category: 'Science', icon: Icons.eco, color: LCColors.primary,
      minGPA: 3.0, trainingYears: '4+ years',
      description: 'Climate change hits Africa hardest. Environmental scientists and climate advocates are critical for the continent\'s future.',
      requiredSubjects: ['Biology', 'Chemistry', 'Geography', 'Mathematics'],
      recommendedClubs: ['Environment club', 'Science club', 'Community service'],
      targetUniversities: ['UCT Environmental Science', 'University of Ghana', 'Makerere', 'AIMS'],
      scholarshipTypes: ['Climate scholarship', 'UNEP bursary', 'African Climate Foundation'],
      dailyGoals: [
        _g('d1','Biology and Geography · 1.5 hrs','Ecosystems, climate systems, biodiversity',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Follow climate and environment news · 20 min','Africa\'s environment is the context for this career',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Document your local environment · 15 min','Observe and journal what you see',GoalFrequency.daily,GoalCategory.creative),
      ],
      weeklyGoals: [
        _g('w1','Environment club session','Advocacy and learning',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Science past paper','3.0+ GPA required',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Community environmental project · 1 hr','Practical local action',GoalFrequency.weekly,GoalCategory.extracurricular),
      ],
      monthlyGoals: [
        _g('m1','Lead or join an environmental campaign','School, community, or national',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m2','Research climate scholarships','UNEP, African Climate Foundation, etc.',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── SPORTS COACHING & MANAGEMENT ────────────────────────
    CareerPath(
      id: 'sports_coach', title: 'Sports Coach / Manager', subtitle: 'Sports Management · 3-4 years',
      category: 'Sports', icon: Icons.sports, color: LCColors.primary,
      minGPA: 2.5, trainingYears: '3-4 years',
      description: 'Lead and develop the next generation of African athletes.',
      requiredSubjects: ['Physical Education', 'Biology', 'Business Studies'],
      recommendedClubs: ['Sport teams', 'Gym', 'Student council'],
      targetUniversities: ['UZ Sport Science', 'Tshwane University', 'University of Pretoria Sport'],
      scholarshipTypes: ['Sport science bursary', 'Coaching scholarship'],
      dailyGoals: [
        _g('d1','Physical training · 1 hr','Stay fit — coaches must lead from the front',GoalFrequency.daily,GoalCategory.sport),
        _g('d2','Study coaching methodology · 30 min','Read about coaching philosophy and tactics',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Watch sport analytically · 30 min','Study how coaches manage players and tactics',GoalFrequency.daily,GoalCategory.sport),
      ],
      weeklyGoals: [
        _g('w1','Coach or assist a younger team','Lead a junior training session',GoalFrequency.weekly,GoalCategory.leadership),
        _g('w2','Log training session stats','Track players you work with',GoalFrequency.weekly,GoalCategory.sport),
        _g('w3','Sport management study · 1 hr','Business side of sport',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Organise a sporting event','Tournament, fun run, or competition',GoalFrequency.monthly,GoalCategory.leadership),
        _g('m2','Study one professional coach','Their methodology and career path',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── CYBER SECURITY ──────────────────────────────────────
    CareerPath(
      id: 'cybersecurity', title: 'Cybersecurity Specialist', subtitle: 'Technology · 4 years',
      category: 'Technology', icon: Icons.security, color: LCColors.blue,
      minGPA: 3.0, trainingYears: '4 years',
      description: 'As Africa goes digital, cybersecurity is one of the most critical and fastest-growing career fields.',
      requiredSubjects: ['Computer Science', 'Mathematics', 'Physics'],
      recommendedClubs: ['Coding club', 'Robotics', 'Science club'],
      targetUniversities: ['Carnegie Mellon Africa', 'UCT', 'Strathmore', 'ALX Africa'],
      scholarshipTypes: ['Google scholarship', 'Cisco Africa scholarship', 'Cybersecurity bursary'],
      dailyGoals: [
        _g('d1','Coding practice · 1 hr','Python, Linux basics, networking',GoalFrequency.daily,GoalCategory.technical),
        _g('d2','Cybersecurity course/tutorial · 30 min','TryHackMe, HackTheBox, or similar',GoalFrequency.daily,GoalCategory.technical),
        _g('d3','Maths · 45 min','Cryptography needs strong maths',GoalFrequency.daily,GoalCategory.academic),
        _g('d4','Follow cybersecurity news · 15 min','Know what attacks are happening in Africa',GoalFrequency.daily,GoalCategory.technical),
      ],
      weeklyGoals: [
        _g('w1','Coding club session','Build with peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Complete a security challenge','CTF (Capture the Flag) or similar',GoalFrequency.weekly,GoalCategory.technical),
        _g('w3','Maths past paper','Maintain 3.0+ GPA',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Complete a security certification module','CompTIA Security+, CEH, or similar',GoalFrequency.monthly,GoalCategory.technical),
        _g('m2','Enter a cybersecurity competition','School or national level CTF',GoalFrequency.monthly,GoalCategory.extracurricular),
      ],
    ),

    // ── DATA SCIENCE ────────────────────────────────────────
    CareerPath(
      id: 'data_scientist', title: 'Data Scientist', subtitle: 'Technology · 4 years',
      category: 'Technology', icon: Icons.bar_chart, color: LCColors.blue,
      minGPA: 3.2, trainingYears: '4 years',
      description: 'Turn data into insight. Africa generates enormous data — someone needs to make sense of it.',
      requiredSubjects: ['Mathematics', 'Statistics', 'Computer Science'],
      recommendedClubs: ['Coding club', 'Maths club', 'Science club'],
      targetUniversities: ['AIMS', 'UCT', 'Ashesi', 'Carnegie Mellon Africa'],
      scholarshipTypes: ['AIMS scholarship', 'Google Africa scholarship', 'Data science bursary'],
      dailyGoals: [
        _g('d1','Statistics and Maths · 1.5 hrs','Data science is applied statistics',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Python or R practice · 1 hr','Learn the language of data',GoalFrequency.daily,GoalCategory.technical),
        _g('d3','Analyse a dataset · 30 min','Kaggle beginner datasets or similar',GoalFrequency.daily,GoalCategory.technical),
      ],
      weeklyGoals: [
        _g('w1','Maths or coding club session','Build skills with peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Complete a Kaggle challenge','Apply skills to real data',GoalFrequency.weekly,GoalCategory.technical),
        _g('w3','Statistics past paper','3.2+ GPA required',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Build a data project','Analyse something you care about',GoalFrequency.monthly,GoalCategory.technical),
        _g('m2','Research AIMS or data programmes','Understand the pathway',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── NURSING ─────────────────────────────────────────────
    CareerPath(
      id: 'nurse', title: 'Registered Nurse', subtitle: 'Healthcare · 4 years',
      category: 'Medicine', icon: Icons.medical_services, color: LCColors.red,
      minGPA: 3.0, trainingYears: '4 years',
      description: 'Nurses are the backbone of African healthcare. Critical shortages mean huge demand and impact.',
      requiredSubjects: ['Biology', 'Chemistry', 'Mathematics'],
      recommendedClubs: ['First aid club', 'Science club', 'Community service'],
      targetUniversities: ['UZ Nursing', 'Bindura', 'University of KwaZulu-Natal'],
      scholarshipTypes: ['Ministry of Health bursary', 'Nursing council scholarship'],
      dailyGoals: [
        _g('d1','Biology · 1.5 hrs','Human anatomy and physiology',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','First aid practice · 20 min','Basic life support and clinical skills',GoalFrequency.daily,GoalCategory.sport),
        _g('d3','Community service · 30 min','Patient-centred mindset from day one',GoalFrequency.daily,GoalCategory.extracurricular),
      ],
      weeklyGoals: [
        _g('w1','First aid or science club','Practical skills and peer learning',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Biology past paper','Build exam readiness',GoalFrequency.weekly,GoalCategory.academic),
        _g('w3','Community service · 2 hrs','Serve your community',GoalFrequency.weekly,GoalCategory.extracurricular),
      ],
      monthlyGoals: [
        _g('m1','Hospital or clinic visit','Real clinical exposure',GoalFrequency.monthly,GoalCategory.extracurricular),
        _g('m2','Mock exam — Biology and Chemistry','Track readiness',GoalFrequency.monthly,GoalCategory.academic),
      ],
    ),

    // ── REAL ESTATE ─────────────────────────────────────────
    CareerPath(
      id: 'real_estate', title: 'Real Estate Developer', subtitle: 'Property · Business',
      category: 'Entrepreneurship', icon: Icons.home_work, color: LCColors.gold,
      minGPA: 2.5, trainingYears: 'Self-paced',
      description: 'Africa\'s growing cities need millions of homes. Real estate is one of the most accessible wealth-building paths.',
      requiredSubjects: ['Mathematics', 'Business Studies', 'Geography', 'Economics'],
      recommendedClubs: ['Business club', 'Economics club', 'Debate'],
      targetUniversities: ['UCT Property Studies', 'Wits', 'University of Lagos Business'],
      scholarshipTypes: ['Property foundation bursary', 'Business scholarship'],
      dailyGoals: [
        _g('d1','Business and Maths · 1 hr','Valuation and financial modelling start here',GoalFrequency.daily,GoalCategory.academic),
        _g('d2','Follow property market news · 20 min','Harare, Joburg, Lagos property markets',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d3','Property observation · 15 min','Note one interesting building or development near you',GoalFrequency.daily,GoalCategory.entrepreneurship),
        _g('d4','Save money today','The habit of saving is how you fund your first deal',GoalFrequency.daily,GoalCategory.entrepreneurship),
      ],
      weeklyGoals: [
        _g('w1','Business club session','Financial literacy and deal thinking',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Analyse one property deal','How much, what return, what risk?',GoalFrequency.weekly,GoalCategory.entrepreneurship),
        _g('w3','Talk to someone in property','Agent, developer, landlord — learn from them',GoalFrequency.weekly,GoalCategory.entrepreneurship),
      ],
      monthlyGoals: [
        _g('m1','Build a property business model','Your first investment concept on paper',GoalFrequency.monthly,GoalCategory.entrepreneurship),
        _g('m2','Tour a property development site','See the industry live',GoalFrequency.monthly,GoalCategory.extracurricular),
      ],
    ),

    // ── ARTS & CREATIVE ────────────────────────────────────
    CareerPath(
      id: 'musician', title: 'Professional Musician', subtitle: 'Arts · Performance',
      category: 'Arts & Creative', icon: Icons.library_music, color: LCColors.orange,
      minGPA: 2.5, trainingYears: 'Ongoing',
      description: 'Develop your music career through performance, composition, and collaboration. Great African artists combine disciplined practice with strong artistic identity.',
      requiredSubjects: ['Music', 'English', 'Art', 'Mathematics'],
      recommendedClubs: ['Music club', 'Choir', 'Drama club', 'Cultural club'],
      targetUniversities: ['UCT Music', 'MUT Music', 'Alfreda Academy', 'Africa Music Institute'],
      scholarshipTypes: ['Music scholarship', 'Arts bursary', 'Cultural fund'],
      dailyGoals: [
        _g('d1','Practice your instrument/vocals · 1 hr','Build technical skill and tone quality',GoalFrequency.daily,GoalCategory.creative),
        _g('d2','Learn a new song section · 30 min','Incremental progress adds up fast',GoalFrequency.daily,GoalCategory.creative),
        _g('d3','Listen to a great track analytically','Note arrangement, melody, and groove',GoalFrequency.daily,GoalCategory.creative),
        _g('d4','Write or improve lyrics','Capture one line, phrase or hook',GoalFrequency.daily,GoalCategory.creative),
        _g('d5','Maintain academic focus · 30 min','Keep school grades strong for further arts study',GoalFrequency.daily,GoalCategory.academic),
      ],
      weeklyGoals: [
        _g('w1','Attend or host a rehearsal','Play with others and sharpen performance',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Record a demo take','Document your progress and listen back',GoalFrequency.weekly,GoalCategory.creative),
        _g('w3','Perform for an audience','One live or streamed performance each week',GoalFrequency.weekly,GoalCategory.creative),
        _g('w4','Study music theory concepts','Chords, scales, harmony, and rhythm',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Release one track or showcase','Create something public-ready',GoalFrequency.monthly,GoalCategory.creative),
        _g('m2','Submit to a music competition or festival','Get external feedback and exposure',GoalFrequency.monthly,GoalCategory.creative),
        _g('m3','Review your music portfolio','Update recordings, videos, and artist notes',GoalFrequency.monthly,GoalCategory.creative),
      ],
    ),

    CareerPath(
      id: 'playwright', title: 'Playwright / Scriptwriter', subtitle: 'Arts · Creative Writing',
      category: 'Arts & Creative', icon: Icons.create, color: LCColors.purple,
      minGPA: 3.0, trainingYears: 'Ongoing',
      description: 'Tell powerful stories for stage, screen, and media. Playwriting combines strong storytelling, character development, and cultural insight.',
      requiredSubjects: ['English', 'Literature', 'Drama', 'History'],
      recommendedClubs: ['Drama club', 'Creative writing club', 'Debate', 'Literature club'],
      targetUniversities: ['University of Zimbabwe Drama', 'UCT Drama', 'Africa Film Academy', 'New York Film Academy'],
      scholarshipTypes: ['Arts scholarship', 'Playwriting fellowship', 'Theatre bursary'],
      dailyGoals: [
        _g('d1','Write one scene or 300 words','Build your script one page at a time',GoalFrequency.daily,GoalCategory.creative),
        _g('d2','Read a play or script excerpt','Study structure, dialogue, and pacing',GoalFrequency.daily,GoalCategory.academic),
        _g('d3','Work on character voice','Spend time deepening one character',GoalFrequency.daily,GoalCategory.creative),
        _g('d4','Practice dramatic writing techniques','Focus on conflict, stakes, and dialogue',GoalFrequency.daily,GoalCategory.creative),
      ],
      weeklyGoals: [
        _g('w1','Attend or stage a reading','Perform your work for feedback',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w2','Join a writing workshop','Collaborate and improve with peers',GoalFrequency.weekly,GoalCategory.extracurricular),
        _g('w3','Write a short play outline','Plan a complete story arc',GoalFrequency.weekly,GoalCategory.creative),
        _g('w4','Research a cultural or historical theme','Ground your writing in real ideas',GoalFrequency.weekly,GoalCategory.academic),
      ],
      monthlyGoals: [
        _g('m1','Submit a script to a festival or showcase','Share your work with a wider audience',GoalFrequency.monthly,GoalCategory.creative),
        _g('m2','Edit and polish one longer scene','Take a draft closer to production quality',GoalFrequency.monthly,GoalCategory.creative),
        _g('m3','Build a writing portfolio','Collect your best scenes, plays, and synopses',GoalFrequency.monthly,GoalCategory.creative),
      ],
    ),

  ];

  static Map<String, List<CareerPath>> get byCategory {
    final map = <String, List<CareerPath>>{};
    for (final c in all) {
      map.putIfAbsent(c.category, () => []).add(c);
    }
    return map;
  }

  static Color categoryColor(String category) {
    switch (category) {
      case 'Medicine': return LCColors.red;
      case 'Technology': return LCColors.blue;
      case 'Engineering': return LCColors.blue;
      case 'Sports': return LCColors.primary;
      case 'Entrepreneurship': return LCColors.gold;
      case 'Politics & Leadership': return LCColors.purple;
      case 'Law': return LCColors.purple;
      case 'Arts & Creative': return LCColors.purple;
      case 'Finance': return LCColors.gold;
      case 'Science': return LCColors.blue;
      case 'Education': return LCColors.blue;
      case 'Architecture & Design': return LCColors.orange;
      case 'Media & Journalism': return LCColors.orange;
      default: return LCColors.primary;
    }
  }
}

extension CareerStatusExt on CareerStatus {
  String get label {
    switch (this) {
      case CareerStatus.strong: return 'Strong';
      case CareerStatus.onTrack: return 'On track';
      case CareerStatus.possible: return 'Possible';
      case CareerStatus.atRisk: return 'At risk';
    }
  }

  Color get color {
    switch (this) {
      case CareerStatus.strong: return LCColors.primary;
      case CareerStatus.onTrack: return LCColors.primary;
      case CareerStatus.possible: return LCColors.gold;
      case CareerStatus.atRisk: return LCColors.red;
    }
  }
}
