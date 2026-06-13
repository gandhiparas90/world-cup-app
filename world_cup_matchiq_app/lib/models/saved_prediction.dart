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

  String get storageKey => '$matchId-${createdAt.microsecondsSinceEpoch}';

  Map<String, Object?> toStorageMap() {
    return {
      'matchId': matchId,
      'matchLabel': matchLabel,
      'scoreline': scoreline,
      'confidence': confidence,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedPrediction.fromStorageMap(Map<dynamic, dynamic> map) {
    return SavedPrediction(
      matchId: map['matchId'] as String,
      matchLabel: map['matchLabel'] as String,
      scoreline: map['scoreline'] as String,
      confidence: map['confidence'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
