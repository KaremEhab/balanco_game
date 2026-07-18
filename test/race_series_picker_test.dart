import 'dart:async';

import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('race range sheet closes without leaving overlay dependents', (
    tester,
  ) async {
    List<int>? selected;
    tester.view.physicalSize = const Size(390, 520);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () {
                unawaited(
                  showModalBottomSheet<List<int>>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => const RaceSeriesPicker(
                      initialStart: 1,
                      initialEnd: 5,
                      highestLevel: 10,
                    ),
                  ).then((value) => selected = value),
                );
              },
              child: const Text('OPEN'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('race-series-range-slider')), findsOneWidget);

    // Reproduce the real drag pattern that previously created duplicate
    // AnimatedSwitcher keys: odd -> even -> odd before 180ms elapsed.
    var slider = tester.widget<RangeSlider>(
      find.byKey(const Key('race-series-range-slider')),
    );
    slider.onChanged!(const RangeValues(1, 6));
    await tester.pump(const Duration(milliseconds: 20));
    slider = tester.widget<RangeSlider>(
      find.byKey(const Key('race-series-range-slider')),
    );
    slider.onChanged!(const RangeValues(1, 5));
    await tester.pump(const Duration(milliseconds: 20));

    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byKey(const Key('save-race-series-range')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-race-series-range')));
    await tester.pumpAndSettle();

    expect(selected, [1, 5]);
    expect(tester.takeException(), isNull);
  });
}
