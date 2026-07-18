import 'package:balanco_game/features/auth/presentation/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('signup collects the player profile fields and shows bonuses', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

    expect(find.text('WELCOME BACK!'), findsOneWidget);
    expect(find.text('GOOGLE'), findsOneWidget);
    expect(find.text('APPLE'), findsOneWidget);
    expect(find.text('OR USE EMAIL'), findsOneWidget);
    await tester.tap(find.text('SIGN UP'));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('CREATE YOUR HERO'), findsOneWidget);
    expect(find.text('DISPLAY NAME'), findsOneWidget);
    expect(find.text('USERNAME'), findsOneWidget);
    expect(find.text('AGE'), findsOneWidget);
    expect(
      find.text('Start with 5,000 coins, \$5.00 and 5 daily sparks'),
      findsOneWidget,
    );
  });
}
