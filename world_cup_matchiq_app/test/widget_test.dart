import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/app/world_cup_matchiq_app.dart';

void main() {
  testWidgets('renders setup home and creates a personalized home', (
    tester,
  ) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();

    expect(find.text('World Cup MatchIQ'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Fixtures'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Set up your World Cup'), findsOneWidget);
    expect(find.text('Fixture snapshot'), findsOneWidget);

    await tester.tap(find.text('Use these settings'));
    await tester.pumpAndSettle();

    expect(find.text('Your World Cup'), findsOneWidget);
    expect(find.text('Portugal'), findsOneWidget);
    expect(
      find.text('No Portugal match in today\'s snapshot.'),
      findsOneWidget,
    );
    expect(find.text('Today near you'), findsOneWidget);
    expect(find.textContaining('FOX/FS1'), findsWidgets);
  });

  testWidgets('opens match detail with viewing metadata and saves prediction', (
    tester,
  ) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use these settings'));
    await tester.pumpAndSettle();

    await tester.tap(_navLabel('Fixtures'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brazil vs Morocco'));
    await tester.pumpAndSettle();

    expect(find.text('Viewing'), findsOneWidget);
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

    expect(find.text('Your World Cup'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Saved predictions'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Saved predictions'), findsOneWidget);
    expect(find.text('1 saved'), findsOneWidget);
  });

  testWidgets('clears saved predictions from the profile tab', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use these settings'));
    await tester.pumpAndSettle();

    await tester.tap(_navLabel('Fixtures'));
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

    await tester.tap(_navLabel('Profile'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Brazil vs Morocco'), findsOneWidget);

    await tester.tap(find.text('Clear saved predictions'));
    await tester.pumpAndSettle();

    expect(find.text('No saved predictions yet.'), findsOneWidget);
  });
}

Finder _navLabel(String label) {
  return find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );
}
