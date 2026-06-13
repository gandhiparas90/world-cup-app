class WatchOption {
  const WatchOption({
    required this.matchId,
    required this.countryCode,
    required this.channel,
    required this.language,
    required this.streamLabel,
  });

  final String matchId;
  final String countryCode;
  final String channel;
  final String language;
  final String streamLabel;
}
