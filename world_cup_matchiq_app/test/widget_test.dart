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
}
