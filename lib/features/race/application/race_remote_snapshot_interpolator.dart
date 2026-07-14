import 'dart:math' as math;

import 'package:flutter/foundation.dart';

class RaceRemoteBallRenderState {
  const RaceRemoteBallRenderState({
    required this.x,
    required this.y,
    required this.scale,
    required this.dead,
  });

  final double x;
  final double y;
  final double scale;
  final bool dead;
}

class RaceRemoteRenderState {
  const RaceRemoteRenderState({
    required this.worldWidth,
    required this.worldHeight,
    required this.leftY,
    required this.rightY,
    required this.shieldTime,
    required this.balls,
  });

  final double worldWidth;
  final double worldHeight;
  final double leftY;
  final double rightY;
  final double shieldTime;
  final List<RaceRemoteBallRenderState> balls;
}

/// Buffers incoming Race snapshots and renders slightly behind the network.
/// This keeps a 60 FPS ghost moving between 15–30 Hz Supabase broadcasts.
class RaceRemoteSnapshotInterpolator extends ChangeNotifier {
  RaceRemoteSnapshotInterpolator({
    this.interpolationDelay = const Duration(milliseconds: 100),
    this.maximumExtrapolation = const Duration(milliseconds: 220),
  });

  final Duration interpolationDelay;
  final Duration maximumExtrapolation;
  final List<_RaceSnapshot> _snapshots = [];
  int _latestSequence = -1;
  double? _clockOffsetMicros;

  @visibleForTesting
  int get snapshotCount => _snapshots.length;

  void addSnapshot(Map<String, dynamic> payload, {int? arrivalMicros}) {
    final sequence = payload['sequence'] as int? ?? 0;
    final sentAt = payload['sent_at'] as int?;
    if (sentAt == null || sequence <= _latestSequence) return;

    final snapshot = _RaceSnapshot.fromPayload(
      payload,
      arrivalMicros: arrivalMicros ?? DateTime.now().microsecondsSinceEpoch,
    );
    if (snapshot == null) return;
    final observedOffset = (arrivalMicros ?? snapshot.arrivalMicros) - sentAt;
    final currentOffset = _clockOffsetMicros;
    if (currentOffset == null) {
      _clockOffsetMicros = observedOffset.toDouble();
    } else {
      // Follow faster packets quickly and slower/jittery packets gently. This
      // prevents the render timeline from jumping every time network latency
      // changes while still adapting to the other device's wall clock.
      final weight = observedOffset < currentOffset ? 0.22 : 0.035;
      _clockOffsetMicros =
          currentOffset + (observedOffset - currentOffset) * weight;
    }
    _latestSequence = sequence;
    _snapshots.add(snapshot);

    final oldestAllowed = sentAt - const Duration(seconds: 2).inMicroseconds;
    _snapshots.removeWhere((entry) => entry.sentAtMicros < oldestAllowed);
    if (_snapshots.length > 40) {
      _snapshots.removeRange(0, _snapshots.length - 40);
    }
    notifyListeners();
  }

  RaceRemoteRenderState? sample({int? nowMicros}) {
    if (_snapshots.isEmpty) return null;
    if (_snapshots.length == 1) return _snapshots.single.toRenderState();

    final now = nowMicros ?? DateTime.now().microsecondsSinceEpoch;
    final senderNow = now - (_clockOffsetMicros ?? 0).round();
    final target = senderNow - interpolationDelay.inMicroseconds;

    if (target <= _snapshots.first.sentAtMicros) {
      return _snapshots.first.toRenderState();
    }

    for (var index = 1; index < _snapshots.length; index++) {
      final next = _snapshots[index];
      if (next.sentAtMicros < target) continue;
      final previous = _snapshots[index - 1];
      final beforePrevious = index >= 2 ? _snapshots[index - 2] : null;
      final afterNext = index + 1 < _snapshots.length
          ? _snapshots[index + 1]
          : null;
      return _interpolate(
        previous,
        next,
        target,
        beforePrevious: beforePrevious,
        afterNext: afterNext,
      );
    }

    return _extrapolate(target);
  }

