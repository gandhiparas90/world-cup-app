class Team {
  const Team({
    required this.id,
    required this.name,
    required this.code,
    required this.flagLabel,
    required this.group,
    required this.manager,
    required this.style,
    required this.formSummary,
    required this.teamNews,
    required this.attackRating,
    required this.defenseRating,
    required this.formPoints,
    required this.avgGoalsFor,
    required this.avgGoalsAgainst,
  });

  final String id;
  final String name;
  final String code;
  final String flagLabel;
  final String group;
  final String manager;
  final String style;
  final String formSummary;
  final String teamNews;
  final int attackRating;
  final int defenseRating;
  final int formPoints;
  final double avgGoalsFor;
  final double avgGoalsAgainst;
}
