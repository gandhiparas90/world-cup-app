import 'package:hive/hive.dart';

import '../models/fixture_result.dart';

abstract class FixtureResultRepository {
  Future<List<FixtureResult>> load();

  Future<void> save(FixtureResult result);

  Future<void> delete(String matchId);

  Future<void> clear();
}

class InMemoryFixtureResultRepository implements FixtureResultRepository {
  final List<FixtureResult> _results = [];

  @override
  Future<List<FixtureResult>> load() async {
    return List.unmodifiable(_sorted(_results));
  }

  @override
  Future<void> save(FixtureResult result) async {
    _results.removeWhere((saved) => saved.storageKey == result.storageKey);
    _results.add(result);
  }

  @override
  Future<void> delete(String matchId) async {
    _results.removeWhere((saved) => saved.matchId == matchId);
  }

  @override
  Future<void> clear() async {
    _results.clear();
  }
}

class HiveFixtureResultRepository implements FixtureResultRepository {
  HiveFixtureResultRepository({required this.box});

  static const boxName = 'fixture_results';

  final Box<dynamic> box;

  @override
  Future<List<FixtureResult>> load() async {
    final results = box.values
        .whereType<Map<dynamic, dynamic>>()
        .map(FixtureResult.fromStorageMap)
        .toList();
    return _sorted(results);
  }

  @override
  Future<void> save(FixtureResult result) async {
    await box.put(result.storageKey, result.toStorageMap());
  }

  @override
  Future<void> delete(String matchId) async {
    await box.delete(matchId);
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}

List<FixtureResult> _sorted(List<FixtureResult> results) {
  return [...results]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
}
