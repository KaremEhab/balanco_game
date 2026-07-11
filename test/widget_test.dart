import 'package:balanco_game/main.dart';
import 'package:balanco_game/features/home/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the Balanco splash screen', (tester) async {
    await tester.pumpWidget(const BalancoApp());

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
