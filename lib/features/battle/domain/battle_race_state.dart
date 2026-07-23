enum BattlePlayerPhase {
  countdown,
  active,
  falling,
  respawnDelay,
  resettingBar,
  droppingBall,
  stabilizing,
  spawnProtection,
  finished,
  disconnected,
}

enum BattleWeaponTarget { self, opponent, worldPosition, proximity, projectile }

class BattleWeaponDefinition {
  const BattleWeaponDefinition({
    required this.id,
    required this.name,
    required this.target,
    required this.cooldownSeconds,
    required this.warningSeconds,
    required this.activeSeconds,
    required this.force,
    required this.rangeInBallDiameters,
    required this.blockedByShield,
    required this.reflectedByCounter,
    required this.allowedNearCheckpoint,
    required this.allowedNearFinish,
  });

  final String id;
  final String name;
  final BattleWeaponTarget target;
  final double cooldownSeconds;
  final double warningSeconds;
  final double activeSeconds;
  final double force;
  final double rangeInBallDiameters;
  final bool blockedByShield;
  final bool reflectedByCounter;
  final bool allowedNearCheckpoint;
  final bool allowedNearFinish;
}

abstract final class BattleWeaponCatalog {
  static const heatWave = BattleWeaponDefinition(
    id: 'heat_wave',
    name: 'Heat Wave',
    target: BattleWeaponTarget.opponent,
    cooldownSeconds: 6,
    warningSeconds: 0.25,
    activeSeconds: 0.55,
    force: 390,
    rangeInBallDiameters: 99,
    blockedByShield: true,
    reflectedByCounter: false,
    allowedNearCheckpoint: false,
    allowedNearFinish: false,
  );

  static const rocket = BattleWeaponDefinition(
    id: 'battle_rocket',
    name: 'Rocket',
    target: BattleWeaponTarget.opponent,
    cooldownSeconds: 1.1,
    warningSeconds: 0.35,
    activeSeconds: 0.25,
    force: 560,
    rangeInBallDiameters: 99,
    blockedByShield: true,
    reflectedByCounter: false,
    allowedNearCheckpoint: false,
    allowedNearFinish: false,
  );

  static const bomb = BattleWeaponDefinition(
    id: 'battle_bomb',
    name: 'Bomb',
    target: BattleWeaponTarget.opponent,
    cooldownSeconds: 1.5,
    warningSeconds: 0.65,
    activeSeconds: 0.35,
    force: 650,
    rangeInBallDiameters: 99,
    blockedByShield: true,
    reflectedByCounter: false,
    allowedNearCheckpoint: false,
    allowedNearFinish: false,
  );

  static const nails = BattleWeaponDefinition(
    id: 'battle_nails',
    name: 'Nail Burst',
    target: BattleWeaponTarget.opponent,
    cooldownSeconds: 0.9,
    warningSeconds: 0.18,
    activeSeconds: 0.45,
    force: 330,
    rangeInBallDiameters: 99,
    blockedByShield: true,
    reflectedByCounter: false,
    allowedNearCheckpoint: false,
    allowedNearFinish: false,
  );

  static const values = <BattleWeaponDefinition>[heatWave, rocket, bomb, nails];

  static BattleWeaponDefinition? fromId(String id) {
    for (final weapon in values) {
      if (weapon.id == id) return weapon;
    }
    return null;
  }

  static bool requiresPickup(String id) => id != heatWave.id;
}

class BattlePlayerState {
  BattlePlayerState({required this.playerId});

  final String playerId;

  BattlePlayerPhase phase = BattlePlayerPhase.countdown;
  double progress = 0;
  int checkpointIndex = 0;
  int respawnCount = 0;
  int knockoutCount = 0;

  double respawnTimer = 0;
  double stabilizationTimer = 0;
  double stabilizationElapsed = 0;
  double spawnProtectionTimer = 0;
  double attackCooldown = 0;
  double utilityCooldown = 0;
  double heatMeter = 0;
  double checkpointSafeTimer = 0;

  String? attackWeaponId = BattleWeaponCatalog.heatWave.id;
  String? utilityWeaponId = 'shield_dome';

