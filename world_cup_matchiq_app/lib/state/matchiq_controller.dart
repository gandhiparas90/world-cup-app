import 'package:flutter/foundation.dart';

import '../data/ai_preview_repository.dart';
import '../data/fixture_result_repository.dart';
import '../data/match_repository.dart';
import '../data/saved_prediction_repository.dart';
import '../data/user_profile_repository.dart';
import '../models/ai_match_preview.dart';
import '../models/fixture_result.dart';
import '../models/group_info.dart';
import '../models/player.dart';
import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/watch_option.dart';
import '../models/user_profile.dart';
import '../models/world_cup_match.dart';
import '../services/ai_match_preview_service.dart';

class MatchIqController extends ChangeNotifier {
  MatchIqController({
    required this.matchRepository,
    required this.savedPredictionRepository,
    required this.userProfileRepository,
    required this.aiPreviewRepository,
    required this.fixtureResultRepository,
    required this.aiMatchPreviewService,
  });

  final MatchRepository matchRepository;
  final SavedPredictionRepository savedPredictionRepository;
  final UserProfileRepository userProfileRepository;
  final AiPreviewRepository aiPreviewRepository;
  final FixtureResultRepository fixtureResultRepository;
  final AiMatchPreviewService aiMatchPreviewService;

  var _isLoading = true;
  var _selectedIndex = 0;
  List<SavedPrediction> _savedPredictions = [];
  List<AiMatchPreview> _aiPreviews = [];
  List<FixtureResult> _fixtureResults = [];
  final Set<String> _generatingAiPreviewMatchIds = {};
  UserProfile? _profile;

  bool get isLoading => _isLoading;

  int get selectedIndex => _selectedIndex;

  List<Team> get teams => matchRepository.teams;

  List<GroupInfo> get groups => matchRepository.groups;

  List<WorldCupMatch> get matches =>
      matchRepository.matches.map(_matchWithResultOverride).toList();

  List<WorldCupMatch> get upcomingMatches =>
      matches.where((match) => match.isScheduled).take(12).toList();

  List<SavedPrediction> get savedPredictions =>
      List.unmodifiable(_savedPredictions);

  List<AiMatchPreview> get aiPreviews => List.unmodifiable(_aiPreviews);

  List<FixtureResult> get fixtureResults => List.unmodifiable(_fixtureResults);

  UserProfile? get profile => _profile;

  bool get hasProfile => _profile != null;

  Team teamById(String id) {
    return matchRepository.teamById(id);
  }

  List<Player> playersForMatch(String matchId) {
    return matchRepository.playersForMatch(matchId);
  }

  List<WorldCupMatch> matchesForTeam(String teamId) {
    return matchRepository
        .matchesForTeam(teamId)
        .map(_matchWithResultOverride)
        .toList();
  }

  List<WatchOption> watchOptionsForMatch(String matchId) {
    return matchRepository.watchOptionsForMatch(matchId);
  }

  AiMatchPreview? aiPreviewForMatch(String matchId) {
    for (final preview in _aiPreviews) {
      if (preview.matchId == matchId) {
        return preview;
      }
    }
    return null;
  }

  bool isGeneratingAiPreview(String matchId) {
    return _generatingAiPreviewMatchIds.contains(matchId);
  }

  WorldCupMatch matchById(String id) {
    return _matchWithResultOverride(matchRepository.matchById(id));
  }

  FixtureResult? fixtureResultForMatch(String matchId) {
    for (final result in _fixtureResults) {
      if (result.matchId == matchId) {
        return result;
      }
    }
    return null;
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _savedPredictions = await savedPredictionRepository.load();
    _aiPreviews = await aiPreviewRepository.load();
    _fixtureResults = await fixtureResultRepository.load();
    _profile = await userProfileRepository.load();
    _isLoading = false;
    notifyListeners();
  }

  void selectTab(int index) {
    if (_selectedIndex == index) {
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> savePrediction(SavedPrediction prediction) async {
    await savedPredictionRepository.save(prediction);
    _savedPredictions = await savedPredictionRepository.load();
    _selectedIndex = 0;
    notifyListeners();
  }

  Future<void> clearSavedPredictions() async {
    await savedPredictionRepository.clear();
    _savedPredictions = [];
    notifyListeners();
  }

  Future<void> saveFixtureResult(FixtureResult result) async {
    await fixtureResultRepository.save(result);
    _fixtureResults = await fixtureResultRepository.load();
    notifyListeners();
  }

  Future<void> clearFixtureResult(String matchId) async {
    await fixtureResultRepository.delete(matchId);
    _fixtureResults = await fixtureResultRepository.load();
    notifyListeners();
  }

  Future<void> generateAiPreview(AiPreviewRequest request) async {
    if (_generatingAiPreviewMatchIds.contains(request.match.id)) {
      return;
    }

    _generatingAiPreviewMatchIds.add(request.match.id);
    notifyListeners();

    try {
      final preview = await aiMatchPreviewService.generate(request);
      await aiPreviewRepository.save(preview);
      _aiPreviews = await aiPreviewRepository.load();
    } finally {
      _generatingAiPreviewMatchIds.remove(request.match.id);
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await userProfileRepository.save(profile);
    _profile = profile;
    notifyListeners();
  }

  Future<void> resetProfile() async {
    await userProfileRepository.clear();
    _profile = null;
    notifyListeners();
  }

  WorldCupMatch _matchWithResultOverride(WorldCupMatch match) {
    final result = fixtureResultForMatch(match.id);
    if (result == null) {
      return match;
    }
    return match.withFinalScore(
      homeScore: result.homeScore,
      awayScore: result.awayScore,
      sourceLabel: result.sourceLabel,
      dataUpdatedLabel: result.updatedLabel,
    );
  }
}
