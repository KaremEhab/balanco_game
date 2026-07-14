import 'package:balanco_game/features/race/application/race_remote_snapshot_interpolator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> snapshot({
    required int sequence,
    required int sentAt,
    required double x,
    required double y,
  }) => {
    'sequence': sequence,
    'sent_at': sentAt,
    'world_width': 400.0,
    'world_height': 700.0,
    'left_y': y + 20,
    'right_y': y + 30,
    'shield_time': 0.0,
    'balls': [
      {'x': x, 'y': y, 'scale': 1.0, 'is_dead': false},
    ],
  };

  test('renders between buffered snapshots instead of stepping', () {
    final interpolator = RaceRemoteSnapshotInterpolator();
    const base = 1000000;
    interpolator.addSnapshot(
      snapshot(sequence: 1, sentAt: base, x: 0, y: 100),
      arrivalMicros: base,
    );
    interpolator.addSnapshot(
      snapshot(sequence: 2, sentAt: base + 100000, x: 10, y: 120),
      arrivalMicros: base + 100000,
    );

    final state = interpolator.sample(nowMicros: base + 150000)!;

    expect(state.balls.single.x, closeTo(5, 0.001));
    expect(state.balls.single.y, closeTo(110, 0.001));
    expect(state.leftY, closeTo(130, 0.001));
  });

  test('caps late-packet extrapolation at 220 milliseconds', () {
    final interpolator = RaceRemoteSnapshotInterpolator(
      interpolationDelay: Duration.zero,
    );
    const base = 2000000;
    interpolator.addSnapshot(
      snapshot(sequence: 1, sentAt: base, x: 0, y: 100),
      arrivalMicros: base,
    );
    interpolator.addSnapshot(
      snapshot(sequence: 2, sentAt: base + 100000, x: 10, y: 100),
      arrivalMicros: base + 100000,
    );

    final state = interpolator.sample(nowMicros: base + 600000)!;

    expect(state.balls.single.x, greaterThan(10));
    expect(state.balls.single.x, lessThan(30));
  });

  test(
    'smooths changing packet latency without moving the timeline backward',
    () {
      final interpolator = RaceRemoteSnapshotInterpolator();
      const base = 4000000;
      interpolator.addSnapshot(
        snapshot(sequence: 1, sentAt: base, x: 0, y: 100),
        arrivalMicros: base + 80000,
      );
      interpolator.addSnapshot(
        snapshot(sequence: 2, sentAt: base + 100000, x: 10, y: 100),
        arrivalMicros: base + 240000,
      );

      final first = interpolator.sample(nowMicros: base + 250000)!;
      final next = interpolator.sample(nowMicros: base + 266000)!;

      expect(next.balls.single.x, greaterThanOrEqualTo(first.balls.single.x));
    },
  );

  test('discards duplicate packets and bounds the snapshot buffer', () {
    final interpolator = RaceRemoteSnapshotInterpolator();
    const base = 3000000;
    for (var index = 1; index <= 50; index++) {
      interpolator.addSnapshot(
        snapshot(
          sequence: index,
          sentAt: base + index * 20000,
          x: index.toDouble(),
          y: 100,
        ),
        arrivalMicros: base + index * 20000,
      );
    }
    interpolator.addSnapshot(
      snapshot(sequence: 50, sentAt: base + 2000000, x: 999, y: 100),
      arrivalMicros: base + 2000000,
    );

    expect(interpolator.snapshotCount, 40);
  });
}
