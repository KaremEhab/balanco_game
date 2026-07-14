import 'package:balanco_game/features/race/application/race_match_clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pause freezes elapsed time and removes the paused duration', () {
    final clock = RaceMatchClock(countdown: const Duration(seconds: 4));
    final startedAt = DateTime.utc(2026, 7, 15, 10);

    final beforePause = clock.update(
      startedAt: startedAt,
      running: true,
      now: startedAt.add(const Duration(seconds: 9)),
    );
    final paused = clock.update(
      startedAt: startedAt,
      running: false,
      now: startedAt.add(const Duration(seconds: 10)),
    );
    final stillPaused = clock.update(
      startedAt: startedAt,
      running: false,
      now: startedAt.add(const Duration(seconds: 40)),
    );
    final resumed = clock.update(
      startedAt: startedAt,
      running: true,
      now: startedAt.add(const Duration(seconds: 41)),
    );

    expect(beforePause.elapsed, const Duration(seconds: 5));
    expect(paused.elapsed, const Duration(seconds: 6));
    expect(stillPaused.elapsed, paused.elapsed);
    expect(resumed.elapsed, const Duration(seconds: 6));
  });

  test('pause also freezes the synchronized countdown', () {
    final clock = RaceMatchClock(countdown: const Duration(seconds: 4));
    final startedAt = DateTime.utc(2026, 7, 15, 10);

    final paused = clock.update(
      startedAt: startedAt,
      running: false,
      now: startedAt.add(const Duration(seconds: 1)),
    );
    final later = clock.update(
      startedAt: startedAt,
      running: false,
      now: startedAt.add(const Duration(seconds: 30)),
    );
    final resumed = clock.update(
      startedAt: startedAt,
      running: true,
      now: startedAt.add(const Duration(seconds: 31)),
    );

    expect(paused.countdownSeconds, 3);
    expect(later.countdownSeconds, 3);
    expect(resumed.countdownSeconds, 3);
  });
}
