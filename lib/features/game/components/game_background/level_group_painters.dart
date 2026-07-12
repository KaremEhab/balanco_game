import 'package:balanco_game/features/game/components/game_background/pyramids_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/mountains_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sea_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sky_painter.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:flutter/material.dart';

class BiomeLayerSpec {
  const BiomeLayerSpec({
    required this.name,
    required this.painter,
    required this.depth,
    this.dx = 0,
    this.dy = 0,
    this.scale = 1,
  });

  final String name;
  final CustomPainter painter;
  final double depth;
  final double dx;
  final double dy;
  final double scale;
}

List<BiomeLayerSpec> levelGroupLayers(BiomeModel biome) {
  final index = BiomeConfig.getBiomeIndex(
    biome,
  ).clamp(0, BiomeConfig.biomes.length - 1);
  if (index == 0) {
    return [
      BiomeLayerSpec(name: 'Sky', painter: SkyPainter(), depth: 0.05),
      BiomeLayerSpec(
        name: 'Cloud 1',
        painter: FirstCloudPainter(),
        depth: 0.10,
        dx: 193.1,
        dy: 46.5,
        scale: 0.39,
      ),
      BiomeLayerSpec(
        name: 'Cloud 2',
        painter: SecondCloudPainter(),
        depth: 0.12,
        dx: -6.1,
        dy: 7.1,
        scale: 0.26,
      ),
      BiomeLayerSpec(
        name: 'Cloud 3',
        painter: ThirdCloudPainter(),
        depth: 0.14,
        dx: 59.7,
        dy: 15.7,
        scale: 0.46,
      ),
      BiomeLayerSpec(
        name: 'Cloud 4',
        painter: ForthCloudPainter(),
        depth: 0.16,
        dx: 305,
        dy: 27,
        scale: 0.63,
      ),
      BiomeLayerSpec(
        name: 'Cloud 5',
        painter: FifthCloudPainter(),
        depth: 0.18,
        dx: 127.3,
        dy: -85.9,
        scale: 0.48,
      ),
      BiomeLayerSpec(
        name: 'Birds',
        painter: BirdsPainter(),
        depth: 0.20,
        dx: 230.1,
        dy: -11.4,
        scale: 0.57,
      ),
      BiomeLayerSpec(
        name: 'Far Sea',
        painter: FurtherSeaPainter(),
        depth: 0.40,
        dy: 214,
        scale: 1.05,
      ),
      BiomeLayerSpec(
        name: 'Sea Shadows',
        painter: MountainSeaShadowsPainter(),
        depth: 0.50,
        dx: 52.8,
        dy: 166.4,
        scale: 0.47,
      ),
      BiomeLayerSpec(
        name: 'Back Mountain',
        painter: BackMountainPainter(),
        depth: 0.30,
        dx: 122,
        dy: 42.6,
        scale: 0.5,
      ),
      BiomeLayerSpec(
        name: 'Near Sea',
        painter: CloserSeaPainter(),
        depth: 0.60,
        dx: 166.9,
        dy: 401.3,
        scale: 1.42,
      ),
      BiomeLayerSpec(
        name: 'Water Drops',
        painter: SeaWaterDropsPainter(),
        depth: 0.70,
        dx: 112.6,
        dy: 246.1,
        scale: 0.51,
      ),
      BiomeLayerSpec(
        name: 'Front Mountain',
        painter: FrontMountainPainter(),
        depth: 0.80,
        dx: 73.2,
        dy: 35.3,
        scale: 0.32,
      ),
      BiomeLayerSpec(
        name: 'Sea Waves',
        painter: SeaMountainWaves(),
        depth: 0.45,
        dx: 7.1,
        dy: 9.6,
        scale: 0.27,
      ),
    ];
  }
  if (index == 1) {
    return [
      const BiomeLayerSpec(
        name: 'Pyramid Sky',
        painter: PyramidSkyPainter(),
        depth: 0,
      ),
      BiomeLayerSpec(
        name: 'Wispy Clouds',
        painter: WispyCloudPainter(),
        depth: 0.10,
      ),
      BiomeLayerSpec(
        name: 'Distant Mountains',
        painter: DistantMountainsPainter(),
        depth: 0.20,
      ),
      BiomeLayerSpec(
        name: 'Main Pyramids',
        painter: MainPyramidsPainter(),
        depth: 0.40,
      ),
      BiomeLayerSpec(
        name: 'Midground Dunes',
        painter: MidgroundDunesPainter(),
        depth: 0.70,
      ),
      BiomeLayerSpec(
        name: 'Foreground Dunes',
        painter: ForegroundDunesPainter(),
        depth: 1,
      ),
    ];
  }

  return [
    BiomeLayerSpec(
      name: 'Atmosphere',
      painter: GroupSkyPainter(biome: biome, sceneIndex: index),
      depth: 0,
    ),
    BiomeLayerSpec(
      name: 'Distant Details',
      painter: GroupAtmospherePainter(biome: biome, sceneIndex: index),
      depth: 0.18,
    ),
    BiomeLayerSpec(
      name: 'World Landmark',
      painter: GroupLandmarkPainter(biome: biome, sceneIndex: index),
      depth: 0.48,
    ),
    BiomeLayerSpec(
      name: 'Foreground',
      painter: GroupForegroundPainter(biome: biome, sceneIndex: index),
      depth: 0.9,
    ),
  ];
}

class GroupSkyPainter extends CustomPainter {
  const GroupSkyPainter({required this.biome, required this.sceneIndex});

