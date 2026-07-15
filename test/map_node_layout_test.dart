import 'package:balanco_game/features/map/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('map creates all campaign nodes synchronously from level 1 to 500', () {
    const totalLevels = 500;
    const spacing = 180.0;
    const bottomPadding = 320.0;
    const topPadding = 140.0;
    const totalHeight = bottomPadding + topPadding + (totalLevels * spacing);

    final nodes = computeMapNodePositions(
      totalLevels: totalLevels,
      totalHeight: totalHeight,
      bottomPadding: bottomPadding,
      nodeSpacingY: spacing,
      centerX: 200,
    );

    expect(nodes, hasLength(totalLevels));
    expect(nodes.first.dx, 200);
    expect(nodes.first.dy, greaterThan(nodes.last.dy));
    expect(nodes.last.dy, greaterThanOrEqualTo(bottomPadding - spacing));
  });

  testWidgets('home map paints level nodes on its first layout', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(scrollController: controller)),
    );
    await tester.pump();

    expect(find.byType(AnimatedLevelNode), findsWidgets);
    final firstLevel = tester
        .widgetList<AnimatedLevelNode>(find.byType(AnimatedLevelNode))
        .firstWhere((node) => node.level == 1);
    expect(firstLevel.isUnlocked, isTrue);
  });
}
