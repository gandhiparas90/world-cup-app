import 'package:hive/hive.dart';

import '../models/ai_match_preview.dart';

abstract class AiPreviewRepository {
  Future<List<AiMatchPreview>> load();

  Future<void> save(AiMatchPreview preview);

  Future<void> clear();
}

class InMemoryAiPreviewRepository implements AiPreviewRepository {
  final List<AiMatchPreview> _previews = [];

  @override
  Future<List<AiMatchPreview>> load() async {
    return List.unmodifiable(_sorted(_previews));
  }

  @override
  Future<void> save(AiMatchPreview preview) async {
    _previews.removeWhere((saved) => saved.storageKey == preview.storageKey);
    _previews.add(preview);
  }

  @override
  Future<void> clear() async {
    _previews.clear();
  }
}

class HiveAiPreviewRepository implements AiPreviewRepository {
  HiveAiPreviewRepository({required this.box});

  static const boxName = 'ai_match_previews';

  final Box<dynamic> box;

  @override
  Future<List<AiMatchPreview>> load() async {
    final previews = box.values
        .whereType<Map<dynamic, dynamic>>()
        .map(AiMatchPreview.fromStorageMap)
        .toList();
    return _sorted(previews);
  }

  @override
  Future<void> save(AiMatchPreview preview) async {
    await box.put(preview.storageKey, preview.toStorageMap());
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}

List<AiMatchPreview> _sorted(List<AiMatchPreview> previews) {
  return [...previews]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
