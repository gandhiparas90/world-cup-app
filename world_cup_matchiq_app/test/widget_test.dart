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
    expect(find.text('Teams'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Set up your World Cup'), findsOneWidget);
    expect(find.text('Fixture snapshot'), findsOneWidget);

    await tester.tap(find.text('Use these settings'));
    await tester.pumpAndSettle();

    expect(find.text('Your World Cup'), findsOneWidget);
    expect(find.text('Portugal'), findsOneWidget);
    expect(find.text('Portugal vs DR Congo'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Next near you'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Next near you'), findsOneWidget);
    expect(find.textContaining('FOX'), findsWidgets);
  });

  testWidgets('searches teams from the full team catalog', (tester) async {
    await tester.pumpWidget(const WorldCupMatchIqEntryPoint());
    await tester.pumpAndSettle();

    await tester.tap(_navLabel('Teams'));
    await tester.pumpAndSettle();

    expect(find.text('48 World Cup teams across 12 groups.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Portugal');
    await tester.pumpAndSettle();

    expect(find.text('Portugal'), findsWidgets);
    expect(find.text('Group K - UEFA'), findsOneWidget);
    expect(find.textContaining('vs DR Congo'), findsOneWidget);
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

    await _openFixture(tester, 'Brazil vs Morocco');

    expect(find.text('Viewing'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Prototype scoreline'),
      200,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Prototype scoreline'), findsOneWidget);
    expect(find.textContaining('Not betting odds'), findsOneWidget);
    expect(find.text('Win / draw / loss probability'), findsOneWidget);
    expect(find.textContaining('Brazil win'), findsOneWidget);
    expect(find.textContaining('Morocco win'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('AI match preview'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('AI match preview'), findsOneWidget);
    expect(find.text('Generate AI preview'), findsOneWidget);
    await tester.tap(find.text('Generate AI preview'));
    await tester.pumpAndSettle();
    expect(find.textContaining('local signal'), findsOneWidget);
    expect(find.text('Refresh AI preview'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Why this prediction?'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Why this prediction?'), findsOneWidget);
    expect(find.textContaining('Expected goals:'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Likely scorers'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Likely scorers'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Match context'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Match context'), findsOneWidget);

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
    await _openFixture(tester, 'Brazil vs Morocco');
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

Future<void> _openFixture(WidgetTester tester, String label) async {
  final scrollable = find.byType(Scrollable).last;
  await tester.scrollUntilVisible(
    find.text(label),
    250,
    scrollable: scrollable,
  );
  final card = find.ancestor(
    of: find.text(label),
    matching: find.byType(InkWell),
  );
  expect(card, findsWidgets);

  for (var attempt = 0; attempt < 8; attempt += 1) {
    final rect = tester.getRect(card.first);
    final viewportHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    const topChrome = 96.0;
    const bottomChrome = 120.0;

    if (rect.top < topChrome) {
      await tester.drag(scrollable, const Offset(0, 120));
      await tester.pumpAndSettle();
      continue;
    }

    if (rect.bottom > viewportHeight - bottomChrome) {
      await tester.drag(scrollable, const Offset(0, -120));
      await tester.pumpAndSettle();
      continue;
    }

    break;
  }

  await tester.tap(card.first);
  await tester.pumpAndSettle();
}
