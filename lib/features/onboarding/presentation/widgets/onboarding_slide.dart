import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Individual onboarding slide with illustration, title, subtitle, and description
class OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final int slideIndex;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.slideIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder
          _buildIllustration(),
          const SizedBox(height: 48),

          // Title
          Text(
            title,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    // TODO: Replace with actual illustration assets
    // For now, use colorful icon placeholders
    final icons = [
      Icons.auto_stories_rounded,
      Icons.auto_awesome_rounded,
      Icons.rocket_launch_rounded,
    ];

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
    ];

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[slideIndex].withOpacity(0.1),
            colors[slideIndex].withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(
        icons[slideIndex],
        size: 100,
        color: colors[slideIndex],
      ),
    );
  }
}
