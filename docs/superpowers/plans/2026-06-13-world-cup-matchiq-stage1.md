# World Cup MatchIQ Stage 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first runnable Flutter checkpoint: a World Cup-themed app with three functional screens, seeded data, match detail navigation, and in-memory saved predictions.

**Architecture:** Create the Flutter project under `world_cup_matchiq_app/` so repo-level docs remain separate. Stage 1 uses seeded local data and lightweight in-memory state; Stage 2 will replace that state with Provider and Hive without changing the user flow.

**Tech Stack:** Flutter SDK at `/Users/parasgandhi/Project/temp/flutter`, Dart, Material 3, generated Flutter test tooling, no external runtime packages in Stage 1.

---

## Scope

This plan implements Stage 1 only. A later plan will cover Provider/Hive persistence after this app runs cleanly.

Stage 1 must end with:

- A generated Flutter project in `world_cup_matchiq_app/`.
- Three screens: Matches, Match Detail, Saved Predictions.
- Seeded World Cup-style teams, players, and matches.
- In-memory save flow from Match Detail to Saved Predictions.
- Passing `flutter analyze` and `flutter test`.
- A commit pushed to `origin/main`.

## File Structure

- Create: `world_cup_matchiq_app/` via `flutter create`.
- Modify: `world_cup_matchiq_app/pubspec.yaml` for project description.
- Modify: `world_cup_matchiq_app/lib/main.dart` for app entrypoint.
- Create: `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart` for root navigation and in-memory save state.
- Create: `world_cup_matchiq_app/lib/app/theme.dart` for Material theme.
- Create: `world_cup_matchiq_app/lib/models/team.dart` for team fields.
- Create: `world_cup_matchiq_app/lib/models/player.dart` for player fields.
- Create: `world_cup_matchiq_app/lib/models/world_cup_match.dart` for match fields.
- Create: `world_cup_matchiq_app/lib/models/saved_prediction.dart` for saved prediction entries.
- Create: `world_cup_matchiq_app/lib/data/seed_data.dart` for seeded teams, players, and matches.
- Create: `world_cup_matchiq_app/lib/screens/matches_screen.dart` for the fixture dashboard.
- Create: `world_cup_matchiq_app/lib/screens/match_detail_screen.dart` for comparison, prediction, and save action.
- Create: `world_cup_matchiq_app/lib/screens/saved_predictions_screen.dart` for saved items.
- Create: `world_cup_matchiq_app/lib/widgets/match_card.dart` for match list cards.
- Create: `world_cup_matchiq_app/lib/widgets/prediction_summary.dart` for scoreline and confidence display.
- Create: `world_cup_matchiq_app/lib/widgets/scorer_likelihood_list.dart` for likely scorer display.
- Modify: `world_cup_matchiq_app/test/widget_test.dart` for Stage 1 navigation and save-flow coverage.

## Stage 1 Task List

### Task 1: Scaffold The Flutter Project

**Files:**
- Create: `world_cup_matchiq_app/`

- [ ] **Step 1: Generate the project**

Run from repo root:

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter create --project-name world_cup_matchiq --org com.gandhiparas90 --platforms=android,ios,web,macos world_cup_matchiq_app
```

Expected: Flutter creates `world_cup_matchiq_app/` with `lib/main.dart`, `pubspec.yaml`, `test/widget_test.dart`, and platform folders.

- [ ] **Step 2: Verify generated app baseline**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
```

Expected: both commands exit 0 on the generated app.

- [ ] **Step 3: Commit scaffold**

Run from repo root:

```bash
git add world_cup_matchiq_app
git commit -m "chore: scaffold Flutter app"
```

Expected: one commit containing only generated Flutter scaffold files.

### Task 2: Add Domain Models And Seed Data

**Files:**
- Create: `world_cup_matchiq_app/lib/models/team.dart`
- Create: `world_cup_matchiq_app/lib/models/player.dart`
- Create: `world_cup_matchiq_app/lib/models/world_cup_match.dart`
- Create: `world_cup_matchiq_app/lib/models/saved_prediction.dart`
- Create: `world_cup_matchiq_app/lib/data/seed_data.dart`
- Test: `world_cup_matchiq_app/test/seed_data_test.dart`

