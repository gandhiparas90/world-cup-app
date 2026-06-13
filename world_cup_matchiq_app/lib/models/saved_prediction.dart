class SavedPrediction {
  const SavedPrediction({
    required this.matchId,
    required this.matchLabel,
    required this.scoreline,
    required this.confidence,
    required this.createdAt,
  });

  final String matchId;
  final String matchLabel;
  final String scoreline;
  final String confidence;
  final DateTime createdAt;
}
