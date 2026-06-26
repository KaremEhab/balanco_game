import 'package:balanco_game/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the Balanco splash screen', (tester) async {
    await tester.pumpWidget(const BalancoApp(isFirstOpen: true));

    expect(find.text('Balanco'), findsOneWidget);
    expect(find.text('QUIET LUXURY ARCADE'), findsOneWidget);
  });
}
