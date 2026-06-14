import '../models/world_cup_match.dart';
import 'match_timing.dart';

class ProfileChoice {
  const ProfileChoice({required this.value, required this.label});

  final String value;
  final String label;
}

const countryChoices = <ProfileChoice>[
  ProfileChoice(value: 'US', label: 'United States'),
];

const timezoneChoices = <ProfileChoice>[
  ProfileChoice(value: 'America/New_York', label: 'Eastern Time'),
  ProfileChoice(value: 'America/Chicago', label: 'Central Time'),
  ProfileChoice(value: 'America/Denver', label: 'Mountain Time'),
  ProfileChoice(value: 'America/Los_Angeles', label: 'Pacific Time'),
];

String countryLabel(String countryCode) {
  return countryChoices
      .firstWhere(
        (choice) => choice.value == countryCode,
        orElse: () => countryChoices.first,
      )
      .label;
}

String timezoneLabel(String timezone) {
  return timezoneChoices
      .firstWhere(
        (choice) => choice.value == timezone,
        orElse: () => timezoneChoices[1],
      )
      .label;
}

String localKickoffLabel(WorldCupMatch match, String timezone) {
  final kickoffUtc = matchKickoffUtc(match);
  final targetOffset = _timezoneOffsets[timezone];
  final suffix = _timezoneSuffixes[timezone];
  if (kickoffUtc == null || targetOffset == null || suffix == null) {
    return '${match.dateLabel} ${match.kickoffLabel}';
  }

  final local = kickoffUtc.add(Duration(hours: targetOffset));
  return '${_weekday(local)} ${_month(local.month)} ${local.day} ${_timeLabel(local)} $suffix';
}

String broadcastSummary(WorldCupMatch match, String countryCode) {
  return switch (countryCode) {
    'US' => '${match.broadcastChannel} - Telemundo/Peacock',
    _ => 'Broadcast metadata unavailable',
  };
}

String viewingLine(WorldCupMatch match, String countryCode, String timezone) {
  return '${localKickoffLabel(match, timezone)} - ${broadcastSummary(match, countryCode)}';
}

String _timeLabel(DateTime dateTime) {
  final hour24 = dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour24 >= 12 ? 'PM' : 'AM';
  final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
  return '$hour12:$minute $period';
}

String _weekday(DateTime dateTime) {
  return const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ][dateTime.weekday - 1];
}

String _month(int month) {
  return const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}

const _timezoneOffsets = <String, int>{
  'America/New_York': -4,
  'America/Chicago': -5,
  'America/Denver': -6,
  'America/Los_Angeles': -7,
};

const _timezoneSuffixes = <String, String>{
  'America/New_York': 'ET',
  'America/Chicago': 'CT',
  'America/Denver': 'MT',
  'America/Los_Angeles': 'PT',
};