  final BiomeModel biome;
  final int sceneIndex;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(biome.bgTopColor, Colors.black, 0.12)!,
            biome.primaryColor,
            Color.lerp(biome.bgBottomColor, biome.secondaryColor, 0.45)!,
          ],
          stops: const [0, 0.58, 1],
        ).createShader(Offset.zero & size),
    );

    final celestial = Offset(
      size.width * (sceneIndex.isEven ? 0.78 : 0.22),
      size.height * 0.18,
    );
    canvas.drawCircle(
      celestial,
      size.shortestSide * 0.09,
      Paint()
        ..color = biome.secondaryColor.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );
    canvas.drawCircle(
      celestial,
      size.shortestSide * 0.045,
      Paint()..color = biome.secondaryColor,
    );
  }

  @override
  bool shouldRepaint(GroupSkyPainter oldDelegate) =>
      oldDelegate.biome != biome || oldDelegate.sceneIndex != sceneIndex;
}

class GroupAtmospherePainter extends CustomPainter {
  const GroupAtmospherePainter({required this.biome, required this.sceneIndex});

  final BiomeModel biome;
  final int sceneIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = biome.secondaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (var i = 0; i < 9; i++) {
      final x = size.width * ((i * 0.127 + sceneIndex * 0.071) % 1);
      final y = size.height * (0.12 + (i % 4) * 0.12);
      if (sceneIndex % 3 == 0) {
        canvas.drawCircle(
          Offset(x, y),
          3 + i % 4,
          paint..style = PaintingStyle.fill,
        );
      } else if (sceneIndex % 3 == 1) {
        canvas.drawLine(
          Offset(x - 12, y),
          Offset(x + 12, y - 5),
          paint..style = PaintingStyle.stroke,
        );
      } else {
        final path = Path()
          ..moveTo(x - 10, y)
          ..quadraticBezierTo(x, y - 9, x + 10, y);
        canvas.drawPath(path, paint..style = PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(GroupAtmospherePainter oldDelegate) =>
      oldDelegate.biome != biome || oldDelegate.sceneIndex != sceneIndex;
}

class GroupLandmarkPainter extends CustomPainter {
  const GroupLandmarkPainter({required this.biome, required this.sceneIndex});

  final BiomeModel biome;
  final int sceneIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final dark = Color.lerp(biome.primaryColor, Colors.black, 0.38)!;
    final light = Color.lerp(biome.secondaryColor, Colors.white, 0.16)!;
    switch (sceneIndex) {
      case 2: // jungle ruins
      case 9: // enchanted forest
      case 15: // swamp
        _drawOrganic(canvas, size, dark, light);
      case 3: // ice
      case 10: // clouds
      case 11: // crystals
        _drawPeaks(canvas, size, dark, light);
      case 4: // volcano
      case 12: // canyon
      case 17: // eclipse
        _drawRidges(canvas, size, dark, light);
      case 5: // carnival
      case 8: // candy
        _drawTowers(canvas, size, dark, light, rounded: true);
      case 6: // station
      case 13: // steel
      case 14: // cyber
      case 16: // nightmare city
        _drawTowers(canvas, size, dark, light, rounded: false);
      default:
        _drawRidges(canvas, size, dark, light);
    }
  }

  void _drawOrganic(Canvas canvas, Size size, Color dark, Color light) {
    for (var i = 0; i < 7; i++) {
      final x = size.width * (0.05 + i * 0.15);
      final h = size.height * (0.24 + (i % 3) * 0.08);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height * 0.72 - h, size.width * 0.045, h),
          const Radius.circular(18),
        ),
        Paint()..color = dark,
      );
      canvas.drawCircle(
        Offset(x + size.width * 0.022, size.height * 0.72 - h),
        size.width * 0.075,
        Paint()..color = light,
      );
    }
  }

  void _drawPeaks(Canvas canvas, Size size, Color dark, Color light) {
    final path = Path()..moveTo(0, size.height * 0.78);
    for (var i = 0; i < 8; i++) {
      final x = size.width * i / 7;
      path.lineTo(x, size.height * (i.isEven ? 0.35 : 0.7));
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: [light, dark],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawRidges(Canvas canvas, Size size, Color dark, Color light) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.73)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.42,
        size.width * 0.34,
        size.height * 0.75,
        size.width * 0.5,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.24,
        size.width * 0.82,
        size.height * 0.72,
        size.width,
        size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: [light, dark],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawTowers(
    Canvas canvas,
    Size size,
    Color dark,
    Color light, {
    required bool rounded,
  }) {
    for (var i = 0; i < 9; i++) {
      final w = size.width * 0.075;
      final h = size.height * (0.18 + (i * 0.073) % 0.34);
      final rect = Rect.fromLTWH(
        size.width * (0.02 + i * 0.115),
        size.height * 0.78 - h,
        w,
        h,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rounded ? 24 : 3)),
        Paint()..color = i.isEven ? dark : light,
      );
      if (!rounded) {
        for (var y = rect.top + 12; y < rect.bottom - 8; y += 18) {
          canvas.drawRect(
            Rect.fromLTWH(rect.left + 8, y, 5, 8),
            Paint()..color = biome.secondaryColor,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(GroupLandmarkPainter oldDelegate) =>
      oldDelegate.biome != biome || oldDelegate.sceneIndex != sceneIndex;
}

class GroupForegroundPainter extends CustomPainter {
  const GroupForegroundPainter({required this.biome, required this.sceneIndex});

  final BiomeModel biome;
  final int sceneIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * (sceneIndex.isEven ? 0.66 : 0.86),
        size.width * 0.53,
        size.height * 0.76,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * (sceneIndex.isEven ? 0.88 : 0.64),
        size.width,
        size.height * 0.72,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            biome.primaryColor,
            Color.lerp(biome.bgTopColor, Colors.black, 0.35)!,
          ],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(GroupForegroundPainter oldDelegate) =>
      oldDelegate.biome != biome || oldDelegate.sceneIndex != sceneIndex;
}
