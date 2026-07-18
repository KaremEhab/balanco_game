enum RacePickupType {
  star('star'),
  heart('heart'),
  magnet('magnet'),
  multiBall('multi_ball'),
  shield('shield'),
  coin('coin'),
  shooterHelper('shooter_helper');

  const RacePickupType(this.wireName);

  final String wireName;

  static RacePickupType? fromWireName(String value) {
    for (final type in values) {
      if (type.wireName == value) return type;
    }
    return null;
  }
}

class RacePickupResolution {
  const RacePickupResolution({
    required this.pickupKey,
    required this.type,
    required this.claimantId,
    required this.claimantName,
  });

  final String pickupKey;
  final RacePickupType type;
  final String claimantId;
  final String claimantName;
}

typedef RacePickupClaimHandler =
    Future<RacePickupResolution> Function(
      RacePickupType type,
      String pickupKey,
    );
