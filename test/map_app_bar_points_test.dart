import 'package:balanco_game/features/map/widgets/map_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows total points independently from the coin balance', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MapAppBar(
            highestLevel: 2,
            coins: 5000,
            totalPoints: 3,
            moneyCents: 500,
            sparks: 5,
          ),
        ),
      ),
    );

    expect(find.text('3 PTS'), findsWidgets);
    expect(find.text('5K'), findsWidgets);
    expect(find.text('\$5.00'), findsWidgets);
  });
}
