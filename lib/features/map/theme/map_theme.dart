import 'package:flutter/material.dart';

abstract class MapTheme {
  final Color pathLineColor;
  final BoxDecoration lockedNodeDecoration;
  final BoxDecoration unlockedNodeDecoration;
  final BoxDecoration activeNodeDecoration;
  final Widget background;

  MapTheme({
    required this.pathLineColor,
    required this.lockedNodeDecoration,
    required this.unlockedNodeDecoration,
    required this.activeNodeDecoration,
    required this.background,
  });
}
