import 'package:flutter/material.dart';
import '../../map/components/sea_waves_painter.dart';

class SeaWavesLayerPainter extends CustomPainter {
  final double waveProgress;

  SeaWavesLayerPainter({
    required this.waveProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    
    // animate horizontally in a seamless infinite loop over a 5000px virtual width!
    // The width of 5000 is 2 SVG tiles (Normal + Mirrored)
    double shiftX = -(waveProgress * 5000.0);
    canvas.translate(shiftX, 0);

    SeaWavesPainter seaWavesPainter = SeaWavesPainter(waveProgress);

    double tileHeight = 1500.0;
    
    // Draw all tiles for the entire canvas. 
    // Since this layer is cached and scrolls via SingleChildScrollView, we don't cull!
    int startTile = 0;
    int maxTileCount = (size.height / tileHeight).ceil();
    int endTile = maxTileCount;

    for (int i = startTile; i <= endTile; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.save();
        // Shift vertically for tiling
        canvas.translate(0, (i - 1) * tileHeight);
        
        // Shift horizontally for the current tile (0, 2500, 5000)
        canvas.translate(j * 2500.0, 0);

        // Every odd tile is mirrored horizontally to create a perfectly seamless joint
        if (j % 2 != 0) {
          canvas.translate(2500.0, 0);
          canvas.scale(-1.0, 1.0);
        }

        seaWavesPainter.paint(canvas, size);
        canvas.restore();
      }
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SeaWavesLayerPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress;
  }
}
