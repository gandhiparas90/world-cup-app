class PredictionResult {
  const PredictionResult({
    required this.scoreline,
    required this.confidence,
    required this.homeExpectedGoals,
    required this.awayExpectedGoals,
    required this.homeWinPercent,
    required this.drawPercent,
    required this.awayWinPercent,
    required this.factors,
    required this.scorers,
    required this.disclaimer,
  });

  final String scoreline;
  final String confidence;
  final double homeExpectedGoals;
  final double awayExpectedGoals;
  final int homeWinPercent;
  final int drawPercent;
  final int awayWinPercent;
  final List<PredictionFactor> factors;
  final List<ScorerPrediction> scorers;
  final String disclaimer;
}

class PredictionFactor {
  const PredictionFactor({
    required this.label,
    required this.value,
    required this.explanation,
  });

  final String label;
  final String value;
  final String explanation;
}

class ScorerPrediction {
  const ScorerPrediction({
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.position,
    required this.percent,
    required this.explanation,
  });

  final String playerId;
  final String playerName;
  final String teamId;
  final String position;
  final int percent;
  final String explanation;
}
