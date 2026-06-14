import '../models/world_cup_match.dart';

enum MatchTimingState { completed, live, awaitingResult, upcoming }

class MatchTiming {
  const MatchTiming({required this.state, required this.kickoffUtc});

  final MatchTimingState state;
  final DateTime? kickoffUtc;
}

DateTime? matchKickoffUtc(WorldCupMatch match) {
  final dateParts = match.dateLabel.split(' ');
  final timeParts = match.kickoffLabel.split(' ');
  if (dateParts.length != 3 || timeParts.length < 2) {
    return null;
  }

  final month = _monthNumbers[dateParts[1]];
  final day = int.tryParse(dateParts[2]);
  final hourMinute = timeParts[0].split(':');
  if (month == null || day == null || hourMinute.length != 2) {
    return null;
  }

  var hour = int.tryParse(hourMinute[0]);
  final minute = int.tryParse(hourMinute[1]);
  final period = timeParts[1];
  if (hour == null || minute == null) {
    return null;
  }

  if (period == 'PM' && hour != 12) {
    hour += 12;
  }
  if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  // The 2026 group-stage dates are during daylight saving time.
  // Fixture labels are Eastern Time, so convert ET (UTC-4) to UTC.
  return DateTime.utc(2026, month, day, hour + 4, minute);
}

MatchTiming matchTiming(WorldCupMatch match, {DateTime? nowUtc}) {
  final kickoffUtc = matchKickoffUtc(match);
  if (match.isCompleted) {
    return MatchTiming(
      state: MatchTimingState.completed,
      kickoffUtc: kickoffUtc,
    );
  }

  final now = (nowUtc ?? DateTime.now().toUtc()).toUtc();
  if (kickoffUtc == null || now.isBefore(kickoffUtc)) {
    return MatchTiming(
      state: MatchTimingState.upcoming,
      kickoffUtc: kickoffUtc,
    );
  }

  final liveWindowEnd = kickoffUtc.add(const Duration(hours: 2));
  if (now.isBefore(liveWindowEnd)) {
    return MatchTiming(state: MatchTimingState.live, kickoffUtc: kickoffUtc);
  }

  return MatchTiming(
    state: MatchTimingState.awaitingResult,
    kickoffUtc: kickoffUtc,
  );
}

String timingLabel(WorldCupMatch match, {DateTime? nowUtc}) {
  final timing = matchTiming(match, nowUtc: nowUtc);
  return switch (timing.state) {
    MatchTimingState.completed => 'Final',
    MatchTimingState.live => 'Live window',
    MatchTimingState.awaitingResult => 'Result pending',
    MatchTimingState.upcoming => _upcomingLabel(timing.kickoffUtc, nowUtc),
  };
}

List<WorldCupMatch> recentResultMatches(
  Iterable<WorldCupMatch> matches, {
  DateTime? nowUtc,
  int limit = 3,
}) {
  final copy = matches.where((match) {
    final state = matchTiming(match, nowUtc: nowUtc).state;
    return state == MatchTimingState.completed ||
        state == MatchTimingState.live ||
        state == MatchTimingState.awaitingResult;
  }).toList()..sort(_kickoffDesc);
  return copy.take(limit).toList();
}

List<WorldCupMatch> nextUpcomingMatches(
  Iterable<WorldCupMatch> matches, {
  DateTime? nowUtc,
  int limit = 3,
}) {
  final copy =
      matches
          .where(
            (match) =>
                matchTiming(match, nowUtc: nowUtc).state ==
                MatchTimingState.upcoming,
          )
          .toList()
        ..sort(_kickoffAsc);
  return copy.take(limit).toList();
}

int _kickoffAsc(WorldCupMatch a, WorldCupMatch b) {
  return _sortTime(a).compareTo(_sortTime(b));
}

int _kickoffDesc(WorldCupMatch a, WorldCupMatch b) {
  return _sortTime(b).compareTo(_sortTime(a));
}

DateTime _sortTime(WorldCupMatch match) {
  return matchKickoffUtc(match) ?? DateTime.utc(9999);
}

String _upcomingLabel(DateTime? kickoffUtc, DateTime? nowUtc) {
  if (kickoffUtc == null) {
    return 'Scheduled';
  }

  final now = (nowUtc ?? DateTime.now().toUtc()).toUtc();
  final localNow = now.add(const Duration(hours: -5));
  final localKickoff = kickoffUtc.add(const Duration(hours: -5));
  final dayGap = DateTime(
    localKickoff.year,
    localKickoff.month,
    localKickoff.day,
  ).difference(DateTime(localNow.year, localNow.month, localNow.day)).inDays;

  if (dayGap == 0) {
    return 'Today';
  }
  if (dayGap == 1) {
    return 'Tomorrow';
  }
  return '${_month(localKickoff.month)} ${localKickoff.day}';
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

const _monthNumbers = <String, int>{
  'Jan': 1,
  'Feb': 2,
  'Mar': 3,
  'Apr': 4,
  'May': 5,
  'Jun': 6,
  'Jul': 7,
  'Aug': 8,
  'Sep': 9,
  'Oct': 10,
  'Nov': 11,
  'Dec': 12,
};
