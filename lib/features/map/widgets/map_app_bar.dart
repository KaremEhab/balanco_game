import 'dart:ui';
import 'package:balanco_game/core/data/models.dart';
import 'package:balanco_game/features/map/components/gem_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';
import 'package:balanco_game/features/settings/screens/profile_dialog.dart';
import 'package:balanco_game/features/game/components/game_area/collected_star_painter.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/core/data/models.dart';

class MapAppBar extends StatefulWidget {
  final int highestLevel;
  final int coins;
  final int sparks;
  final int maxSparks;
  final double expandProgress;
  final ValueNotifier<double>? biomeTransitionProgress;
  final BiomeModel? currentBiome;
  final BiomeModel? previousBiome;

  const MapAppBar({
    super.key,
    required this.highestLevel,
    required this.coins,
    required this.sparks,
    this.maxSparks = 5,
    this.expandProgress = 0.0,
    this.biomeTransitionProgress,
    this.currentBiome,
    this.previousBiome,
  });

  @override
  State<MapAppBar> createState() => _MapAppBarState();
}

class _MapAppBarState extends State<MapAppBar> {
  String _formatCompactPoints(int points) {
    if (points >= 1000000) {
      return '${(points / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
    } else if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
    }
    return points.toString();
  }

  String _formatFullPoints(int points) {
    final formatted = points.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted PTS';
  }

  Widget _buildStrokedText(
    String text, {
    required double fontSize,
    required Color textColor,
    required Color strokeColor,
    required Color shadowColor,
  }) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.luckiestGuy(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = strokeColor,
            shadows: [Shadow(color: shadowColor, offset: const Offset(0, 4))],
          ),
        ),
        Text(
          text,
          style: GoogleFonts.luckiestGuy(fontSize: fontSize, color: textColor),
        ),
      ],
    );
  }

  Widget _buildStrokedSvg(
    String assetName, {
    required double width,
    required double height,
    required Color strokeColor,
    required Color shadowColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: 4,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(shadowColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: -2,
          top: 0,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: 2,
          top: 0,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: 0,
          top: -2,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: 0,
          top: 2,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        SvgPicture.asset(assetName, width: width, height: height),
      ],
    );
  }

  // =========================================================================
  // APPBAR CONTENT (Visible when p = 0.0)
  // =========================================================================
  Widget _buildAppBarContent(double w) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // --- LVL Pill ---
        Positioned(
          left: 82,
          top: 38,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: GameColors.mapAppBarPeach,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 104, 77, 30),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: GameColors.mapAppBarBrownText,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: _buildStrokedText(
              'LVL ${widget.highestLevel}',
              fontSize: 12,
              textColor: GameColors.mapAppBarWhiteHint,
              strokeColor: const Color.fromARGB(255, 104, 77, 30),
              shadowColor: GameColors.mapAppBarBrownText,
            ),
          ),
        ),

        // --- Coins ---
        Positioned(
          left: 140,
          top: 38,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 4,
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                  color: GameColors.mapAppBarPeach,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 104, 77, 30),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: GameColors.mapAppBarBrownText,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ValueListenableBuilder<PlayerProfile?>(
                  valueListenable: DatabaseHelper.instance.profileNotifier,
                  builder: (context, profile, _) {
                    final displayCoins = profile?.coins ?? widget.coins;
                    return _buildStrokedText(
                      _formatCompactPoints(displayCoins),
                      fontSize: 12,
                      textColor: GameColors.mapAppBarWhiteHint,
                      strokeColor: const Color.fromARGB(255, 104, 77, 30),
                      shadowColor: GameColors.mapAppBarBrownText,
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                child: SvgPicture.asset(
                  'assets/images/add-button.svg',
                  width: 23,
                  height: 23,
                ),
              ),
              Positioned(
                right: -6,
                top: 1,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CustomPaint(painter: CollectedStarPainter()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Sparks ---
        Positioned(
          left: 235,
          right: 16,
          top: 18,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GameColors.mapAppBarTealAccent,
                      GameColors.mapAppBarCyanMedium,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color.fromARGB(255, 55, 100, 141),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: GameColors.mapAppBarTealDeep,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      // Unfilled progress overlay
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: widget.maxSparks > 0
                                ? (1.0 - (widget.sparks / widget.maxSparks))
                                      .clamp(0.0, 1.0)
                                : 1.0,
                            child: Container(
                              color: GameColors.black.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left:
                                5, // Offset to account for the Add button overlap
                            top: 6,
                            bottom: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStrokedSvg(
                                'assets/images/Spark-icon.svg',
                                width: 23,
                                height: 23,
                                strokeColor: const Color.fromARGB(
                                  255,
                                  55,
                                  100,
                                  141,
                                ),
                                shadowColor: GameColors.mapAppBarTealDeep,
                              ),
                              const SizedBox(width: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  _buildStrokedText(
                                    '${widget.sparks}',
                                    fontSize: 22,
                                    textColor: GameColors.mapAppBarWhiteHint,
                                    strokeColor: const Color.fromARGB(
                                      255,
                                      55,
                                      100,
                                      141,
                                    ),
                                    shadowColor: GameColors.mapAppBarTealDeep,
                                  ),
                                  _buildStrokedText(
                                    '/${widget.maxSparks}',
                                    fontSize: 13,
                                    textColor: GameColors.mapAppBarWhiteHint,
                                    strokeColor: const Color.fromARGB(
                                      255,
                                      55,
                                      100,
                                      141,
                                    ),
                                    shadowColor: GameColors.mapAppBarTealDeep,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                child: SvgPicture.asset(
                  'assets/images/add-button.svg',
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // EXPANDED CONTENT (Visible when p = 1.0)
  // =========================================================================
  Widget _buildExpandedContent(
    double width,
    Color containerColor,
    Color borderColor,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // --- Rank / Title ---
        Positioned(
          left: 108,
          top: 50,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 24, 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GameColors.mapAppBarMint,
                  GameColors.mapAppBarGreenAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: GameColors.mapAppBarTeal800, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CustomPaint(painter: GemPainter()),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildStrokedText(
                  'PLATINUM',
                  fontSize: 15,
                  textColor: GameColors.mapAppBarWhiteHint,
                  strokeColor: GameColors.mapAppBarTeal800,
                  shadowColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),

        // --- Edit Button ---
        Positioned(
          right: 20,
          top: 25,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: GameColors.mapAppBarBrownText,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/images/edit-icon.svg',
              width: 55,
              height: 55,
            ),
          ),
        ),

        // --- Expanded Sparks ---
        Positioned(
          left: 0,
          top: 110,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: width / 2 - 25,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      GameColors.mapAppBarTealAccent,
                      GameColors.mapAppBarCyanMedium,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: GameColors.mapAppBarBlue700,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      // Unfilled progress overlay
                      Align(
                        alignment: Alignment.centerRight,
                        child: FractionallySizedBox(
                          widthFactor: widget.maxSparks > 0
                              ? (1.0 - (widget.sparks / widget.maxSparks))
                                    .clamp(0.0, 1.0)
                              : 1.0,
                          heightFactor: 1.0,
                          child: Container(
                            color: GameColors.black.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      // Content
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStrokedSvg(
                              'assets/images/Spark-icon.svg',
                              width: 20,
                              height: 20,
                              strokeColor: GameColors.mapAppBarBlue700,
                              shadowColor: Colors.transparent,
                            ),
                            const SizedBox(width: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                _buildStrokedText(
                                  '${widget.sparks}',
                                  fontSize: 20,
                                  textColor: GameColors.mapAppBarWhiteHint,
                                  strokeColor: GameColors.mapAppBarBlue700,
                                  shadowColor: Colors.transparent,
                                ),
                                _buildStrokedText(
                                  '/${widget.maxSparks}',
                                  fontSize: 14,
                                  textColor: GameColors.mapAppBarWhiteHint,
                                  strokeColor: GameColors.mapAppBarBlue700,
                                  shadowColor: Colors.transparent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                child: SvgPicture.asset(
                  'assets/images/add-button.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),

        // --- Expanded Coins ---
        Positioned(
          left: width / 2 - 15,
          top: 110,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.only(right: 20),
                width: width / 2 - 25,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      GameColors.mapAppBarYellow,
                      GameColors.mapAppBarGoldDark,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: GameColors.mapAppBarGoldDarker,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: CustomPaint(painter: CollectedStarPainter()),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _buildStrokedText(
                      _formatCompactPoints(widget.coins),
                      fontSize: 16,
                      textColor: GameColors.mapAppBarWhiteHint,
                      strokeColor: GameColors.mapAppBarGoldDarker,
                      shadowColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -2,
                child: SvgPicture.asset(
                  'assets/images/add-button.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),

        // --- Expanded Points ---
        Positioned(
          left: 20,
          right: 20,
          top: 170,
          child: Container(
            padding: const EdgeInsets.only(top: 8, bottom: 3),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: borderColor, width: 2),
            ),
            alignment: Alignment.center,
            child: _buildStrokedText(
              _formatFullPoints(widget.coins),
              fontSize: 20,
              textColor: GameColors.white,
              strokeColor: borderColor,
              shadowColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.biomeTransitionProgress ?? ValueNotifier(0.0),
      builder: (context, child) {
        final double p = widget.expandProgress; // 0.0 to 1.0
        final double biomeProgress =
            widget.biomeTransitionProgress?.value ?? 0.0;

        // Heights
        final double minHeight = 90.0;
        final double maxHeight = 240.0;
        final double currentHeight = lerpDouble(minHeight, maxHeight, p)!;
        final double borderRadius = lerpDouble(100.0, 40.0, p)!;

        // Previous Biome colors
        final Color prevPrimary =
            widget.previousBiome?.primaryColor ?? GameColors.mapAppBarTealDark;
        final Color prevSecondary =
            widget.previousBiome?.secondaryColor ??
            GameColors.mapAppBarCyanLight;

        final Color prevContainerColor = Color.lerp(
          prevSecondary.withValues(alpha: 0.3),
          prevSecondary.withValues(alpha: 0.5),
          p,
        )!;
        final Color prevBorderColor = prevPrimary;

        // Current Biome colors
        final Color currPrimary =
            widget.currentBiome?.primaryColor ?? GameColors.mapAppBarTealDark;
        final Color currSecondary =
            widget.currentBiome?.secondaryColor ??
            GameColors.mapAppBarCyanLight;

        final Color currContainerColor = Color.lerp(
          currSecondary.withValues(alpha: 0.3),
          currSecondary.withValues(alpha: 0.5),
          p,
        )!;
        final Color currBorderColor = currPrimary;

        // Transition Colors and Border based on Biome
        final Color containerColor = Color.lerp(
          prevContainerColor,
          currContainerColor,
          biomeProgress,
        )!;
        final Color borderColor = Color.lerp(
          prevBorderColor,
          currBorderColor,
          biomeProgress,
        )!;
        final double borderWidth = lerpDouble(2.0, 3.0, p)!;
        final Color shadowColor = Color.lerp(
          Colors.transparent,
          Colors.transparent,
          p,
        )!;
        final Offset shadowOffset = Offset(0, lerpDouble(0.0, 6.0, p)!);

        return LayoutBuilder(
          builder: (context, constraints) {
            final double w = constraints.maxWidth;

            // Math for Avatar and Name Interpolation (Shared Elements)
            final double avatarSize = lerpDouble(55, 75, p)!;
            final double avatarLeft = lerpDouble(16, 20, p)!;
            final double avatarTop = lerpDouble(12, 20, p)!;

            final double nameLeft = lerpDouble(82, 110, p)!;
            final double nameTop = lerpDouble(12, 22, p)!;
            final double nameSize = lerpDouble(18, 18, p)!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: w,
                  height: currentHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: borderColor,
                            width: borderWidth,
                          ),
                          boxShadow: [
                            if (p > 0)
                              BoxShadow(
                                color: shadowColor,
                                offset: shadowOffset,
                              ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // --- 1. Fade out AppBar Content ---
                            if (p < 1.0)
                              Opacity(
                                opacity: (1 - p).clamp(0.0, 1.0),
                                child: IgnorePointer(
                                  ignoring: p > 0.5,
                                  child: _buildAppBarContent(w),
                                ),
                              ),

                            // --- 2. Fade in Expanded Content ---
                            if (p > 0.0)
                              Opacity(
                                opacity: p,
                                child: IgnorePointer(
                                  ignoring: p <= 0.5,
                                  child: _buildExpandedContent(
                                    w,
                                    containerColor,
                                    borderColor,
                                  ),
                                ),
                              ),

                            // --- 3. Sliding Shared Elements (Avatar & Name) ---
                            Positioned(
                              left: avatarLeft,
                              top: avatarTop,
                              child: GestureDetector(
                                onTap: () {
                                  showProfileDialog(
                                    context,
                                    name: 'KAREEM EHAB',
                                    level: widget.highestLevel,
                                    coins: widget.coins,
                                    sparks: widget.sparks,
                                  );
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ValueListenableBuilder<AvatarShape>(
                                      valueListenable:
                                          currentAvatarShapeNotifier,
                                      builder: (context, shape, _) {
                                        return ValueListenableBuilder<String>(
                                          valueListenable:
                                              currentAvatarUrlNotifier,
                                          builder: (context, url, _) {
                                            return ProfileAvatarWidget(
                                              shape: shape,
                                              size: avatarSize,
                                              imageUrl: url,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    if (p < 1.0)
                                      Positioned(
                                        bottom: lerpDouble(-8, -12, p)!,
                                        child: Opacity(
                                          opacity: 1 - p,
                                          child: SizedBox(
                                            width: lerpDouble(26, 36, p)!,
                                            height: lerpDouble(26, 36, p)!,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CustomPaint(
                                                  painter: GemPainter(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              left: nameLeft,
                              top: nameTop,
                              child: _buildStrokedText(
                                'KAREEM EHAB',
                                fontSize: nameSize,
                                textColor: GameColors.mapAppBarWhiteHint,
                                strokeColor: const Color.fromARGB(
                                  255,
                                  71,
                                  49,
                                  11,
                                ),
                                shadowColor: GameColors.mapAppBarBrownText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (p < 1.0)
                  Opacity(
                    opacity: (1 - p).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: borderColor, width: 3),
                            ),
                            child: _buildStrokedText(
                              _formatFullPoints(widget.coins),
                              fontSize: 20,
                              textColor: GameColors.white,
                              strokeColor: borderColor,
                              shadowColor: borderColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
