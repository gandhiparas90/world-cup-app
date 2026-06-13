class AiMatchPreview {
  const AiMatchPreview({
    required this.matchId,
    required this.headline,
    required this.tacticalSummary,
    required this.keyPlayers,
    required this.predictionRationale,
    required this.watchNote,
    required this.disclaimer,
    required this.source,
    required this.createdAt,
  });

  final String matchId;
  final String headline;
  final String tacticalSummary;
  final List<String> keyPlayers;
  final String predictionRationale;
  final String watchNote;
  final String disclaimer;
  final String source;
  final DateTime createdAt;

  String get storageKey => matchId;

  Map<String, Object?> toStorageMap() {
    return {
      'matchId': matchId,
      'headline': headline,
      'tacticalSummary': tacticalSummary,
      'keyPlayers': keyPlayers,
      'predictionRationale': predictionRationale,
      'watchNote': watchNote,
      'disclaimer': disclaimer,
      'source': source,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AiMatchPreview.fromStorageMap(Map<dynamic, dynamic> map) {
    return AiMatchPreview(
      matchId: map['matchId'] as String,
      headline: map['headline'] as String,
      tacticalSummary: map['tacticalSummary'] as String,
      keyPlayers: (map['keyPlayers'] as List<dynamic>).cast<String>(),
      predictionRationale: map['predictionRationale'] as String,
      watchNote: map['watchNote'] as String,
      disclaimer: map['disclaimer'] as String,
      source: map['source'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