- [ ] **Step 1: Write the failing seed-data test**

Create `world_cup_matchiq_app/test/seed_data_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';

void main() {
  test('seed data has enough teams, players, and matches for Stage 1', () {
    expect(SeedData.teams.length, greaterThanOrEqualTo(6));
    expect(SeedData.players.length, greaterThanOrEqualTo(12));
    expect(SeedData.matches.length, greaterThanOrEqualTo(3));
  });

  test('every seeded match can resolve both teams and likely scorers', () {
    for (final match in SeedData.matches) {
      final home = SeedData.teamById(match.homeTeamId);
      final away = SeedData.teamById(match.awayTeamId);
      final scorers = SeedData.playersForMatch(match.id);

      expect(home.name, isNotEmpty);
      expect(away.name, isNotEmpty);
      expect(scorers.length, greaterThanOrEqualTo(4));
    }
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/seed_data_test.dart
```

Expected: FAIL because `data/seed_data.dart` does not exist yet.

- [ ] **Step 3: Add team model**

Create `world_cup_matchiq_app/lib/models/team.dart`:

```dart
class Team {
  const Team({
    required this.id,
    required this.name,
    required this.code,
    required this.flagLabel,
    required this.manager,
    required this.style,
    required this.attackRating,
    required this.defenseRating,
    required this.formPoints,
    required this.avgGoalsFor,
    required this.avgGoalsAgainst,
  });

  final String id;
  final String name;
  final String code;
  final String flagLabel;
  final String manager;
  final String style;
  final int attackRating;
  final int defenseRating;
  final int formPoints;
  final double avgGoalsFor;
  final double avgGoalsAgainst;
}
```

- [ ] **Step 4: Add player model**

Create `world_cup_matchiq_app/lib/models/player.dart`:

```dart
class Player {
  const Player({
    required this.id,
    required this.teamId,
    required this.name,
    required this.position,
    required this.recentGoals,
    required this.recentAssists,
    required this.likelyStarter,
  });

  final String id;
  final String teamId;
  final String name;
  final String position;
  final int recentGoals;
  final int recentAssists;
  final bool likelyStarter;

  int get goalInvolvement => recentGoals + recentAssists;
}
```

- [ ] **Step 5: Add match model**

Create `world_cup_matchiq_app/lib/models/world_cup_match.dart`:

```dart
class WorldCupMatch {
  const WorldCupMatch({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.stage,
    required this.kickoffLabel,
    required this.venue,
    required this.storyline,
  });

  final String id;
  final String homeTeamId;
  final String awayTeamId;
  final String stage;
  final String kickoffLabel;
  final String venue;
  final String storyline;
}
```

- [ ] **Step 6: Add saved prediction model**

Create `world_cup_matchiq_app/lib/models/saved_prediction.dart`:

```dart
class SavedPrediction {
  const SavedPrediction({
    required this.matchId,
    required this.matchLabel,
    required this.scoreline,
    required this.confidence,
    required this.createdAt,
  });

  final String matchId;
  final String matchLabel;
  final String scoreline;
  final String confidence;
  final DateTime createdAt;
}
```

- [ ] **Step 7: Add seeded data**

Create `world_cup_matchiq_app/lib/data/seed_data.dart`:

