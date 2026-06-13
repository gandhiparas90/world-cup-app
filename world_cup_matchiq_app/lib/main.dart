import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/world_cup_matchiq_app.dart';
import 'data/saved_prediction_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final savedPredictionsBox = await Hive.openBox<dynamic>(
    HiveSavedPredictionRepository.boxName,
  );

  runApp(
    WorldCupMatchIqEntryPoint(
      savedPredictionRepository: HiveSavedPredictionRepository(
        box: savedPredictionsBox,
      ),
    ),
  );
}
