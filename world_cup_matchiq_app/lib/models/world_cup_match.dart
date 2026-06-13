class WorldCupMatch {
  const WorldCupMatch({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.stage,
    required this.kickoffLabel,
    required this.venue,
    required this.storyline,
  });

  final String id;
  final String homeTeamId;
  final String awayTeamId;
  final String stage;
  final String kickoffLabel;
  final String venue;
  final String storyline;
}
