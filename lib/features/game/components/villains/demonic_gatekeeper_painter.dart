import 'package:flutter/material.dart';

class DemonicGatekeeperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Layer: ground_shadow (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = RadialGradient(
        center: Alignment(0.0, 0.0),
        colors: [const Color(0x55000000), const Color(0x00000000)],
        stops: [0.0, 1.0],
        radius: 0.5,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.015);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.87),
          width: w * 0.46,
          height: h * 0.11,
        ),
        paint,
      );
    }
    // Layer: ball_base (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = RadialGradient(
        center: Alignment(-0.24, -0.43999999999999995),
        colors: [
          const Color(0xFFFF4A5F),
          const Color(0xFFE21E38),
          const Color(0xFFB10C22),
          const Color(0xFF5E0816),
        ],
        stops: [0.0, 0.42, 0.78, 1.0],
        radius: 0.75,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.31, paint);
    }
    // Layer: ball_base (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF2B0008);
      paint.strokeWidth = w * 0.006;
      canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.31, paint);
    }
    // Layer: ball_inner_shadow (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = RadialGradient(
        center: Alignment(0.43999999999999995, 0.52),
        colors: [
          const Color(0x00000000),
          const Color(0x00000000),
          const Color(0x44000000),
        ],
        stops: [0.0, 0.72, 1.0],
        radius: 0.9,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.31, paint);
    }
    // Layer: unnamed (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xFF1A0810);
      canvas.drawCircle(Offset(w * 0.19, h * 0.4), w * 0.018, paint);
    }
    // Layer: unnamed (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xFF1A0810);
      canvas.drawCircle(Offset(w * 0.19, h * 0.55), w * 0.015, paint);
    }
    // Layer: unnamed (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xFF1A0810);
      canvas.drawCircle(Offset(w * 0.81, h * 0.44), w * 0.018, paint);
    }
    // Layer: unnamed (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xFF1A0810);
      canvas.drawCircle(Offset(w * 0.81, h * 0.58), w * 0.015, paint);
    }
    // Layer: forehead_armor (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(0.0, -0.64),
        end: Alignment(0.0, -0.09999999999999998),
        colors: [
          const Color(0xFF2D2E35),
          const Color(0xFF17181D),
          const Color(0xFF07080C),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.5, h * 0.18);
      path.lineTo(w * 0.44, h * 0.3);
      path.quadraticBezierTo(w * 0.41, h * 0.34, w * 0.36, h * 0.36);
      path.lineTo(w * 0.39, h * 0.42);
      path.quadraticBezierTo(w * 0.46, h * 0.39, w * 0.5, h * 0.39);
      path.quadraticBezierTo(w * 0.54, h * 0.39, w * 0.61, h * 0.42);
      path.lineTo(w * 0.64, h * 0.36);
      path.quadraticBezierTo(w * 0.59, h * 0.34, w * 0.56, h * 0.3);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: forehead_armor (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF4A4B52);
      paint.strokeWidth = w * 0.003;
      Path path = Path();
      path.moveTo(w * 0.5, h * 0.18);
      path.lineTo(w * 0.44, h * 0.3);
      path.quadraticBezierTo(w * 0.41, h * 0.34, w * 0.36, h * 0.36);
      path.lineTo(w * 0.39, h * 0.42);
      path.quadraticBezierTo(w * 0.46, h * 0.39, w * 0.5, h * 0.39);
      path.quadraticBezierTo(w * 0.54, h * 0.39, w * 0.61, h * 0.42);
      path.lineTo(w * 0.64, h * 0.36);
      path.quadraticBezierTo(w * 0.59, h * 0.34, w * 0.56, h * 0.3);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: forehead_jewel_outer (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = RadialGradient(
        center: Alignment(-0.040000000000000036, -0.5),
        colors: [
          const Color(0xFFFF7B8D),
          const Color(0xFFF61C3B),
          const Color(0xFF790010),
        ],
        stops: [0.0, 0.55, 1.0],
        radius: 0.8,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.5, h * 0.23000000000000004);
      path.lineTo(w * 0.535, h * 0.28);
      path.lineTo(w * 0.5, h * 0.33);
      path.lineTo(w * 0.46499999999999997, h * 0.28);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: forehead_jewel_outer (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFFFFA3B0);
      paint.strokeWidth = w * 0.003;
      Path path = Path();
      path.moveTo(w * 0.5, h * 0.23000000000000004);
      path.lineTo(w * 0.535, h * 0.28);
      path.lineTo(w * 0.5, h * 0.33);
      path.lineTo(w * 0.46499999999999997, h * 0.28);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: left_eye_socket (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(-0.43999999999999995, -0.24),
        end: Alignment(-0.14, 0.040000000000000036),
        colors: [
          const Color(0xFF140306),
          const Color(0xFF220609),
          const Color(0xFF050203),
        ],
        stops: [0.0, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.27, h * 0.43);
      path.quadraticBezierTo(w * 0.33, h * 0.33, w * 0.44, h * 0.38);
      path.quadraticBezierTo(w * 0.42, h * 0.48, w * 0.32, h * 0.5);
      path.quadraticBezierTo(w * 0.24, h * 0.49, w * 0.27, h * 0.43);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: right_eye_socket (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(0.43999999999999995, -0.24),
        end: Alignment(0.1399999999999999, 0.040000000000000036),
        colors: [
          const Color(0xFF140306),
          const Color(0xFF220609),
          const Color(0xFF050203),
        ],
        stops: [0.0, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.73, h * 0.43);
      path.quadraticBezierTo(w * 0.67, h * 0.33, w * 0.56, h * 0.38);
      path.quadraticBezierTo(w * 0.58, h * 0.48, w * 0.68, h * 0.5);
      path.quadraticBezierTo(w * 0.76, h * 0.49, w * 0.73, h * 0.43);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: left_eye_glow (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = RadialGradient(
        center: Alignment(-0.26, -0.19999999999999996),
        colors: [
          const Color(0xFFFFF9B0),
          const Color(0xFFFFB400),
          const Color(0xFFFF5A00),
          const Color(0xFF9D1B00),
        ],
        stops: [0.0, 0.28, 0.68, 1.0],
        radius: 0.85,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.35, h * 0.43),
          width: w * 0.15,
          height: h * 0.11,
        ),
        paint,
      );
    }
    // Layer: right_eye_glow (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = RadialGradient(
        center: Alignment(0.26, -0.19999999999999996),
        colors: [
          const Color(0xFFFFF9B0),
          const Color(0xFFFFB400),
          const Color(0xFFFF5A00),
          const Color(0xFF9D1B00),
        ],
        stops: [0.0, 0.28, 0.68, 1.0],
        radius: 0.85,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.65, h * 0.43),
          width: w * 0.15,
          height: h * 0.11,
        ),
        paint,
      );
    }
    // Layer: left_pupil (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xFF5C1300);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.36, h * 0.44),
          width: w * 0.036,
          height: h * 0.06,
        ),
        paint,
      );
    }
    // Layer: right_pupil (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xFF5C1300);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.64, h * 0.44),
          width: w * 0.036,
          height: h * 0.06,
        ),
        paint,
      );
    }
    // Layer: eye_highlight_left (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xCCFFFFFF);
      canvas.drawCircle(Offset(w * 0.33, h * 0.415), w * 0.008, paint);
    }
    // Layer: eye_highlight_right (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.color = const Color(0xCCFFFFFF);
      canvas.drawCircle(Offset(w * 0.67, h * 0.415), w * 0.008, paint);
    }
    // Layer: left_brow_plate (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(-0.52, -0.42000000000000004),
        end: Alignment(-0.12, -0.06000000000000005),
        colors: [
          const Color(0xFF3B3C42),
          const Color(0xFF1C1D22),
          const Color(0xFF08090D),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.24, h * 0.34);
      path.quadraticBezierTo(w * 0.33, h * 0.28, w * 0.46, h * 0.31);
      path.lineTo(w * 0.43, h * 0.39);
      path.quadraticBezierTo(w * 0.35, h * 0.38, w * 0.28, h * 0.44);
      path.lineTo(w * 0.23, h * 0.4);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: left_brow_plate (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF55565D);
      paint.strokeWidth = w * 0.0025;
      Path path = Path();
      path.moveTo(w * 0.24, h * 0.34);
      path.quadraticBezierTo(w * 0.33, h * 0.28, w * 0.46, h * 0.31);
      path.lineTo(w * 0.43, h * 0.39);
      path.quadraticBezierTo(w * 0.35, h * 0.38, w * 0.28, h * 0.44);
      path.lineTo(w * 0.23, h * 0.4);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: right_brow_plate (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(0.52, -0.42000000000000004),
        end: Alignment(0.1200000000000001, -0.06000000000000005),
        colors: [
          const Color(0xFF3B3C42),
          const Color(0xFF1C1D22),
          const Color(0xFF08090D),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.76, h * 0.34);
      path.quadraticBezierTo(w * 0.67, h * 0.28, w * 0.54, h * 0.31);
      path.lineTo(w * 0.57, h * 0.39);
      path.quadraticBezierTo(w * 0.65, h * 0.38, w * 0.72, h * 0.44);
      path.lineTo(w * 0.77, h * 0.4);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: right_brow_plate (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF55565D);
      paint.strokeWidth = w * 0.0025;
      Path path = Path();
      path.moveTo(w * 0.76, h * 0.34);
      path.quadraticBezierTo(w * 0.67, h * 0.28, w * 0.54, h * 0.31);
      path.lineTo(w * 0.57, h * 0.39);
      path.quadraticBezierTo(w * 0.65, h * 0.38, w * 0.72, h * 0.44);
      path.lineTo(w * 0.77, h * 0.4);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: mouth_opening (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(0.0, 0.08000000000000007),
        end: Alignment(0.0, 0.43999999999999995),
        colors: [
          const Color(0xFF050203),
          const Color(0xFF180306),
          const Color(0xFF2A060B),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.31, h * 0.6);
      path.quadraticBezierTo(w * 0.5, h * 0.71, w * 0.69, h * 0.6);
      path.quadraticBezierTo(w * 0.64, h * 0.69, w * 0.5, h * 0.7);
      path.quadraticBezierTo(w * 0.36, h * 0.69, w * 0.31, h * 0.6);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: left_fang (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(-0.21999999999999997, 0.19999999999999996),
        end: Alignment(-0.19999999999999996, 0.3600000000000001),
        colors: [
          const Color(0xFFFFE9E0),
          const Color(0xFFD9A89B),
          const Color(0xFFA56A5B),
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.38, h * 0.6);
      path.lineTo(w * 0.41, h * 0.6);
      path.lineTo(w * 0.395, h * 0.68);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: right_fang (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(0.21999999999999997, 0.19999999999999996),
        end: Alignment(0.19999999999999996, 0.3600000000000001),
        colors: [
          const Color(0xFFFFE9E0),
          const Color(0xFFD9A89B),
          const Color(0xFFA56A5B),
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.59, h * 0.6);
      path.lineTo(w * 0.62, h * 0.6);
      path.lineTo(w * 0.605, h * 0.68);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: lower_jaw_armor (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(0.0, 0.32000000000000006),
        end: Alignment(0.0, 0.6799999999999999),
        colors: [
          const Color(0xFF2E2F35),
          const Color(0xFF18191E),
          const Color(0xFF07080C),
        ],
        stops: [0.0, 0.58, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.39, h * 0.66);
      path.quadraticBezierTo(w * 0.5, h * 0.73, w * 0.61, h * 0.66);
      path.lineTo(w * 0.6, h * 0.77);
      path.quadraticBezierTo(w * 0.5, h * 0.82, w * 0.4, h * 0.77);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: lower_jaw_armor (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF4E4F56);
      paint.strokeWidth = w * 0.0025;
      Path path = Path();
      path.moveTo(w * 0.39, h * 0.66);
      path.quadraticBezierTo(w * 0.5, h * 0.73, w * 0.61, h * 0.66);
      path.lineTo(w * 0.6, h * 0.77);
      path.quadraticBezierTo(w * 0.5, h * 0.82, w * 0.4, h * 0.77);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: unnamed (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF7F0013);
      paint.strokeWidth = w * 0.003;
      Path path = Path();
      path.moveTo(w * 0.31, h * 0.2);
      path.lineTo(w * 0.29, h * 0.23);
      path.lineTo(w * 0.3, h * 0.25);
      path.lineTo(w * 0.27, h * 0.28);
      canvas.drawPath(path, paint);
    }
    // Layer: unnamed (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF7F0013);
      paint.strokeWidth = w * 0.003;
      Path path = Path();
      path.moveTo(w * 0.66, h * 0.19);
      path.lineTo(w * 0.68, h * 0.23);
      path.lineTo(w * 0.66, h * 0.25);
      path.lineTo(w * 0.69, h * 0.29);
      canvas.drawPath(path, paint);
    }
    // Layer: unnamed (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF7F0013);
      paint.strokeWidth = w * 0.0025;
      Path path = Path();
      path.moveTo(w * 0.74, h * 0.63);
      path.lineTo(w * 0.76, h * 0.67);
      path.lineTo(w * 0.75, h * 0.7);
      canvas.drawPath(path, paint);
    }
    // Layer: unnamed (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0xFF7F0013);
      paint.strokeWidth = w * 0.0025;
      Path path = Path();
      path.moveTo(w * 0.28, h * 0.63);
      path.lineTo(w * 0.26, h * 0.67);
      path.lineTo(w * 0.27, h * 0.71);
      canvas.drawPath(path, paint);
    }
    // Layer: top_gloss (fill)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.fill;
      paint.shader = LinearGradient(
        begin: Alignment(-0.09999999999999998, -0.8),
        end: Alignment(0.19999999999999996, -0.48),
        colors: [
          const Color(0x66FFFFFF),
          const Color(0x10FFFFFF),
          const Color(0x00FFFFFF),
        ],
        stops: [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      Path path = Path();
      path.moveTo(w * 0.34, h * 0.12);
      path.quadraticBezierTo(w * 0.5, h * 0.07, w * 0.68, h * 0.12);
      path.quadraticBezierTo(w * 0.62, h * 0.18, w * 0.48, h * 0.17);
      path.quadraticBezierTo(w * 0.39, h * 0.17, w * 0.34, h * 0.12);
      path.close();
      canvas.drawPath(path, paint);
    }
    // Layer: rim_light_left (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0x44B53DFF);
      paint.strokeWidth = w * 0.008;
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.01);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(w * 0.5, h * 0.48), radius: w * 0.305),
        2.5307274153917776,
        1.3962634015954636,
        false,
        paint,
      );
    }
    // Layer: rim_light_right (stroke)
    {
      Paint paint = Paint()..isAntiAlias = true;
      paint.style = PaintingStyle.stroke;
      paint.color = const Color(0x44FF4422);
      paint.strokeWidth = w * 0.008;
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.01);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(w * 0.5, h * 0.48), radius: w * 0.305),
        5.235987755982989,
        0.6981317007977318,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
