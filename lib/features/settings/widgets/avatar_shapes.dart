import 'package:flutter/material.dart';

enum AvatarShape { shield, circle, hexagon }

final ValueNotifier<AvatarShape> currentAvatarShapeNotifier = ValueNotifier(
  AvatarShape.circle,
);

final ValueNotifier<String> currentAvatarUrlNotifier = ValueNotifier(
  'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=BalancoHero&skinColor=f2d3b1&backgroundColor=transparent',
);

class ProfileAvatarWidget extends StatelessWidget {
  final AvatarShape shape;
  final double size;
  final String imageUrl;

  const ProfileAvatarWidget({
    super.key,
    required this.shape,
    required this.size,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    CustomClipper<Path> clipper;
    CustomPainter shadowPainter;
    CustomPainter framePainter;

    switch (shape) {
      case AvatarShape.circle:
        clipper = CircleAvatarClipper();
        shadowPainter = CircleShadowPainter();
        framePainter = CircleFramePainter();
        break;
      case AvatarShape.hexagon:
        clipper = HexagonAvatarClipper();
        shadowPainter = HexagonShadowPainter();
        framePainter = HexagonFramePainter();
        break;
      case AvatarShape.shield:
        clipper = ShieldClipper();
        shadowPainter = ShieldShadowPainter();
        framePainter = GameProfileBadgePainter();
        break;
    }

    return SizedBox(
      width: size,
      height: shape == AvatarShape.shield ? size * (60 / 55) : size,
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipPath(
              clipper: clipper,
              child: Container(
                color: const Color.fromARGB(255, 255, 225, 27),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain, // Prevents cropping!
                ),
              ),
            ),
            CustomPaint(painter: framePainter),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SHIELD
// -----------------------------------------------------------------------------
Path getShieldPath(Size size) {
  Path path = Path();
  double w = size.width;
  double h = size.height;

  path.moveTo(0, h * 0.15); // Start left top
  path.quadraticBezierTo(w * 0.25, h * 0.05, w * 0.5, 0); // Top left curve
  path.quadraticBezierTo(w * 0.75, h * 0.05, w, h * 0.15); // Top right curve
  path.lineTo(w, h * 0.55); // Right straight
  path.quadraticBezierTo(w * 0.9, h * 0.9, w * 0.5, h); // Bottom right curve
  path.quadraticBezierTo(w * 0.1, h * 0.9, 0, h * 0.55); // Bottom left curve
  path.close();

  return path;
}

class ShieldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = getShieldPath(Size(size.width - 8, size.height - 8));
    return path.shift(const Offset(4, 4));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShieldShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(getShieldPath(size), Colors.black87, 4.0, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GameProfileBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path outerPath = getShieldPath(size);
    Path innerPath = getShieldPath(
      Size(size.width - 8, size.height - 8),
    ).shift(const Offset(4, 4));

    Paint rimPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFDF7E), Color(0xFFB57D38)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path rimPath = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(rimPath, rimPaint);

    Paint shinePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.35), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(innerPath, shinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// CIRCLE
// -----------------------------------------------------------------------------
Path getCirclePath(Size size) {
  return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
}

class CircleAvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return getCirclePath(
      Size(size.width - 8, size.height - 8),
    ).shift(const Offset(4, 4));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CircleShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(getCirclePath(size), Colors.black87, 4.0, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircleFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path outerPath = getCirclePath(size);
    Path innerPath = getCirclePath(
      Size(size.width - 8, size.height - 8),
    ).shift(const Offset(4, 4));

    Paint rimPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFDF7E), Color(0xFFB57D38)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path rimPath = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(rimPath, rimPaint);

    Paint shinePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.35), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(innerPath, shinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// HEXAGON
// -----------------------------------------------------------------------------
Path getHexagonPath(Size size) {
  Path path = Path();
  double w = size.width;
  double h = size.height;

  // Pointy-top hexagon
  path.moveTo(w * 0.5, 0);
  path.lineTo(w, h * 0.25);
  path.lineTo(w, h * 0.75);
  path.lineTo(w * 0.5, h);
  path.lineTo(0, h * 0.75);
  path.lineTo(0, h * 0.25);
  path.close();
  return path;
}

class HexagonAvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return getHexagonPath(
      Size(size.width - 8, size.height - 8),
    ).shift(const Offset(4, 4));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HexagonShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(getHexagonPath(size), Colors.black87, 4.0, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path outerPath = getHexagonPath(size);
    Path innerPath = getHexagonPath(
      Size(size.width - 8, size.height - 8),
    ).shift(const Offset(4, 4));

    Paint rimPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFDF7E), Color(0xFFB57D38)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path rimPath = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(rimPath, rimPaint);

    Paint shinePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withValues(alpha: 0.35), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.center,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(innerPath, shinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
