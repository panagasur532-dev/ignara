import 'package:flutter/material.dart';

enum PerformanceTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

class TierDefinition {
  final PerformanceTier tier;
  final String name;
  final String displayName;
  final double minPercentage;
  final double maxPercentage;
  final Color color;
  final String emoji;
  final String description;
  final String imagePath;

  const TierDefinition({
    required this.tier,
    required this.name,
    required this.displayName,
    required this.minPercentage,
    required this.maxPercentage,
    required this.color,
    required this.emoji,
    required this.description,
    required this.imagePath,
  });
}

class EducationTierSystem {
  /// Diamond: 90%+ - Outstanding Excellence
  /// Platinum: 80%+ - High Excellence
  /// Gold: 70%+ - Strong Performance
  /// Silver: 60%+ - Solid Performance
  /// Bronze: 0-59% - Developing Performance

  static const List<TierDefinition> tiers = [
    TierDefinition(
      tier: PerformanceTier.diamond,
      name: 'diamond',
      displayName: 'Diamond',
      minPercentage: 90.0,
      maxPercentage: 100.0,
      color: Color(0xFF00E5A0),
      emoji: '💎',
      description: 'Outstanding Excellence - Master of the subject',
      imagePath: 'tiers/diamond.png',
    ),
    TierDefinition(
      tier: PerformanceTier.platinum,
      name: 'platinum',
      displayName: 'Platinum',
      minPercentage: 80.0,
      maxPercentage: 89.99,
      color: Color(0xFFE0E0E0),
      emoji: '⭐',
      description: 'High Excellence - Exceptional performance',
      imagePath: 'tiers/platinum.png',
    ),
    TierDefinition(
      tier: PerformanceTier.gold,
      name: 'gold',
      displayName: 'Gold',
      minPercentage: 70.0,
      maxPercentage: 79.99,
      color: Color(0xFFFFB800),
      emoji: '🏆',
      description: 'Strong Performance - Excellent grasp',
      imagePath: 'tiers/gold.png',
    ),
    TierDefinition(
      tier: PerformanceTier.silver,
      name: 'silver',
      displayName: 'Silver',
      minPercentage: 60.0,
      maxPercentage: 69.99,
      color: Color(0xFFA0A8B8),
      emoji: '🎖️',
      description: 'Solid Performance - Good understanding',
      imagePath: 'tiers/silver.png',
    ),
    TierDefinition(
      tier: PerformanceTier.bronze,
      name: 'bronze',
      displayName: 'Bronze',
      minPercentage: 0.0,
      maxPercentage: 59.99,
      color: Color(0xFFCD7F32),
      emoji: '📚',
      description: 'Developing Performance - Keep improving',
      imagePath: 'tiers/Bronze.png',
    ),
  ];

  static TierDefinition getTierForScore(double score) {
    for (var tier in tiers) {
      if (score >= tier.minPercentage && score <= tier.maxPercentage) {
        return tier;
      }
    }
    return tiers.last;
  }

  static double calculateOverallEducationPerformance(List<double> scores) {
    if (scores.isEmpty) return 0.0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  static String getEducationTierStatus(double gpa) {
    final tier = getTierForScore(gpa);
    return '${tier.emoji} ${tier.displayName}';
  }
}

class SportsTierSystem {
  /// For sports, we calculate based on performance metrics
  /// Diamond: 90%+ - Elite Athlete
  /// Platinum: 80%+ - Professional Level
  /// Gold: 70%+ - Advanced Competitor
  /// Silver: 60%+ - Developing Athlete
  /// Bronze: 0-59% - Emerging Talent

  static const List<TierDefinition> tiers = [
    TierDefinition(
      tier: PerformanceTier.diamond,
      name: 'diamond',
      displayName: 'Elite',
      minPercentage: 90.0,
      maxPercentage: 100.0,
      color: Color(0xFF00E5A0),
      emoji: '🥇',
      description: 'Elite Athlete - World-class performance',
      imagePath: 'tiers/diamond.png',
    ),
    TierDefinition(
      tier: PerformanceTier.platinum,
      name: 'platinum',
      displayName: 'Pro',
      minPercentage: 80.0,
      maxPercentage: 89.99,
      color: Color(0xFFE0E0E0),
      emoji: '⚡',
      description: 'Professional Level - Champion caliber',
      imagePath: 'tiers/platinum.png',
    ),
    TierDefinition(
      tier: PerformanceTier.gold,
      name: 'gold',
      displayName: 'Advanced',
      minPercentage: 70.0,
      maxPercentage: 79.99,
      color: Color(0xFFFFB800),
      emoji: '🔥',
      description: 'Advanced Competitor - Rising star',
      imagePath: 'tiers/gold.png',
    ),
    TierDefinition(
      tier: PerformanceTier.silver,
      name: 'silver',
      displayName: 'Rising',
      minPercentage: 60.0,
      maxPercentage: 69.99,
      color: Color(0xFFA0A8B8),
      emoji: '💪',
      description: 'Developing Athlete - Good potential',
      imagePath: 'tiers/silver.png',
    ),
    TierDefinition(
      tier: PerformanceTier.bronze,
      name: 'bronze',
      displayName: 'Emerging',
      minPercentage: 0.0,
      maxPercentage: 59.99,
      color: Color(0xFFCD7F32),
      emoji: '🌱',
      description: 'Emerging Talent - Keep grinding',      imagePath: 'tiers/Bronze.png',    ),
  ];

  static TierDefinition getTierForScore(double score) {
    for (var tier in tiers) {
      if (score >= tier.minPercentage && score <= tier.maxPercentage) {
        return tier;
      }
    }
    return tiers.last;
  }

  /// Calculate overall sports performance from various metrics
  /// Based on: goals ratio, assists ratio, games played consistency, training hours, tournaments
  static double calculateOverallSportsPerformance({
    required int goals,
    required int assists,
    required int gamesPlayed,
    required int hoursTrainedThisTerm,
    required int tournamentsAttended,
    required double topSpeed,
  }) {
    // Normalize each metric to 0-100 scale
    final goalsScore = (goals / 50) * 100; // Assume 50 goals is excellent
    final assistsScore = (assists / 30) * 100; // Assume 30 assists is excellent
    final gamesScore = (gamesPlayed / 30) * 100; // Assume 30 games is excellent
    final trainingsScore = (hoursTrainedThisTerm / 200) * 100; // Assume 200 hours is excellent
    final tournamentScore = (tournamentsAttended / 15) * 100; // Assume 15 tournaments is excellent
    final speedScore = (topSpeed / 35) * 100; // Assume 35 km/h is excellent

    // Weight the scores
    final weighted = (
      goalsScore * 0.25 +
      assistsScore * 0.15 +
      gamesScore * 0.15 +
      trainingsScore * 0.2 +
      tournamentScore * 0.15 +
      speedScore * 0.1
    );

    // Cap at 100
    return weighted > 100 ? 100 : weighted < 0 ? 0 : weighted;
  }

  static String getSportsTierStatus(double performanceScore) {
    final tier = getTierForScore(performanceScore);
    return '${tier.emoji} ${tier.displayName}';
  }
}
