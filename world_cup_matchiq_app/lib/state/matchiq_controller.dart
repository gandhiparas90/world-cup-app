import 'package:flutter/foundation.dart';

import '../data/match_repository.dart';
import '../data/saved_prediction_repository.dart';
import '../models/player.dart';
import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';

class MatchIqController extends ChangeNotifier {
  MatchIqController({
    required MatchRepository matchRepository,
    required SavedPredictionRepository savedPredictionRepository,
  })  : _matchRepository = matchRepository,
        _savedPredictionRepository = savedPredictionRepository;

  final MatchRepository _matchRepository;
  final SavedPredictionRepository _savedPredictionRepository;

  var _isLoading = true;
  var _selectedIndex = 0;
  List<SavedPrediction> _savedPredictions = [];

  bool get isLoading => _isLoading;

  int get selectedIndex => _selectedIndex;

  List<WorldCupMatch> get matches => _matchRepository.matches;

  List<SavedPrediction> get savedPredictions => List.unmodifiable(_savedPredictions);

  Team teamById(String id) {
    return _matchRepository.teamById(id);
  }

  List<Player> playersForMatch(String matchId) {
    return _matchRepository.playersForMatch(matchId);
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _savedPredictions = await _savedPredictionRepository.load();
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
    await _savedPredictionRepository.save(prediction);
    _savedPredictions = await _savedPredictionRepository.load();
    _selectedIndex = 1;
    notifyListeners();
  }

  Future<void> clearSavedPredictions() async {
    await _savedPredictionRepository.clear();
    _savedPredictions = [];
    notifyListeners();
  }
}
