import 'package:balanco_game/features/race/application/race_remote_snapshot_interpolator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> snapshot({
    required int sequence,
    required int sentAt,
    required double x,
    required double y,
    String streamId = 'stream-a',
    int attempt = 1,
    int level = 1,
  }) => {
    'sequence': sequence,
    'sent_at': sentAt,
    'stream_id': streamId,
    'attempt': attempt,
    'level': level,
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

  test('accepts a restarted sender sequence in a new stream', () {
    final interpolator = RaceRemoteSnapshotInterpolator();
    const base = 5000000;
    interpolator.addSnapshot(
      snapshot(sequence: 90, sentAt: base, x: 90, y: 100),
      arrivalMicros: base,
    );
    interpolator.addSnapshot(
      snapshot(
        sequence: 1,
        sentAt: base + 100000,
        x: 5,
        y: 100,
        streamId: 'stream-after-reconnect',
      ),
      arrivalMicros: base + 100000,
    );

    expect(interpolator.snapshotCount, 1);
    expect(interpolator.sample(nowMicros: base + 100000)!.balls.single.x, 5);
  });

  test('accepts sequence reset when a later race attempt starts', () {
    final interpolator = RaceRemoteSnapshotInterpolator();
    const base = 6000000;
    interpolator.addSnapshot(
      snapshot(sequence: 40, sentAt: base, x: 40, y: 100),
      arrivalMicros: base,
    );
    interpolator.addSnapshot(
      snapshot(sequence: 1, sentAt: base + 100000, x: 2, y: 100, attempt: 2),
      arrivalMicros: base + 100000,
    );

    expect(interpolator.snapshotCount, 1);
    expect(interpolator.sample(nowMicros: base + 100000)!.balls.single.x, 2);
  });

  test('maps both axes relative to different device viewport sizes', () {
    const state = RaceRemoteRenderState(
      worldWidth: 400,
      worldHeight: 800,
      leftY: 680,
      rightY: 680,
      shieldTime: 0,
      balls: [],
    );

    expect(state.localX(200, 300), 150);
    expect(state.localY(680, 1000), 850);
    expect(state.localY(660, 1000), 825);
  });

  test('maps a long race track using the real start and finish points', () {
    const state = RaceRemoteRenderState(
      worldWidth: 400,
      worldHeight: 800,
      levelHeight: 2400,
      barBottomY: 2280,
      leftY: 2280,
      rightY: 2280,
      shieldTime: 0,
      balls: [],
    );

    expect(state.localY(70, 1000, localBarBottomY: 2860), 70);
    expect(state.localY(2280, 1000, localBarBottomY: 2860), 2860);
    expect(
      state.localY(1175, 1000, localBarBottomY: 2860),
      closeTo(1465, 0.001),
    );
  });
}
