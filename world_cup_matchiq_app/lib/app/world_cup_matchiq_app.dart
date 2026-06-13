import 'package:flutter/material.dart';

import '../models/saved_prediction.dart';
import '../screens/matches_screen.dart';
import '../screens/saved_predictions_screen.dart';
import 'theme.dart';

class WorldCupMatchIqEntryPoint extends StatelessWidget {
  const WorldCupMatchIqEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Cup MatchIQ',
      debugShowCheckedModeBanner: false,
      theme: MatchIqTheme.light(),
      home: const WorldCupMatchIqApp(),
    );
  }
}

class WorldCupMatchIqApp extends StatefulWidget {
  const WorldCupMatchIqApp({super.key});

  @override
  State<WorldCupMatchIqApp> createState() => _WorldCupMatchIqAppState();
}

class _WorldCupMatchIqAppState extends State<WorldCupMatchIqApp> {
  var _selectedIndex = 0;
  final _savedPredictions = <SavedPrediction>[];

  void _savePrediction(SavedPrediction prediction) {
    setState(() {
      _savedPredictions.insert(0, prediction);
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MatchesScreen(onSavePrediction: _savePrediction),
      SavedPredictionsScreen(predictions: _savedPredictions),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Cup MatchIQ'),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
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
