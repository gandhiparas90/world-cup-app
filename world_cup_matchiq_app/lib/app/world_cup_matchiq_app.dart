import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/ai_preview_repository.dart';
import '../data/fixture_result_repository.dart';
import '../data/match_repository.dart';
import '../data/saved_prediction_repository.dart';
import '../data/user_profile_repository.dart';
import '../screens/home_screen.dart';
import '../screens/matches_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/teams_screen.dart';
import '../services/ai_match_preview_service.dart';
import '../state/matchiq_controller.dart';
import 'theme.dart';

class WorldCupMatchIqEntryPoint extends StatelessWidget {
  const WorldCupMatchIqEntryPoint({
    this.matchRepository = const MatchRepository.seeded(),
    this.savedPredictionRepository,
    this.userProfileRepository,
    this.aiPreviewRepository,
    this.fixtureResultRepository,
    this.aiMatchPreviewService,
    this.theme,
    super.key,
  });

  final MatchRepository matchRepository;
  final SavedPredictionRepository? savedPredictionRepository;
  final UserProfileRepository? userProfileRepository;
  final AiPreviewRepository? aiPreviewRepository;
  final FixtureResultRepository? fixtureResultRepository;
  final AiMatchPreviewService? aiMatchPreviewService;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatchIqController(
        matchRepository: matchRepository,
        savedPredictionRepository:
            savedPredictionRepository ?? InMemorySavedPredictionRepository(),
        userProfileRepository:
            userProfileRepository ?? InMemoryUserProfileRepository(),
        aiPreviewRepository:
            aiPreviewRepository ?? InMemoryAiPreviewRepository(),
        fixtureResultRepository:
            fixtureResultRepository ?? InMemoryFixtureResultRepository(),
        aiMatchPreviewService:
            aiMatchPreviewService ?? const FallbackAiMatchPreviewService(),
      )..load(),
      child: MaterialApp(
        title: 'World Cup MatchIQ',
        debugShowCheckedModeBanner: false,
        theme: theme ?? MatchIqTheme.light(),
        home: const WorldCupMatchIqApp(),
      ),
    );
  }
}

class WorldCupMatchIqApp extends StatelessWidget {
  const WorldCupMatchIqApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MatchIqController>();
    final screens = [
      HomeScreen(
        matches: controller.matches,
        teams: controller.teams,
        teamById: controller.teamById,
        profile: controller.profile,
        savedPredictions: controller.savedPredictions,
        onSaveProfile: controller.saveProfile,
        onOpenFixtures: () => controller.selectTab(1),
        onOpenProfile: () => controller.selectTab(3),
      ),
      MatchesScreen(
        matches: controller.matches,
        teamById: controller.teamById,
        playersForMatch: controller.playersForMatch,
        profile: controller.profile,
        onSavePrediction: controller.savePrediction,
      ),
      TeamsScreen(
        teams: controller.teams,
        matchesForTeam: controller.matchesForTeam,
        teamById: controller.teamById,
      ),
      ProfileScreen(
        profile: controller.profile,
        teams: controller.teams,
        savedPredictions: controller.savedPredictions,
        onSaveProfile: controller.saveProfile,
        onResetProfile: controller.resetProfile,
        onClearSavedPredictions: controller.clearSavedPredictions,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('World Cup MatchIQ')),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : screens[controller.selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.selectedIndex,
        onDestinationSelected: controller.selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.house),
            selectedIcon: Icon(LucideIcons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.calendarDays),
            selectedIcon: Icon(LucideIcons.calendarDays),
            label: 'Fixtures',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.usersRound),
            selectedIcon: Icon(LucideIcons.usersRound),
            label: 'Teams',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.userRound),
            selectedIcon: Icon(LucideIcons.userRound),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
