class NewsItem {
  const NewsItem({
    required this.id,
    this.teamId,
    this.matchId,
    required this.headline,
    required this.summary,
    required this.sourceLabel,
    required this.sourceUrl,
    required this.updatedLabel,
  });

  final String id;
  final String? teamId;
  final String? matchId;
  final String headline;
  final String summary;
  final String sourceLabel;
  final String sourceUrl;
  final String updatedLabel;
}
