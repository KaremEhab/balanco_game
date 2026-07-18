class RaceMatchClockState {
  const RaceMatchClockState({
    required this.elapsed,
    required this.countdownSeconds,
  });

  final Duration elapsed;
  final double countdownSeconds;
}

/// Allows exactly one timeout submission while still permitting a retry when
/// another room action was already in flight or the network request failed.
class RaceTimeoutSubmissionGuard {
  static const maxFailures = 3;

  bool _submitted = false;
  int _failures = 0;
  DateTime? _retryAt;

  int get failures => _failures;
  bool get exhausted => _failures >= maxFailures;

  bool take({
    required bool isRoomActive,
    required Duration elapsed,
    required double limitSeconds,
    DateTime? now,
  }) {
    final checkedAt = (now ?? DateTime.now()).toUtc();
    if (_submitted ||
        exhausted ||
        !isRoomActive ||
        limitSeconds <= 0 ||
        (_retryAt?.isAfter(checkedAt) ?? false)) {
      return false;
    }
    final limit = Duration(
      microseconds: (limitSeconds * Duration.microsecondsPerSecond).round(),
    );
    if (elapsed < limit) return false;
    _submitted = true;
    return true;
  }

  void defer(DateTime now, {Duration delay = const Duration(seconds: 1)}) {
    _submitted = false;
    _retryAt = now.toUtc().add(delay);
  }

  /// Returns true while another bounded retry remains.
  bool recordFailure(DateTime now) {
    _failures += 1;
    _submitted = false;
    if (exhausted) return false;
    final delay = Duration(seconds: 1 << (_failures - 1));
    _retryAt = now.toUtc().add(delay);
    return true;
  }

  void reset() {
    _submitted = false;
    _failures = 0;
    _retryAt = null;
  }
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