  void clear() {
    _snapshots.clear();
    _latestSequence = -1;
    _clockOffsetMicros = null;
    notifyListeners();
  }

  RaceRemoteRenderState _interpolate(
    _RaceSnapshot a,
    _RaceSnapshot b,
    int target, {
    _RaceSnapshot? beforePrevious,
    _RaceSnapshot? afterNext,
  }) {
    final durationMicros = b.sentAtMicros - a.sentAtMicros;
    if (durationMicros <= 0) return b.toRenderState();
    final durationSeconds = durationMicros / Duration.microsecondsPerSecond;
    final t = ((target - a.sentAtMicros) / durationMicros).clamp(0.0, 1.0);

    double value(
      double p0,
      double p1,
      double? before,
      double? after,
      int? beforeTime,
      int? afterTime,
    ) {
      final fallbackVelocity = (p1 - p0) / durationSeconds;
      final v0 = before != null && beforeTime != null
          ? (p1 - before) /
                ((b.sentAtMicros - beforeTime) / Duration.microsecondsPerSecond)
          : fallbackVelocity;
      final v1 = after != null && afterTime != null
          ? (after - p0) /
                ((afterTime - a.sentAtMicros) / Duration.microsecondsPerSecond)
          : fallbackVelocity;
      final interpolated = hermite(
        p0: p0,
        v0: v0,
        p1: p1,
        v1: v1,
        t: t,
        durationSeconds: durationSeconds,
      );
      return interpolated.clamp(math.min(p0, p1), math.max(p0, p1));
    }

    final ballCount = math.max(a.balls.length, b.balls.length);
    final balls = <RaceRemoteBallRenderState>[];
    for (var index = 0; index < ballCount; index++) {
      final ballA = index < a.balls.length ? a.balls[index] : b.balls[index];
      final ballB = index < b.balls.length ? b.balls[index] : ballA;
      final ballBefore =
          beforePrevious != null && index < beforePrevious.balls.length
          ? beforePrevious.balls[index]
          : null;
      final ballAfter = afterNext != null && index < afterNext.balls.length
          ? afterNext.balls[index]
          : null;
      balls.add(
        RaceRemoteBallRenderState(
          x: value(
            ballA.x,
            ballB.x,
            ballBefore?.x,
            ballAfter?.x,
            beforePrevious?.sentAtMicros,
            afterNext?.sentAtMicros,
          ),
          y: value(
            ballA.y,
            ballB.y,
            ballBefore?.y,
            ballAfter?.y,
            beforePrevious?.sentAtMicros,
            afterNext?.sentAtMicros,
          ),
          scale: ballA.scale + (ballB.scale - ballA.scale) * t,
          dead: t < 0.5 ? ballA.dead : ballB.dead,
        ),
      );
    }

    return RaceRemoteRenderState(
      worldWidth: b.worldWidth,
      worldHeight: b.worldHeight,
      leftY: value(
        a.leftY,
        b.leftY,
        beforePrevious?.leftY,
        afterNext?.leftY,
        beforePrevious?.sentAtMicros,
        afterNext?.sentAtMicros,
      ),
      rightY: value(
        a.rightY,
        b.rightY,
        beforePrevious?.rightY,
        afterNext?.rightY,
        beforePrevious?.sentAtMicros,
        afterNext?.sentAtMicros,
      ),
      shieldTime: a.shieldTime + (b.shieldTime - a.shieldTime) * t,
      balls: balls,
    );
  }

