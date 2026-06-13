import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/app/world_cup_matchiq_app.dart';

void main() {
  testWidgets('renders app shell with match and saved prediction tabs', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());

    expect(find.text('World Cup MatchIQ'), findsOneWidget);
    expect(find.text('Matches'), findsWidgets);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Argentina vs France'), findsOneWidget);
  });

  testWidgets('opens match detail and saves a prediction', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());

    await tester.tap(find.text('Argentina vs France'));
    await tester.pumpAndSettle();

    expect(find.text('Prototype scoreline'), findsOneWidget);
    expect(find.text('Likely scorers'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Save prediction'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Save prediction'));
    await tester.pumpAndSettle();

    expect(find.text('Saved predictions'), findsOneWidget);
    expect(find.text('Argentina vs France'), findsOneWidget);
  });
}