```dart
import '../models/player.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';

class SeedData {
  const SeedData._();

  static const teams = <Team>[
    Team(
      id: 'arg',
      name: 'Argentina',
      code: 'ARG',
      flagLabel: 'ARG',
      manager: 'Lionel Scaloni',
      style: 'Compact midfield, quick combinations, late runs into the box',
      attackRating: 88,
      defenseRating: 82,
      formPoints: 13,
      avgGoalsFor: 2.1,
      avgGoalsAgainst: 0.8,
    ),
    Team(
      id: 'fra',
      name: 'France',
      code: 'FRA',
      flagLabel: 'FRA',
      manager: 'Didier Deschamps',
      style: 'Explosive transitions, direct wing play, elite recovery pace',
      attackRating: 90,
      defenseRating: 84,
      formPoints: 12,
      avgGoalsFor: 2.3,
      avgGoalsAgainst: 0.9,
    ),
    Team(
      id: 'bra',
      name: 'Brazil',
      code: 'BRA',
      flagLabel: 'BRA',
      manager: 'Dorival Junior',
      style: 'Wide overloads, flair in isolation, aggressive counter-pressing',
      attackRating: 87,
      defenseRating: 80,
      formPoints: 10,
      avgGoalsFor: 1.9,
      avgGoalsAgainst: 1.0,
    ),
    Team(
      id: 'eng',
      name: 'England',
      code: 'ENG',
      flagLabel: 'ENG',
      manager: 'Gareth Southgate',
      style: 'Structured possession, set-piece threat, controlled tempo',
      attackRating: 86,
      defenseRating: 83,
      formPoints: 11,
      avgGoalsFor: 2.0,
      avgGoalsAgainst: 0.9,
    ),
    Team(
      id: 'usa',
      name: 'United States',
      code: 'USA',
      flagLabel: 'USA',
      manager: 'Mauricio Pochettino',
      style: 'High energy pressing, vertical carries, fast wide attacks',
      attackRating: 78,
      defenseRating: 76,
      formPoints: 8,
      avgGoalsFor: 1.5,
      avgGoalsAgainst: 1.2,
    ),
    Team(
      id: 'por',
      name: 'Portugal',
      code: 'POR',
      flagLabel: 'POR',
      manager: 'Roberto Martinez',
      style: 'Patient build-up, creative midfield rotations, strong crossing',
      attackRating: 85,
      defenseRating: 79,
      formPoints: 10,
      avgGoalsFor: 2.0,
      avgGoalsAgainst: 1.1,
    ),
  ];

  static const players = <Player>[
    Player(id: 'messi', teamId: 'arg', name: 'L. Messi', position: 'Forward', recentGoals: 4, recentAssists: 3, likelyStarter: true),
    Player(id: 'alvarez', teamId: 'arg', name: 'J. Alvarez', position: 'Forward', recentGoals: 3, recentAssists: 2, likelyStarter: true),
    Player(id: 'mbappe', teamId: 'fra', name: 'K. Mbappe', position: 'Forward', recentGoals: 6, recentAssists: 2, likelyStarter: true),
    Player(id: 'griezmann', teamId: 'fra', name: 'A. Griezmann', position: 'Midfielder', recentGoals: 2, recentAssists: 4, likelyStarter: true),
    Player(id: 'vinicius', teamId: 'bra', name: 'V. Junior', position: 'Forward', recentGoals: 4, recentAssists: 3, likelyStarter: true),
    Player(id: 'rodrygo', teamId: 'bra', name: 'Rodrygo', position: 'Forward', recentGoals: 3, recentAssists: 2, likelyStarter: true),
    Player(id: 'kane', teamId: 'eng', name: 'H. Kane', position: 'Forward', recentGoals: 5, recentAssists: 2, likelyStarter: true),
    Player(id: 'bellingham', teamId: 'eng', name: 'J. Bellingham', position: 'Midfielder', recentGoals: 3, recentAssists: 3, likelyStarter: true),
    Player(id: 'pulisic', teamId: 'usa', name: 'C. Pulisic', position: 'Forward', recentGoals: 3, recentAssists: 3, likelyStarter: true),
    Player(id: 'balogun', teamId: 'usa', name: 'F. Balogun', position: 'Forward', recentGoals: 2, recentAssists: 1, likelyStarter: true),
    Player(id: 'ronaldo', teamId: 'por', name: 'C. Ronaldo', position: 'Forward', recentGoals: 4, recentAssists: 1, likelyStarter: true),
    Player(id: 'leao', teamId: 'por', name: 'R. Leao', position: 'Forward', recentGoals: 3, recentAssists: 2, likelyStarter: true),
  ];

  static const matches = <WorldCupMatch>[
    WorldCupMatch(
      id: 'arg-fra',
      homeTeamId: 'arg',
      awayTeamId: 'fra',
      stage: 'Group Stage',
      kickoffLabel: 'Sat 7:00 PM',
      venue: 'MetLife Stadium',
      storyline: 'A heavyweight rematch built around control versus transition speed.',
    ),
    WorldCupMatch(
      id: 'bra-eng',
      homeTeamId: 'bra',
      awayTeamId: 'eng',
      stage: 'Round of 16',
      kickoffLabel: 'Sun 4:00 PM',
      venue: 'AT&T Stadium',
      storyline: 'Brazilian wing creation meets England set-piece structure.',
    ),
    WorldCupMatch(
      id: 'usa-por',
      homeTeamId: 'usa',
      awayTeamId: 'por',
      stage: 'Group Stage',
      kickoffLabel: 'Tue 8:00 PM',
      venue: 'SoFi Stadium',
      storyline: 'The hosts test their pressing game against Portugal possession.',
    ),
  ];

  static Team teamById(String id) {
    return teams.firstWhere((team) => team.id == id);
  }

  static WorldCupMatch matchById(String id) {
    return matches.firstWhere((match) => match.id == id);
  }

  static List<Player> playersForTeam(String teamId) {
    return players.where((player) => player.teamId == teamId).toList();
  }

  static List<Player> playersForMatch(String matchId) {
    final match = matchById(matchId);
    final matchTeamIds = {match.homeTeamId, match.awayTeamId};
    return players.where((player) => matchTeamIds.contains(player.teamId)).toList();
  }
}
```