  RaceRemoteRenderState _extrapolate(int target) {
    final latest = _snapshots.last;
    final previous = _snapshots[_snapshots.length - 2];
    final interval =
        (latest.sentAtMicros - previous.sentAtMicros) /
        Duration.microsecondsPerSecond;
    if (interval <= 0) return latest.toRenderState();
    final elapsed =
        ((target - latest.sentAtMicros) / Duration.microsecondsPerSecond).clamp(
          0.0,
          maximumExtrapolation.inMilliseconds / 1000,
        );
    final dampedTime = (1 - math.exp(-1.5 * elapsed)) / 1.5;

    double extrapolate(double oldValue, double currentValue) =>
        currentValue + ((currentValue - oldValue) / interval) * dampedTime;

    final balls = <RaceRemoteBallRenderState>[];
    for (var index = 0; index < latest.balls.length; index++) {
      final current = latest.balls[index];
      final old = index < previous.balls.length
          ? previous.balls[index]
          : current;
      balls.add(
        RaceRemoteBallRenderState(
          x: extrapolate(old.x, current.x),
          y: extrapolate(old.y, current.y),
          scale: current.scale,
          dead: current.dead,
        ),
      );
    }

    return RaceRemoteRenderState(
      worldWidth: latest.worldWidth,
      worldHeight: latest.worldHeight,
      leftY: extrapolate(previous.leftY, latest.leftY),
      rightY: extrapolate(previous.rightY, latest.rightY),
      shieldTime: latest.shieldTime,
      balls: balls,
    );
  }

  @visibleForTesting
  static double hermite({
    required double p0,
    required double v0,
    required double p1,
    required double v1,
    required double t,
    required double durationSeconds,
  }) {
    final t2 = t * t;
    final t3 = t2 * t;
    final h00 = 2 * t3 - 3 * t2 + 1;
    final h10 = t3 - 2 * t2 + t;
    final h01 = -2 * t3 + 3 * t2;
    final h11 = t3 - t2;
    return h00 * p0 +
        h10 * v0 * durationSeconds +
        h01 * p1 +
        h11 * v1 * durationSeconds;
  }
}

class _RaceBallSnapshot {
  const _RaceBallSnapshot({
    required this.x,
    required this.y,
    required this.scale,
    required this.dead,
  });

  final double x;
  final double y;
  final double scale;
  final bool dead;
}

class _RaceSnapshot {
  const _RaceSnapshot({
    required this.sentAtMicros,
    required this.arrivalMicros,
    required this.worldWidth,
    required this.worldHeight,
    required this.leftY,
    required this.rightY,
    required this.shieldTime,
    required this.balls,
  });

  final int sentAtMicros;
  final int arrivalMicros;
  final double worldWidth;
  final double worldHeight;
  final double leftY;
  final double rightY;
  final double shieldTime;
  final List<_RaceBallSnapshot> balls;

  static _RaceSnapshot? fromPayload(
    Map<String, dynamic> payload, {
    required int arrivalMicros,
  }) {
    final sentAt = payload['sent_at'] as int?;
    final width = (payload['world_width'] as num?)?.toDouble();
    final height = (payload['world_height'] as num?)?.toDouble();
    final left = (payload['left_y'] as num?)?.toDouble();
    final right = (payload['right_y'] as num?)?.toDouble();
    if (sentAt == null ||
        width == null ||
        height == null ||
        width <= 0 ||
        height <= 0 ||
        left == null ||
        right == null) {
      return null;
    }
    final balls = <_RaceBallSnapshot>[];
    for (final raw in payload['balls'] as List? ?? const []) {
      final ball = Map<String, dynamic>.from(raw as Map);
      final x = (ball['x'] as num?)?.toDouble();
      final y = (ball['y'] as num?)?.toDouble();
      if (x == null || y == null) continue;
      balls.add(
        _RaceBallSnapshot(
          x: x,
          y: y,
          scale: (ball['scale'] as num?)?.toDouble() ?? 1,
          dead: ball['is_dead'] as bool? ?? false,
        ),
      );
    }
    return _RaceSnapshot(
      sentAtMicros: sentAt,
      arrivalMicros: arrivalMicros,
      worldWidth: width,
      worldHeight: height,
      leftY: left,
      rightY: right,
      shieldTime: (payload['shield_time'] as num?)?.toDouble() ?? 0,
      balls: balls,
    );
  }

  RaceRemoteRenderState toRenderState() => RaceRemoteRenderState(
    worldWidth: worldWidth,
    worldHeight: worldHeight,
    leftY: leftY,
    rightY: rightY,
    shieldTime: shieldTime,
    balls: balls
        .map(
          (ball) => RaceRemoteBallRenderState(
            x: ball.x,
            y: ball.y,
            scale: ball.scale,
            dead: ball.dead,
          ),
        )
        .toList(growable: false),
  );
}
