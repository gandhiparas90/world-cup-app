import '../models/group_info.dart';
import '../models/news_item.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/team_stats.dart';
import '../models/watch_option.dart';
import '../models/world_cup_match.dart';
import 'seed_data.dart';

class MatchRepository {
  const MatchRepository.seeded();

  List<Team> get teams => SeedData.teams;

  List<GroupInfo> get groups => SeedData.groups;

  List<WorldCupMatch> get matches => SeedData.matches;

  List<WorldCupMatch> get upcomingMatches => SeedData.upcomingMatches();

  List<WatchOption> get watchOptions => SeedData.watchOptions;

  Team teamById(String id) {
    return SeedData.teamById(id);
  }

  GroupInfo groupById(String id) {
    return SeedData.groupById(id);
  }

  TeamStats teamStatsById(String teamId) {
    return SeedData.teamStatsById(teamId);
  }

  WorldCupMatch matchById(String id) {
    return SeedData.matchById(id);
  }

  List<Player> playersForTeam(String teamId) {
    return SeedData.playersForTeam(teamId);
  }

  List<WorldCupMatch> matchesForTeam(String teamId) {
    return SeedData.matchesForTeam(teamId);
  }

  List<Player> playersForMatch(String matchId) {
    return SeedData.playersForMatch(matchId);
  }

  List<WatchOption> watchOptionsForMatch(String matchId) {
    return SeedData.watchOptionsForMatch(matchId);
  }

  List<NewsItem> newsForTeam(String teamId) {
    return SeedData.newsForTeam(teamId);
  }
}