- [ ] **Step 8: Run seed-data test**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/seed_data_test.dart
```

Expected: PASS.

- [ ] **Step 9: Commit models and seed data**

Run from repo root:

```bash
git add world_cup_matchiq_app/lib/models world_cup_matchiq_app/lib/data world_cup_matchiq_app/test/seed_data_test.dart
git commit -m "feat: add World Cup seed data"
```

### Task 3: Build App Shell With Three Screens

**Files:**
- Modify: `world_cup_matchiq_app/lib/main.dart`
- Create: `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart`
- Create: `world_cup_matchiq_app/lib/app/theme.dart`
- Create: `world_cup_matchiq_app/lib/screens/matches_screen.dart`
- Create: `world_cup_matchiq_app/lib/screens/saved_predictions_screen.dart`
- Modify: `world_cup_matchiq_app/test/widget_test.dart`

- [ ] **Step 1: Replace generated widget test with shell expectations**

Replace `world_cup_matchiq_app/test/widget_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/main.dart';

void main() {
  testWidgets('renders app shell with match and saved prediction tabs', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());

    expect(find.text('World Cup MatchIQ'), findsOneWidget);
    expect(find.text('Matches'), findsWidgets);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Argentina'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run widget test to verify it fails**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/widget_test.dart
```

Expected: FAIL because `WorldCupMatchIqEntryPoint` and app screens do not exist.

- [ ] **Step 3: Add app entrypoint**

Replace `world_cup_matchiq_app/lib/main.dart`:

```dart
import 'package:flutter/material.dart';

import 'app/world_cup_matchiq_app.dart';

void main() {
  runApp(const WorldCupMatchIqEntryPoint());
}
```

- [ ] **Step 4: Add theme**

Create `world_cup_matchiq_app/lib/app/theme.dart`:

```dart
import 'package:flutter/material.dart';

class MatchIqTheme {
  const MatchIqTheme._();

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0B7A5B),
      primary: const Color(0xFF0B7A5B),
      secondary: const Color(0xFF1D4ED8),
      tertiary: const Color(0xFFEAB308),
    );

    return ThemeData(
      colorScheme: base,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7FAFC),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFF7FAFC),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Add root app with tab navigation**

Create `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart`:

```dart
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
```

- [ ] **Step 6: Add matches screen**

Create `world_cup_matchiq_app/lib/screens/matches_screen.dart`:

