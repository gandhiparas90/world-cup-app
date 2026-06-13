class TeamStats {
  const TeamStats({
    required this.teamId,
    required this.attackRating,
    required this.defenseRating,
    required this.formPoints,
    required this.avgGoalsFor,
    required this.avgGoalsAgainst,
    required this.sourceLabel,
    required this.updatedLabel,
  });

  final String teamId;
  final int attackRating;
  final int defenseRating;
  final int formPoints;
  final double avgGoalsFor;
  final double avgGoalsAgainst;
  final String sourceLabel;
  final String updatedLabel;
}
