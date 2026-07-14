class RaceMatchClockState {
  const RaceMatchClockState({
    required this.elapsed,
    required this.countdownSeconds,
  });

  final Duration elapsed;
  final double countdownSeconds;
}

/// A local presentation clock driven by the authoritative room state.
///
/// Paused and leave-vote time is removed from both the countdown and elapsed
/// race time, so both devices freeze at the same room transition.
class RaceMatchClock {
  RaceMatchClock({this.countdown = const Duration(seconds: 4)});

  final Duration countdown;
  DateTime? _startedAt;
  DateTime? _frozenAt;
  Duration _completedFrozenTime = Duration.zero;

  void reset() {
    _startedAt = null;
    _frozenAt = null;
    _completedFrozenTime = Duration.zero;
  }

  RaceMatchClockState update({
    required DateTime? startedAt,
    required bool running,
    required DateTime now,
  }) {
    final normalizedStart = startedAt?.toUtc();
    final normalizedNow = now.toUtc();
    if (normalizedStart != _startedAt) {
      _startedAt = normalizedStart;
      _frozenAt = null;
      _completedFrozenTime = Duration.zero;
    }
    if (normalizedStart == null) {
      return const RaceMatchClockState(
        elapsed: Duration.zero,
        countdownSeconds: 0,
      );
    }

    if (running) {
      final frozenAt = _frozenAt;
      if (frozenAt != null) {
        _completedFrozenTime += normalizedNow.difference(frozenAt);
        _frozenAt = null;
      }
    } else {
      _frozenAt ??= normalizedNow;
    }

    final clockNow = _frozenAt ?? normalizedNow;
    final effectiveGoAt = normalizedStart
        .add(countdown)
        .add(_completedFrozenTime);
    final remaining = effectiveGoAt.difference(clockNow);
    if (remaining > Duration.zero) {
      return RaceMatchClockState(
        elapsed: Duration.zero,
        countdownSeconds:
            remaining.inMicroseconds / Duration.microsecondsPerSecond,
      );
    }
    return RaceMatchClockState(
      elapsed: clockNow.difference(effectiveGoAt),
      countdownSeconds: 0,
    );
  }
}
