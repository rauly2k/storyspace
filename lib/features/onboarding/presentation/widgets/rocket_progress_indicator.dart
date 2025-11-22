import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Rocket ship progress indicator that travels across a line
/// Replaces boring dots with an animated rocket for kids
class RocketProgressIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const RocketProgressIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate rocket position (0.0 to 1.0)
    final progress = currentPage / (totalPages - 1);

    return SizedBox(
      width: 200,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress line background
          _buildProgressLine(),

          // Active progress fill
          _buildActiveProgress(progress),

          // Star trail behind rocket
          _buildStarTrail(progress),

          // Rocket ship that travels
          _buildRocket(progress),
        ],
      ),
    );
  }

  /// Background progress line
  Widget _buildProgressLine() {
    return Positioned(
      left: 25,
      right: 25,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Active progress fill that follows the rocket
  Widget _buildActiveProgress(double progress) {
    return Positioned(
      left: 25,
      child: Container(
        width: 150 * progress,
        height: 4,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.secondary, // Turquoise
              AppColors.accent, // Yellow
            ],
          ),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  /// Star trail that follows behind the rocket
  Widget _buildStarTrail(double progress) {
    return Positioned(
      left: 25 + (150 * progress),
      child: Row(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              Icons.star,
              size: 12 - (index * 3),
              color: AppColors.accent.withOpacity(0.7 - (index * 0.2)),
            ),
          ),
        ),
      ),
    );
  }

  /// Rocket ship icon that travels across the line
  Widget _buildRocket(double progress) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 10 + (150 * progress),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary, // Pink
              AppColors.accent, // Yellow
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.rocket_launch,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
