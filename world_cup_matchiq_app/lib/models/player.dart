class Player {
  const Player({
    required this.id,
    required this.teamId,
    required this.name,
    required this.position,
    required this.recentGoals,
    required this.recentAssists,
    required this.likelyStarter,
  });

  final String id;
  final String teamId;
  final String name;
  final String position;
  final int recentGoals;
  final int recentAssists;
  final bool likelyStarter;

  int get goalInvolvement => recentGoals + recentAssists;
}
