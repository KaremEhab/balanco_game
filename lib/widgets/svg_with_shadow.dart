import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWithShadow extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final Offset offset;
  final double blurRadius;

  const SvgWithShadow({
    super.key,
    required this.assetName,
    required this.width,
    required this.height,
    this.offset = const Offset(0, 4),
    this.blurRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: offset,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurRadius,
              sigmaY: blurRadius,
            ),
            child: SvgPicture.asset(
              assetName,
              width: width,
              height: height,
              colorFilter: const ColorFilter.mode(
                Colors.black45,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SvgPicture.asset(assetName, width: width, height: height),
      ],
    );
  }
}
