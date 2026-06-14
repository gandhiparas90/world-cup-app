class FixtureResult {
  const FixtureResult({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
    required this.sourceLabel,
    required this.updatedAt,
  });

  final String matchId;
  final int homeScore;
  final int awayScore;
  final String sourceLabel;
  final DateTime updatedAt;

  String get storageKey => matchId;

  String get updatedLabel {
    final month = _monthLabels[updatedAt.month] ?? 'Month';
    final hour24 = updatedAt.hour;
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    final minute = updatedAt.minute.toString().padLeft(2, '0');
    final suffix = hour24 >= 12 ? 'PM' : 'AM';
    return 'Updated $month ${updatedAt.day}, ${updatedAt.year} $hour12:$minute $suffix';
  }

  Map<String, Object?> toStorageMap() {
    return {
      'matchId': matchId,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'sourceLabel': sourceLabel,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FixtureResult.fromStorageMap(Map<dynamic, dynamic> map) {
    return FixtureResult(
      matchId: map['matchId'] as String,
      homeScore: map['homeScore'] as int,
      awayScore: map['awayScore'] as int,
      sourceLabel: map['sourceLabel'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}

const _monthLabels = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};
