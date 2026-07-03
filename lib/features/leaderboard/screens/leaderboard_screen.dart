import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  final ScrollController scrollController;

  const LeaderboardScreen({super.key, required this.scrollController});

  Widget _buildPodiumColumn(
    BuildContext context, {
    required int rank,
    required String name,
    required String score,
    required double height,
    required Color color,
    required IconData avatarIcon,
  }) {
    final isFirst = rank == 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(
              Icons.workspace_premium,
              color: Color(0xFFFFB300),
              size: 48,
            ),
          ),
        Container(
          padding: EdgeInsets.all(isFirst ? 6 : 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF3E2723), width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 4)),
            ],
          ),
          child: CircleAvatar(
            radius: isFirst ? 34 : 28,
            backgroundColor: Colors.white,
            child: Icon(avatarIcon, size: isFirst ? 40 : 32, color: color),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3E2723), width: 2.5),
            boxShadow: const [
              BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              Text(
                name,
                style: GoogleFonts.luckiestGuy(
                  color: const Color(0xFF3E2723),
                  fontSize: isFirst ? 16 : 14,
                  letterSpacing: 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: color, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    score,
                    style: const TextStyle(
                      color: Color(0xFF3E2723),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: isFirst ? 100 : 85,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: const Color(0xFF3E2723), width: 3.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF3E2723),
                offset: Offset(0, -3), // Inner depth feeling
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$rank',
            style: GoogleFonts.luckiestGuy(
              color: Colors.white,
              fontSize: isFirst ? 56 : 44,
              shadows: const [
                Shadow(color: Color(0xFF3E2723), offset: Offset(0, 3)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard({
    required int rank,
    required String name,
    required String score,
    required IconData avatarIcon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7), // Light sand
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3E2723), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF3E2723),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: GoogleFonts.luckiestGuy(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          // Avatar
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: iconColor, width: 2.5),
            ),
            child: Icon(avatarIcon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.luckiestGuy(
                color: const Color(0xFF3E2723),
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // Score Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50), // Vibrant Green
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF3E2723), width: 2.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.yellow, size: 18),
                const SizedBox(width: 6),
                Text(
                  score,
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: MediaQuery.of(context).padding.top + 90.0,
        bottom: 120.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Icon(
          //       Icons.emoji_events,
          //       color: Color(0xFFFFB300),
          //       size: 40,
          //     ),
          //     const SizedBox(width: 12),
          //     _buildStrokedText('LEADERBOARD', fontSize: 32),
          //   ],
          // ),
          // const SizedBox(height: 32),

          // Podium Section
          SizedBox(
            height: 380,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPodiumColumn(
                  context,
                  rank: 2,
                  name: 'Karem',
                  score: '4500',
                  height: 100,
                  color: const Color(0xFF29B6F6), // Vibrant Blue
                  avatarIcon: Icons.pets,
                ),
                const SizedBox(width: 12),
                _buildPodiumColumn(
                  context,
                  rank: 1,
                  name: 'You',
                  score: '6200',
                  height: 140,
                  color: const Color(0xFFFFB300), // Bright Gold/Orange
                  avatarIcon: Icons.face,
                ),
                const SizedBox(width: 12),
                _buildPodiumColumn(
                  context,
                  rank: 3,
                  name: 'Guest',
                  score: '3100',
                  height: 80,
                  color: const Color(0xFF66BB6A), // Playful Green
                  avatarIcon: Icons.rocket_launch,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // List Section
          _ScrollScalingCard(
            scrollController: scrollController,
            child: _buildLeaderboardCard(
              rank: 4,
              name: 'Player 4',
              score: '2800',
              avatarIcon: Icons.star,
              iconColor: Colors.blue,
            ),
          ),
          _ScrollScalingCard(
            scrollController: scrollController,
            child: _buildLeaderboardCard(
              rank: 5,
              name: 'Player 5',
              score: '2100',
              avatarIcon: Icons.bolt,
              iconColor: Colors.deepPurple,
            ),
          ),
          _ScrollScalingCard(
            scrollController: scrollController,
            child: _buildLeaderboardCard(
              rank: 6,
              name: 'Player 6',
              score: '1500',
              avatarIcon: Icons.favorite,
              iconColor: Colors.redAccent,
            ),
          ),
          _ScrollScalingCard(
            scrollController: scrollController,
            child: _buildLeaderboardCard(
              rank: 7,
              name: 'Player 7',
              score: '900',
              avatarIcon: Icons.eco,
              iconColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollScalingCard extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const _ScrollScalingCard({
    required this.scrollController,
    required this.child,
  });

  @override
  State<_ScrollScalingCard> createState() => _ScrollScalingCardState();
}

class _ScrollScalingCardState extends State<_ScrollScalingCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.scrollController,
      builder: (context, child) {
        double scale = 0.8;

        final renderObject = context.findRenderObject();
        if (renderObject is RenderBox && renderObject.hasSize) {
          final offsetY = renderObject.localToGlobal(Offset.zero).dy;
          final screenHeight = MediaQuery.of(context).size.height;

          double normalizedY = (offsetY / screenHeight).clamp(0.0, 1.0);

          if (normalizedY > 0.75) {
            double ratio = (normalizedY - 0.75) / 0.25;
            scale = 1.0 - (ratio * 0.2);
          } else {
            scale = 1.0;
          }
        }

        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