  int _quickFallStreak = 0;
  final Map<String, List<String>> _weaponPickupKeys = {};

  bool get canMove =>
      phase == BattlePlayerPhase.active ||
      phase == BattlePlayerPhase.spawnProtection;

  bool get canAttack => phase == BattlePlayerPhase.active;

  bool get canReceiveAttack => phase == BattlePlayerPhase.active;

  bool get canCollect => phase == BattlePlayerPhase.active;

  bool get canFinish => phase == BattlePlayerPhase.active;

  bool get isRespawning => switch (phase) {
    BattlePlayerPhase.falling ||
    BattlePlayerPhase.respawnDelay ||
    BattlePlayerPhase.resettingBar ||
    BattlePlayerPhase.droppingBall ||
    BattlePlayerPhase.stabilizing => true,
    _ => false,
  };

  double get respawnDelaySeconds => switch (_quickFallStreak) {
    <= 1 => 1.25,
    2 => 1.60,
    3 => 2.00,
    _ => 2.60,
  };

  void startMatch() {
    if (phase == BattlePlayerPhase.countdown) {
      phase = BattlePlayerPhase.active;
    }
  }

  void reset() {
    phase = BattlePlayerPhase.countdown;
    progress = 0;
    checkpointIndex = 0;
    respawnCount = 0;
    knockoutCount = 0;
    respawnTimer = 0;
    stabilizationTimer = 0;
    stabilizationElapsed = 0;
    spawnProtectionTimer = 0;
    attackCooldown = 0;
    utilityCooldown = 0;
    heatMeter = 0;
    checkpointSafeTimer = 0;
    attackWeaponId = BattleWeaponCatalog.heatWave.id;
    utilityWeaponId = 'shield_dome';
    _quickFallStreak = 0;
    _weaponPickupKeys.clear();
  }

  void recordFall() {
    if (phase == BattlePlayerPhase.finished ||
        phase == BattlePlayerPhase.disconnected ||
        isRespawning) {
      return;
    }
    phase = BattlePlayerPhase.falling;
  }

  double beginRespawn() {
    respawnCount += 1;
    _quickFallStreak += 1;
    respawnTimer = respawnDelaySeconds;
    stabilizationTimer = 0;
    stabilizationElapsed = 0;
    spawnProtectionTimer = 0;
    phase = BattlePlayerPhase.respawnDelay;
    return respawnTimer;
  }

  void beginBallDrop() {
    phase = BattlePlayerPhase.droppingBall;
    respawnTimer = 0;
  }

  void beginStabilizing() {
    phase = BattlePlayerPhase.stabilizing;
    stabilizationTimer = 0;
    stabilizationElapsed = 0;
  }

  void tickStabilization(
    double dt, {
    required bool touchingOwnBar,
    required double linearSpeed,
    required double angularSpeed,
    double stableSpeedThreshold = 38,
    double stableAngularThreshold = 1.2,
  }) {
    if (phase != BattlePlayerPhase.stabilizing) return;
    stabilizationElapsed += dt;
    final stable =
        touchingOwnBar &&
        linearSpeed.abs() < stableSpeedThreshold &&
        angularSpeed.abs() < stableAngularThreshold;
    stabilizationTimer = stable ? stabilizationTimer + dt : 0;
    if (stabilizationTimer >= 0.25 || stabilizationElapsed >= 1.25) {
      phase = BattlePlayerPhase.spawnProtection;
      spawnProtectionTimer = 0.85;
      stabilizationTimer = 0;
    }
  }

  bool activateCheckpoint(int index) {
    if (index <= checkpointIndex) return false;
    checkpointIndex = index;
    _quickFallStreak = 0;
    checkpointSafeTimer = 0.75;
    return true;
  }

  bool canUseAttack(BattleWeaponDefinition weapon) {
    if (!canAttack ||
        attackCooldown > 0 ||
        (!weapon.allowedNearCheckpoint && checkpointSafeTimer > 0)) {
      return false;
    }
    return !BattleWeaponCatalog.requiresPickup(weapon.id) ||
        weaponCount(weapon.id) > 0;
  }

