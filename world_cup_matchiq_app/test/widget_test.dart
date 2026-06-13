import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/app/world_cup_matchiq_app.dart';

void main() {
  testWidgets('renders app shell with match and saved prediction tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();

    expect(find.text('World Cup MatchIQ'), findsOneWidget);
    expect(find.text('Matches'), findsWidgets);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Today\'s fixtures'), findsOneWidget);
    expect(find.text('Brazil vs Morocco'), findsOneWidget);
  });

  testWidgets('opens match detail and saves a prediction', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brazil vs Morocco'));
    await tester.pumpAndSettle();

    expect(find.text('Match context'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Prototype scoreline'),
      200,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Prototype scoreline'), findsOneWidget);
    expect(find.textContaining('Not betting odds'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Likely scorers'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Likely scorers'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Save prediction'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Save prediction'));
    await tester.pumpAndSettle();

    expect(find.text('Saved predictions'), findsOneWidget);
    expect(find.text('Brazil vs Morocco'), findsOneWidget);
  });

  testWidgets('clears saved predictions from the saved tab', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brazil vs Morocco'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Save prediction'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Save prediction'));
    await tester.pumpAndSettle();

    expect(find.text('Brazil vs Morocco'), findsOneWidget);

    await tester.tap(find.text('Clear saved predictions'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'No saved predictions yet. Open a match and save the prototype estimate.',
      ),
      findsOneWidget,
    );
  });
}
