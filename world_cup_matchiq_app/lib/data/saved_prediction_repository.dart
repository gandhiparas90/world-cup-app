import 'package:hive/hive.dart';

import '../models/saved_prediction.dart';

abstract class SavedPredictionRepository {
  Future<List<SavedPrediction>> load();

  Future<void> save(SavedPrediction prediction);

  Future<void> clear();
}

class InMemorySavedPredictionRepository implements SavedPredictionRepository {
  final List<SavedPrediction> _predictions = [];

  @override
  Future<List<SavedPrediction>> load() async {
    return List.unmodifiable(_sorted(_predictions));
  }

  @override
  Future<void> save(SavedPrediction prediction) async {
    _predictions.removeWhere((saved) => saved.storageKey == prediction.storageKey);
    _predictions.add(prediction);
  }

  @override
  Future<void> clear() async {
    _predictions.clear();
  }
}

class HiveSavedPredictionRepository implements SavedPredictionRepository {
  HiveSavedPredictionRepository({required Box<dynamic> box}) : _box = box;

  static const boxName = 'saved_predictions';

  final Box<dynamic> _box;

  @override
  Future<List<SavedPrediction>> load() async {
    final predictions = _box.values
        .whereType<Map<dynamic, dynamic>>()
        .map(SavedPrediction.fromStorageMap)
        .toList();
    return _sorted(predictions);
  }

  @override
  Future<void> save(SavedPrediction prediction) async {
    await _box.put(prediction.storageKey, prediction.toStorageMap());
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }
}

List<SavedPrediction> _sorted(List<SavedPrediction> predictions) {
  return [...predictions]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
