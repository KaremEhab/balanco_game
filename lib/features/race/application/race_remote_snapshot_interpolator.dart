import 'dart:math' as math;

import 'package:flutter/foundation.dart';

class RaceRemoteBallRenderState {
  const RaceRemoteBallRenderState({
    required this.x,
    required this.y,
    required this.scale,
    required this.dead,
    this.velocityX = 0,
    this.velocityY = 0,
    this.airborne = false,
  });

  final double x;
  final double y;
  final double scale;
  final bool dead;
  final double velocityX;
  final double velocityY;
  final bool airborne;
}

class RaceRemoteRenderState {
  const RaceRemoteRenderState({
    required this.worldWidth,
    required this.worldHeight,
    this.levelHeight,
    this.barBottomY,
    required this.leftY,
    required this.rightY,
    required this.shieldTime,
    required this.balls,
  });

  final double worldWidth;
  final double worldHeight;
  final double? levelHeight;
  final double? barBottomY;
  final double leftY;
  final double rightY;
  final double shieldTime;
  final List<RaceRemoteBallRenderState> balls;

  /// Converts a coordinate sent by another device into this device's race
  /// world. Race levels are authored in normalized coordinates, so both axes
  /// must be scaled; keeping the sender's raw Y value makes players start at
  /// different heights whenever their playable viewports differ.
  double localX(double remoteX, double localWorldWidth) =>
      remoteX * localWorldWidth / worldWidth;

  double localY(
    double remoteY,
    double localWorldHeight, {
    double? localBarBottomY,
  }) {
    final remoteBottom = barBottomY;
    if (remoteBottom != null &&
        localBarBottomY != null &&
        remoteBottom > 70 &&
        localBarBottomY > 70) {
      // Fixed HUD/safe-area insets do not scale with viewport height. Map
      // against the actual playable track so every device agrees on both the
      // starting bar and each player's relative progress to the finish gate.
      const finishY = 70.0;
      final progressFromFinish = (remoteY - finishY) / (remoteBottom - finishY);
      return finishY + progressFromFinish * (localBarBottomY - finishY);
    }
    return remoteY * localWorldHeight / worldHeight;
  }
}

/// Buffers incoming Race snapshots and renders slightly behind the network.
/// This keeps a 60 FPS ghost moving between 15–30 Hz Supabase broadcasts.
class RaceRemoteSnapshotInterpolator extends ChangeNotifier {
  RaceRemoteSnapshotInterpolator({
    this.interpolationDelay = const Duration(milliseconds: 100),
    this.maximumExtrapolation = const Duration(milliseconds: 450),
  });

  final Duration interpolationDelay;
  final Duration maximumExtrapolation;
  final List<_RaceSnapshot> _snapshots = [];
  int _latestSequence = -1;
  double? _clockOffsetMicros;
  String? _streamKey;

  @visibleForTesting
  int get snapshotCount => _snapshots.length;

  void addSnapshot(Map<String, dynamic> payload, {int? arrivalMicros}) {
    final attempt = (payload['attempt'] as num?)?.toInt();
    final level = (payload['level'] as num?)?.toInt();
    final streamId = (payload['stream_id'] as String?)?.trim();
    final nextStreamKey =
        '${attempt ?? -1}:${level ?? -1}:${streamId?.isNotEmpty == true ? streamId : 'legacy'}';
    if (_streamKey != null && _streamKey != nextStreamKey) {
      _clearBuffer();
    }
    _streamKey = nextStreamKey;

    final sequence = (payload['sequence'] as num?)?.toInt() ?? 0;
    final sentAt = (payload['sent_at'] as num?)?.toInt();
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
    _streamKey = null;
    _clearBuffer();
    notifyListeners();
  }

  void _clearBuffer() {
    _snapshots.clear();
    _latestSequence = -1;
    _clockOffsetMicros = null;
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
          velocityX: ballA.velocityX + (ballB.velocityX - ballA.velocityX) * t,
          velocityY: ballA.velocityY + (ballB.velocityY - ballA.velocityY) * t,
          airborne: t < 0.5 ? ballA.airborne : ballB.airborne,
        ),
      );
    }

    return RaceRemoteRenderState(
      worldWidth: b.worldWidth,
      worldHeight: b.worldHeight,
      levelHeight: b.levelHeight,
      barBottomY: b.barBottomY,
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
          velocityX: current.velocityX,
          velocityY: current.velocityY,
          airborne: current.airborne,
        ),
      );
    }

    return RaceRemoteRenderState(
      worldWidth: latest.worldWidth,
      worldHeight: latest.worldHeight,
      levelHeight: latest.levelHeight,
      barBottomY: latest.barBottomY,
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
    required this.velocityX,
    required this.velocityY,
    required this.airborne,
  });

  final double x;
  final double y;
  final double scale;
  final bool dead;
  final double velocityX;
  final double velocityY;
  final bool airborne;
}

class _RaceSnapshot {
  const _RaceSnapshot({
    required this.sentAtMicros,
    required this.arrivalMicros,
    required this.worldWidth,
    required this.worldHeight,
    required this.levelHeight,
    required this.barBottomY,
    required this.leftY,
    required this.rightY,
    required this.shieldTime,
    required this.balls,
  });

  final int sentAtMicros;
  final int arrivalMicros;
  final double worldWidth;
  final double worldHeight;
  final double? levelHeight;
  final double? barBottomY;
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
      final airborne =
          (ball['is_free_falling'] as bool? ?? false) ||
          (ball['is_falling'] as bool? ?? false);
      balls.add(
        _RaceBallSnapshot(
          x: x,
          y: y,
          scale: (ball['scale'] as num?)?.toDouble() ?? 1,
          dead: ball['is_dead'] as bool? ?? false,
          velocityX: airborne
              ? (ball['free_fall_x'] as num?)?.toDouble() ?? 0
              : (ball['velocity'] as num?)?.toDouble() ?? 0,
          velocityY: airborne
              ? (ball['free_fall_y'] as num?)?.toDouble() ?? 0
              : 0,
          airborne: airborne,
        ),
      );
    }
    return _RaceSnapshot(
      sentAtMicros: sentAt,
      arrivalMicros: arrivalMicros,
      worldWidth: width,
      worldHeight: height,
      levelHeight: (payload['level_height'] as num?)?.toDouble(),
      barBottomY: (payload['bar_bottom_y'] as num?)?.toDouble(),
      leftY: left,
      rightY: right,
      shieldTime: (payload['shield_time'] as num?)?.toDouble() ?? 0,
      balls: balls,
    );
  }

  RaceRemoteRenderState toRenderState() => RaceRemoteRenderState(
    worldWidth: worldWidth,
    worldHeight: worldHeight,
    levelHeight: levelHeight,
    barBottomY: barBottomY,
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
            velocityX: ball.velocityX,
            velocityY: ball.velocityY,
            airborne: ball.airborne,
          ),
        )
        .toList(growable: false),
  );
}
