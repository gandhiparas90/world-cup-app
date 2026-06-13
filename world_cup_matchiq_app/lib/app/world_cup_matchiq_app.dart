import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/match_repository.dart';
import '../data/saved_prediction_repository.dart';
import '../data/user_profile_repository.dart';
import '../screens/matches_screen.dart';
import '../screens/saved_predictions_screen.dart';
import '../state/matchiq_controller.dart';
import 'theme.dart';

class WorldCupMatchIqEntryPoint extends StatelessWidget {
  const WorldCupMatchIqEntryPoint({
    this.matchRepository = const MatchRepository.seeded(),
    this.savedPredictionRepository,
    this.userProfileRepository,
    super.key,
  });

  final MatchRepository matchRepository;
  final SavedPredictionRepository? savedPredictionRepository;
  final UserProfileRepository? userProfileRepository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatchIqController(
        matchRepository: matchRepository,
        savedPredictionRepository:
            savedPredictionRepository ?? InMemorySavedPredictionRepository(),
        userProfileRepository:
            userProfileRepository ?? InMemoryUserProfileRepository(),
      )..load(),
      child: MaterialApp(
        title: 'World Cup MatchIQ',
        debugShowCheckedModeBanner: false,
        theme: MatchIqTheme.light(),
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
      MatchesScreen(
        matches: controller.matches,
        teamById: controller.teamById,
        playersForMatch: controller.playersForMatch,
        onSavePrediction: controller.savePrediction,
      ),
      SavedPredictionsScreen(
        predictions: controller.savedPredictions,
        onClearPredictions: controller.clearSavedPredictions,
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
            icon: Icon(Icons.sports_soccer_outlined),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
