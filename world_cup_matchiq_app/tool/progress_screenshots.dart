import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_cup_matchiq/app/theme.dart';
import 'package:world_cup_matchiq/app/world_cup_matchiq_app.dart';
import 'package:world_cup_matchiq/data/user_profile_repository.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';
import 'package:world_cup_matchiq/models/saved_prediction.dart';
import 'package:world_cup_matchiq/models/user_profile.dart';
import 'package:world_cup_matchiq/screens/match_detail_screen.dart';
import 'package:world_cup_matchiq/screens/profile_screen.dart';
import 'package:world_cup_matchiq/widgets/prediction_summary.dart';

const screenshotStage = String.fromEnvironment(
  'SCREENSHOT_STAGE',
  defaultValue: 'stage2',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await _loadScreenshotFonts();
  });

  setUp(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.textScaleFactorTestValue = 1.0;
  });

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.clearTextScaleFactorTestValue();
  });

  testWidgets('captures $screenshotStage setup home', (tester) async {
    await _setPhoneViewport(tester);
    await tester.pumpWidget(
      WorldCupMatchIqEntryPoint(
        theme: MatchIqTheme.light(useGoogleFonts: false),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WorldCupMatchIqEntryPoint),
      matchesGoldenFile(
        '../../docs/screenshots/$screenshotStage/01_home_setup.png',
      ),
    );
  });

  testWidgets('captures $screenshotStage personalized home', (tester) async {
    await _setPhoneViewport(tester);
    final profileRepository = InMemoryUserProfileRepository();
    await profileRepository.save(_sampleProfile());

    await tester.pumpWidget(
      WorldCupMatchIqEntryPoint(
        userProfileRepository: profileRepository,
        theme: MatchIqTheme.light(useGoogleFonts: false),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(WorldCupMatchIqEntryPoint),
      matchesGoldenFile(
        '../../docs/screenshots/$screenshotStage/02_home_personalized.png',
      ),
    );
  });

  testWidgets('captures $screenshotStage match detail', (tester) async {
    await _setPhoneViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MatchIqTheme.light(useGoogleFonts: false),
        home: MatchDetailScreen(
          match: SeedData.matchById('bra-mar'),
          home: SeedData.teamById('bra'),
          away: SeedData.teamById('mar'),
          players: SeedData.playersForMatch('bra-mar'),
          profile: _sampleProfile(),
          onSavePrediction: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../docs/screenshots/$screenshotStage/03_match_detail.png',
      ),
    );
  });

  testWidgets('captures $screenshotStage profile with saved prediction', (
    tester,
  ) async {
    await _setPhoneViewport(tester);
    final match = SeedData.matchById('bra-mar');
    final home = SeedData.teamById(match.homeTeamId);
    final away = SeedData.teamById(match.awayTeamId);
    final prediction = estimatePrototypePrediction(home, away);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MatchIqTheme.light(useGoogleFonts: false),
        home: Scaffold(
          appBar: AppBar(title: const Text('World Cup MatchIQ')),
          body: ProfileScreen(
            profile: _sampleProfile(),
            teams: SeedData.teams,
            savedPredictions: [
              SavedPrediction(
                matchId: match.id,
                matchLabel: '${home.name} vs ${away.name}',
                scoreline: prediction.scoreline,
                confidence: prediction.confidence,
                createdAt: DateTime(2026, 6, 13, 14),
              ),
            ],
            onSaveProfile: (_) async {},
            onResetProfile: () async {},
            onClearSavedPredictions: () async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../docs/screenshots/$screenshotStage/04_profile_saved.png',
      ),
    );
  });
}

UserProfile _sampleProfile() {
  return UserProfile(
    displayName: 'World Cup fan',
    countryCode: 'US',
    timezone: 'America/Chicago',
    favoriteTeamId: 'por',
    createdAt: DateTime(2026, 6, 13, 10),
    updatedAt: DateTime(2026, 6, 13, 10),
  );
}

Future<void> _loadScreenshotFonts() async {
  const materialFontPath =
      '/Users/parasgandhi/Project/temp/flutter/bin/cache/artifacts/material_fonts';

  final robotoLoader = FontLoader('Roboto')
    ..addFont(_fontData('$materialFontPath/Roboto-Regular.ttf'))
    ..addFont(_fontData('$materialFontPath/Roboto-Medium.ttf'))
    ..addFont(_fontData('$materialFontPath/Roboto-Bold.ttf'))
    ..addFont(_fontData('$materialFontPath/Roboto-Black.ttf'));
  await robotoLoader.load();

  final iconsLoader = FontLoader('MaterialIcons')
    ..addFont(_fontData('$materialFontPath/MaterialIcons-Regular.otf'));
  await iconsLoader.load();

  const lucideFontPath =
      '/Users/parasgandhi/.pub-cache/hosted/pub.dev/lucide_icons_flutter-3.1.14+2/assets/lucide.ttf';
  final lucideLoader = FontLoader('packages/lucide_icons_flutter/Lucide')
    ..addFont(_fontData(lucideFontPath));
  await lucideLoader.load();
}

Future<ByteData> _fontData(String path) async {
  final bytes = await File(path).readAsBytes();
  return ByteData.view(Uint8List.fromList(bytes).buffer);
}

Future<void> _setPhoneViewport(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() async {
    tester.view.resetDevicePixelRatio();
    await tester.binding.setSurfaceSize(null);
  });
}