  bool useAttack(BattleWeaponDefinition weapon, {String? pickupKey}) {
    if (!canUseAttack(weapon)) return false;
    if (BattleWeaponCatalog.requiresPickup(weapon.id)) {
      final keys = _weaponPickupKeys[weapon.id];
      if (keys == null || keys.isEmpty || pickupKey == null) return false;
      if (!keys.remove(pickupKey)) return false;
    }
    attackWeaponId = weapon.id;
    attackCooldown = weapon.cooldownSeconds;
    return true;
  }

  bool collectWeapon(String weaponId, String pickupKey) {
    if (BattleWeaponCatalog.fromId(weaponId) == null ||
        !BattleWeaponCatalog.requiresPickup(weaponId)) {
      return false;
    }
    final keys = _weaponPickupKeys.putIfAbsent(weaponId, () => []);
    if (keys.contains(pickupKey)) return false;
    keys.add(pickupKey);
    return true;
  }

  int weaponCount(String weaponId) => _weaponPickupKeys[weaponId]?.length ?? 0;

  String? firstPickupKey(String weaponId) =>
      _weaponPickupKeys[weaponId]?.firstOrNull;

  Map<String, int> get weaponCounts => {
    for (final entry in _weaponPickupKeys.entries)
      entry.key: entry.value.length,
  };

  void addHeat(double amount) {
    heatMeter = (heatMeter + amount).clamp(0, 100);
  }

  void update(double dt) {
    if (dt <= 0) return;
    attackCooldown = (attackCooldown - dt).clamp(0, double.infinity);
    utilityCooldown = (utilityCooldown - dt).clamp(0, double.infinity);
    checkpointSafeTimer = (checkpointSafeTimer - dt).clamp(0, double.infinity);
    if (phase == BattlePlayerPhase.respawnDelay) {
      respawnTimer = (respawnTimer - dt).clamp(0, double.infinity);
      if (respawnTimer == 0) beginBallDrop();
    } else if (phase == BattlePlayerPhase.spawnProtection) {
      spawnProtectionTimer = (spawnProtectionTimer - dt).clamp(
        0,
        double.infinity,
      );
      if (spawnProtectionTimer == 0) phase = BattlePlayerPhase.active;
    }
  }

  Map<String, dynamic> toSnapshot() => {
    'phase': phase.name,
    'progress': progress,
    'checkpoint': checkpointIndex,
    'respawns': respawnCount,
    'knockouts': knockoutCount,
    'respawn_time': respawnTimer,
    'protection_time': spawnProtectionTimer,
    'attack_cooldown': attackCooldown,
    'weapons': weaponCounts,
    'heat': heatMeter,
    'checkpoint_safe_time': checkpointSafeTimer,
  };

  void applySnapshot(Map<String, dynamic> snapshot) {
    phase = BattlePlayerPhase.values.firstWhere(
      (value) => value.name == snapshot['phase'],
      orElse: () => BattlePlayerPhase.active,
    );
    progress = (snapshot['progress'] as num?)?.toDouble() ?? progress;
    checkpointIndex =
        (snapshot['checkpoint'] as num?)?.toInt() ?? checkpointIndex;
    respawnCount = (snapshot['respawns'] as num?)?.toInt() ?? respawnCount;
    knockoutCount = (snapshot['knockouts'] as num?)?.toInt() ?? knockoutCount;
    respawnTimer =
        (snapshot['respawn_time'] as num?)?.toDouble() ?? respawnTimer;
    spawnProtectionTimer =
        (snapshot['protection_time'] as num?)?.toDouble() ??
        spawnProtectionTimer;
    attackCooldown =
        (snapshot['attack_cooldown'] as num?)?.toDouble() ?? attackCooldown;
    heatMeter = (snapshot['heat'] as num?)?.toDouble() ?? heatMeter;
    checkpointSafeTimer =
        (snapshot['checkpoint_safe_time'] as num?)?.toDouble() ??
        checkpointSafeTimer;
  }
}