```dart
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/saved_prediction.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    required this.onSavePrediction,
    super.key,
  });

  final ValueChanged<SavedPrediction> onSavePrediction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Featured fixtures',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Seeded demo coverage for match previews, predictions, and player-impact analysis.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final match in SeedData.matches)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                '${SeedData.teamById(match.homeTeamId).name} vs ${SeedData.teamById(match.awayTeamId).name}',
              ),
              subtitle: Text('${match.stage} - ${match.kickoffLabel} - ${match.venue}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 7: Add saved predictions screen**

Create `world_cup_matchiq_app/lib/screens/saved_predictions_screen.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/saved_prediction.dart';

class SavedPredictionsScreen extends StatelessWidget {
  const SavedPredictionsScreen({
    required this.predictions,
    super.key,
  });

  final List<SavedPrediction> predictions;

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No saved predictions yet. Open a match and save the prototype estimate.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: predictions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        return Card(
          child: ListTile(
            title: Text(prediction.matchLabel),
            subtitle: Text('${prediction.scoreline} - ${prediction.confidence} confidence'),
            trailing: Text(
              '${prediction.createdAt.hour.toString().padLeft(2, '0')}:${prediction.createdAt.minute.toString().padLeft(2, '0')}',
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 8: Run shell test**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/widget_test.dart
```

Expected: PASS.

- [ ] **Step 9: Commit app shell**

Run from repo root:

```bash
git add world_cup_matchiq_app/lib world_cup_matchiq_app/test/widget_test.dart
git commit -m "feat: add World Cup app shell"
```

### Task 4: Add Match Detail And In-Memory Save Flow

**Files:**
- Modify: `world_cup_matchiq_app/lib/screens/matches_screen.dart`
- Create: `world_cup_matchiq_app/lib/screens/match_detail_screen.dart`
- Create: `world_cup_matchiq_app/lib/widgets/match_card.dart`
- Create: `world_cup_matchiq_app/lib/widgets/prediction_summary.dart`
- Create: `world_cup_matchiq_app/lib/widgets/scorer_likelihood_list.dart`
- Modify: `world_cup_matchiq_app/test/widget_test.dart`

- [ ] **Step 1: Extend widget test for navigation and save flow**

Replace `world_cup_matchiq_app/test/widget_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/main.dart';

void main() {
  testWidgets('renders app shell with match and saved prediction tabs', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());

    expect(find.text('World Cup MatchIQ'), findsOneWidget);
    expect(find.text('Matches'), findsWidgets);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Argentina'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
  });

  testWidgets('opens match detail and saves a prediction', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());

    await tester.tap(find.text('Argentina vs France'));
    await tester.pumpAndSettle();

    expect(find.text('Prototype scoreline'), findsOneWidget);
    expect(find.text('Likely scorers'), findsOneWidget);

    await tester.tap(find.text('Save prediction'));
    await tester.pumpAndSettle();

    expect(find.text('Saved predictions'), findsOneWidget);
    expect(find.text('Argentina vs France'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run widget test to verify it fails**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/widget_test.dart
```

Expected: FAIL because the match cards do not navigate and detail widgets do not exist.

- [ ] **Step 3: Add match card widget**

Create `world_cup_matchiq_app/lib/widgets/match_card.dart`:

```dart
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/world_cup_match.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    required this.match,
    required this.onTap,
    super.key,
  });

  final WorldCupMatch match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = SeedData.teamById(match.homeTeamId);
    final away = SeedData.teamById(match.awayTeamId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${home.name} vs ${away.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text('${match.stage} - ${match.kickoffLabel}'),
              const SizedBox(height: 4),
              Text(match.venue),
              const SizedBox(height: 12),
              Text(
                match.storyline,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Add prediction summary widget**

Create `world_cup_matchiq_app/lib/widgets/prediction_summary.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/team.dart';

class PrototypePrediction {
  const PrototypePrediction({
    required this.scoreline,
    required this.confidence,
  });

  final String scoreline;
  final String confidence;
}

PrototypePrediction estimatePrototypePrediction(Team home, Team away) {
  final homeRaw = home.avgGoalsFor + ((home.attackRating - away.defenseRating) / 30);
  final awayRaw = away.avgGoalsFor + ((away.attackRating - home.defenseRating) / 30);
  final homeScore = homeRaw.clamp(0.0, 4.0).round();
  final awayScore = awayRaw.clamp(0.0, 4.0).round();
  final ratingGap = (home.attackRating + home.defenseRating + home.formPoints) -
      (away.attackRating + away.defenseRating + away.formPoints);
  final confidence = ratingGap.abs() > 8 ? 'High' : ratingGap.abs() > 3 ? 'Medium' : 'Low';

  return PrototypePrediction(
    scoreline: '${home.name} $homeScore-$awayScore ${away.name}',
    confidence: confidence,
  );
}

class PredictionSummary extends StatelessWidget {
  const PredictionSummary({
    required this.home,
    required this.away,
    super.key,
  });

  final Team home;
  final Team away;

  @override
  Widget build(BuildContext context) {
    final prediction = estimatePrototypePrediction(home, away);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prototype scoreline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              prediction.scoreline,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text('${prediction.confidence} confidence estimate based on seeded team ratings.'),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Add scorer likelihood widget**

Create `world_cup_matchiq_app/lib/widgets/scorer_likelihood_list.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/player.dart';

class ScorerLikelihoodList extends StatelessWidget {
  const ScorerLikelihoodList({
    required this.players,
    super.key,
  });

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final ranked = [...players]
      ..sort((a, b) => b.goalInvolvement.compareTo(a.goalInvolvement));
    final topPlayers = ranked.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Likely scorers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            for (final player in topPlayers)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${player.name} - ${player.position}'),
                    ),
                    Text('${_likelihood(player)}%'),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Prototype likelihoods are based on recent seeded goal involvement, not betting odds.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  int _likelihood(Player player) {
    final base = player.likelyStarter ? 18 : 10;
    final involvementBoost = player.goalInvolvement * 3;
    return (base + involvementBoost).clamp(8, 42);
  }
}
```

- [ ] **Step 6: Add match detail screen**

Create `world_cup_matchiq_app/lib/screens/match_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/saved_prediction.dart';
import '../models/world_cup_match.dart';
import '../widgets/prediction_summary.dart';
import '../widgets/scorer_likelihood_list.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({
    required this.match,
    required this.onSavePrediction,
    super.key,
  });

  final WorldCupMatch match;
  final ValueChanged<SavedPrediction> onSavePrediction;

  @override
  Widget build(BuildContext context) {
    final home = SeedData.teamById(match.homeTeamId);
    final away = SeedData.teamById(match.awayTeamId);
    final prediction = estimatePrototypePrediction(home, away);

    return Scaffold(
      appBar: AppBar(
        title: Text('${home.code} vs ${away.code}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${home.flagLabel} ${home.name} vs ${away.flagLabel} ${away.name}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text('${match.stage} - ${match.kickoffLabel} - ${match.venue}'),
          const SizedBox(height: 16),
          _TeamComparison(homeName: home.name, awayName: away.name, homeValue: home.style, awayValue: away.style),
          const SizedBox(height: 12),
          PredictionSummary(home: home, away: away),
          const SizedBox(height: 12),
          ScorerLikelihoodList(players: SeedData.playersForMatch(match.id)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              onSavePrediction(
                SavedPrediction(
                  matchId: match.id,
                  matchLabel: '${home.name} vs ${away.name}',
                  scoreline: prediction.scoreline,
                  confidence: prediction.confidence,
                  createdAt: DateTime.now(),
                ),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.bookmark_add),
            label: const Text('Save prediction'),
          ),
        ],
      ),
    );
  }
}

class _TeamComparison extends StatelessWidget {
  const _TeamComparison({
    required this.homeName,
    required this.awayName,
    required this.homeValue,
    required this.awayValue,
  });

  final String homeName;
  final String awayName;
  final String homeValue;
  final String awayValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Style comparison',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Text('$homeName: $homeValue'),
            const SizedBox(height: 8),
            Text('$awayName: $awayValue'),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Wire match screen navigation**

Replace `world_cup_matchiq_app/lib/screens/matches_screen.dart`:

```dart
import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/saved_prediction.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    required this.onSavePrediction,
    super.key,
  });

  final ValueChanged<SavedPrediction> onSavePrediction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Featured fixtures',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Seeded demo coverage for match previews, predictions, and player-impact analysis.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final match in SeedData.matches)
          MatchCard(
            match: match,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MatchDetailScreen(
                    match: match,
                    onSavePrediction: onSavePrediction,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
```

- [ ] **Step 8: Add heading to saved predictions screen**

Replace `world_cup_matchiq_app/lib/screens/saved_predictions_screen.dart`:

```dart
import 'package:flutter/material.dart';

import '../models/saved_prediction.dart';

class SavedPredictionsScreen extends StatelessWidget {
  const SavedPredictionsScreen({
    required this.predictions,
    super.key,
  });

  final List<SavedPrediction> predictions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Saved predictions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        if (predictions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Text(
              'No saved predictions yet. Open a match and save the prototype estimate.',
              textAlign: TextAlign.center,
            ),
          )
        else
          for (final prediction in predictions)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(prediction.matchLabel),
                subtitle: Text('${prediction.scoreline} - ${prediction.confidence} confidence'),
                trailing: Text(
                  '${prediction.createdAt.hour.toString().padLeft(2, '0')}:${prediction.createdAt.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
      ],
    );
  }
}
```

- [ ] **Step 9: Run widget tests**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/widget_test.dart
```

Expected: PASS.

- [ ] **Step 10: Run full Stage 1 verification**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
/Users/parasgandhi/Project/temp/flutter/bin/flutter build web --no-wasm-dry-run
```

Expected: all commands exit 0. If `flutter build web --no-wasm-dry-run` is not supported by the installed Flutter version, run `/Users/parasgandhi/Project/temp/flutter/bin/flutter build web` and record the command substitution in the final note.

- [ ] **Step 11: Commit Stage 1 runnable app**

Run from repo root:

```bash
git add world_cup_matchiq_app
git commit -m "feat: build runnable World Cup match app"
```

### Task 5: Push Stage 1 And Record Checkpoint

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update README with Stage 1 status**

Modify `README.md` to include:

````markdown
## Current Checkpoint

Stage 1 is the first runnable Flutter checkpoint:

- Matches screen with seeded World Cup fixtures.
- Match Detail screen with prototype scoreline and scorer likelihood estimates.
- Saved Predictions screen with in-memory saved predictions.

Run the app:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter run -d chrome
```
````

- [ ] **Step 2: Commit README checkpoint update**

Run:

```bash
git add README.md
git commit -m "docs: document Stage 1 checkpoint"
```

- [ ] **Step 3: Push to GitHub**

Run:

```bash
git push
```

Expected: `main` pushes to `git@github.com:gandhiparas90/world-cup-app.git`.

- [ ] **Step 4: Verify remote hash**

Run:

```bash
git rev-parse HEAD
git ls-remote origin refs/heads/main
```

Expected: both commands show the same commit hash.

## Stage 1 Completion Checklist

- [ ] `world_cup_matchiq_app/` exists.
- [ ] App opens to Matches screen.
- [ ] App has Matches and Saved bottom navigation.
- [ ] Tapping `Argentina vs France` opens Match Detail.
- [ ] Match Detail shows `Prototype scoreline`.
- [ ] Match Detail shows `Likely scorers`.
- [ ] `Save prediction` returns to the main app and the Saved screen lists the saved match.
- [ ] `flutter analyze` exits 0.
- [ ] `flutter test` exits 0.
- [ ] `flutter build web --no-wasm-dry-run` or the supported web build command exits 0.
- [ ] Stage 1 commit is pushed to `origin/main`.

## Next Plan After Stage 1

Stage 2 should add Provider and Hive persistence while preserving the Stage 1 UI and tests. The next plan should start from the Stage 1 completion hash and use tests around save persistence before changing state management.
