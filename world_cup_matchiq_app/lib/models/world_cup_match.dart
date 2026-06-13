class WorldCupMatch {
  const WorldCupMatch({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.stage,
    required this.dateLabel,
    required this.kickoffLabel,
    required this.venue,
    required this.broadcastChannel,
    this.homeScore,
    this.awayScore,
    this.isCompleted = false,
    required this.storyline,
    required this.sourceLabel,
    required this.sourceUrl,
    required this.dataUpdatedLabel,
  });

  final String id;
  final String homeTeamId;
  final String awayTeamId;
  final String stage;
  final String dateLabel;
  final String kickoffLabel;
  final String venue;
  final String broadcastChannel;
  final int? homeScore;
  final int? awayScore;
  final bool isCompleted;
  final String storyline;
  final String sourceLabel;
  final String sourceUrl;
  final String dataUpdatedLabel;

  bool get isScheduled => !isCompleted;
}
