import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/world_cup_matchiq_app.dart';
import 'data/ai_preview_repository.dart';
import 'data/fixture_result_repository.dart';
import 'data/saved_prediction_repository.dart';
import 'data/user_profile_repository.dart';
import 'services/ai_match_preview_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  const aiModel = String.fromEnvironment(
    'AI_MODEL',
    defaultValue: 'gemini-3.5-flash',
  );
  const geminiProxyUrl = String.fromEnvironment('GEMINI_PROXY_URL');
  final savedPredictionsBox = await Hive.openBox<dynamic>(
    HiveSavedPredictionRepository.boxName,
  );
  final userProfileBox = await Hive.openBox<dynamic>(
    HiveUserProfileRepository.boxName,
  );
  final aiPreviewBox = await Hive.openBox<dynamic>(
    HiveAiPreviewRepository.boxName,
  );
  final fixtureResultsBox = await Hive.openBox<dynamic>(
    HiveFixtureResultRepository.boxName,
  );

  runApp(
    WorldCupMatchIqEntryPoint(
      savedPredictionRepository: HiveSavedPredictionRepository(
        box: savedPredictionsBox,
      ),
      userProfileRepository: HiveUserProfileRepository(box: userProfileBox),
      aiPreviewRepository: HiveAiPreviewRepository(box: aiPreviewBox),
      fixtureResultRepository: HiveFixtureResultRepository(
        box: fixtureResultsBox,
      ),
      aiMatchPreviewService: GeminiAiMatchPreviewService(
        apiKey: geminiApiKey,
        model: aiModel,
        proxyUrl: geminiProxyUrl,
      ),
    ),
  );
}
