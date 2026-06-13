class Player {
  const Player({
    required this.id,
    required this.teamId,
    required this.name,
    required this.position,
    required this.news,
    required this.goalThreatRating,
    required this.recentGoals,
    required this.recentAssists,
    required this.likelyStarter,
    required this.availabilityFactor,
  });

  final String id;
  final String teamId;
  final String name;
  final String position;
  final String news;
  final int goalThreatRating;
  final int recentGoals;
  final int recentAssists;
  final bool likelyStarter;
  final double availabilityFactor;

  int get goalInvolvement => recentGoals + recentAssists;
}
