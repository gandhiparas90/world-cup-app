import '../models/world_cup_match.dart';

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
  final mapped = _localKickoffs[timezone]?[match.kickoffLabel];
  return mapped ?? match.kickoffLabel;
}

String broadcastSummary(String countryCode) {
  return switch (countryCode) {
    'US' => 'FOX/FS1 - Telemundo/Peacock',
    _ => 'Broadcast metadata unavailable',
  };
}

String viewingLine(WorldCupMatch match, String countryCode, String timezone) {
  return '${localKickoffLabel(match, timezone)} - ${broadcastSummary(countryCode)}';
}

const _localKickoffs = <String, Map<String, String>>{
  'America/New_York': {
    'Sat 3:00 PM ET': 'Sat 3:00 PM ET',
    'Sat 6:00 PM ET': 'Sat 6:00 PM ET',
    'Sat 9:00 PM ET': 'Sat 9:00 PM ET',
    'Sun 12:00 AM ET': 'Sun 12:00 AM ET',
  },
  'America/Chicago': {
    'Sat 3:00 PM ET': 'Sat 2:00 PM CT',
    'Sat 6:00 PM ET': 'Sat 5:00 PM CT',
    'Sat 9:00 PM ET': 'Sat 8:00 PM CT',
    'Sun 12:00 AM ET': 'Sat 11:00 PM CT',
  },
  'America/Denver': {
    'Sat 3:00 PM ET': 'Sat 1:00 PM MT',
    'Sat 6:00 PM ET': 'Sat 4:00 PM MT',
    'Sat 9:00 PM ET': 'Sat 7:00 PM MT',
    'Sun 12:00 AM ET': 'Sat 10:00 PM MT',
  },
  'America/Los_Angeles': {
    'Sat 3:00 PM ET': 'Sat 12:00 PM PT',
    'Sat 6:00 PM ET': 'Sat 3:00 PM PT',
    'Sat 9:00 PM ET': 'Sat 6:00 PM PT',
    'Sun 12:00 AM ET': 'Sat 9:00 PM PT',
  },
};
