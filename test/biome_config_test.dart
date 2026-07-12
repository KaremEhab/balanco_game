import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BiomeConfig level groups', () {
    test('uses the beach theme through level 15', () {
      expect(BiomeConfig.getBiomeForLevel(1), same(BiomeConfig.tropicalBeach));
      expect(BiomeConfig.getBiomeForLevel(15), same(BiomeConfig.tropicalBeach));
    });

    test('unlocks the pyramid theme at level 16', () {
      expect(BiomeConfig.getBiomeForLevel(16), same(BiomeConfig.pyramids));
      expect(BiomeConfig.getBiomeForLevel(45), same(BiomeConfig.pyramids));
    });

    test('has one named background scene for every group', () {
      expect(BiomeConfig.sceneNames, hasLength(BiomeConfig.biomes.length));
      for (var i = 0; i < BiomeConfig.biomes.length; i++) {
        expect(BiomeConfig.getBiomeIndex(BiomeConfig.biomes[i]), i);
        expect(BiomeConfig.getSceneName(BiomeConfig.biomes[i]), isNotEmpty);
      }
    });
  });
}
