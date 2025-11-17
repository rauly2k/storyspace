import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/constants/app_strings_ro.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';

/// Screen showing reading progress and stats
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final currentKidProfileAsync = ref.watch(currentKidProfileProvider);

    return AnimatedBackground(
      child: SafeArea(
        child: currentKidProfileAsync.when(
          data: (profile) {
            if (profile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 64.0,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppStringsRo.noProfileSelected,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return _buildProgressContent(context, profile.name, textTheme);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64.0,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16.0),
                Text(
                  AppStringsRo.errorLoadingProfile,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressContent(
    BuildContext context,
    String kidName,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStringsRo.progressTitle} $kidName',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: 8.0),
                Text(
                  AppStringsRo.trackReadingJourney,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
              ],
            ),
          ),

          // Stats Overview Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.book,
                    value: '12',
                    label: AppStringsRo.storiesRead,
                    color: AppColors.primary,
                    textTheme: textTheme,
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms).scale(
                        duration: 600.ms,
                        delay: 300.ms,
                        curve: Curves.easeOutBack,
                      ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer,
                    value: '3h 45m',
                    label: AppStringsRo.readingTimeTotal,
                    color: AppColors.secondary,
                    textTheme: textTheme,
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms).scale(
                        duration: 600.ms,
                        delay: 400.ms,
                        curve: Curves.easeOutBack,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Streak Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildStreakCard(textTheme)
                .animate()
                .fadeIn(duration: 600.ms, delay: 500.ms)
                .scale(
                  duration: 600.ms,
                  delay: 500.ms,
                  curve: Curves.easeOutBack,
                ),
          ),

          const SizedBox(height: 24.0),

          // Achievements Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppStringsRo.achievements,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
          ),

          const SizedBox(height: 12.0),

          _buildAchievementsList(textTheme),

          const SizedBox(height: 24.0),

          // Reading Activity Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppStringsRo.readingActivity,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
          ),

          const SizedBox(height: 12.0),

          _buildReadingActivityChart(textTheme),

          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required TextTheme textTheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 32.0,
          ),
          const SizedBox(height: 12.0),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD93D),
            Color(0xFFFFC75F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD93D).withOpacity(0.3),
            blurRadius: 15.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 40.0,
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7 ${AppStringsRo.dayStreak}',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  AppStringsRo.keepReadingStreak,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(TextTheme textTheme) {
    final achievements = [
      {
        'icon': Icons.auto_stories,
        'title': AppStringsRo.achievementFirstStory,
        'description': AppStringsRo.achievementFirstStoryDesc,
        'unlocked': true,
        'color': AppColors.primary,
      },
      {
        'icon': Icons.emoji_events,
        'title': AppStringsRo.achievement10Stories,
        'description': AppStringsRo.achievement10StoriesDesc,
        'unlocked': true,
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.star,
        'title': AppStringsRo.achievementWeekWarrior,
        'description': AppStringsRo.achievementWeekWarriorDesc,
        'unlocked': true,
        'color': AppColors.accent,
      },
      {
        'icon': Icons.workspace_premium,
        'title': AppStringsRo.achievementStoryMaster,
        'description': AppStringsRo.achievementStoryMasterDesc,
        'unlocked': false,
        'color': AppColors.textLight,
      },
    ];

    return SizedBox(
      height: 180.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final isUnlocked = achievement['unlocked'] as bool;
          final color = achievement['color'] as Color;

          return Container(
            width: 140.0,
            margin: const EdgeInsets.only(right: 12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color.withOpacity(0.1)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: isUnlocked
                    ? color.withOpacity(0.3)
                    : AppColors.textLight.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isUnlocked ? color : AppColors.textLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  achievement['title'] as String,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? color : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  achievement['description'] as String,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ).animate().fadeIn(
                duration: 600.ms,
                delay: (700 + (index * 100)).ms,
              );
        },
      ),
    );
  }

  Widget _buildReadingActivityChart(TextTheme textTheme) {
    final days = [
      AppStringsRo.monday,
      AppStringsRo.tuesday,
      AppStringsRo.wednesday,
      AppStringsRo.thursday,
      AppStringsRo.friday,
      AppStringsRo.saturday,
      AppStringsRo.sunday,
    ];
    final values = [2, 3, 1, 4, 2, 5, 3]; // Stories read per day

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStringsRo.thisWeek,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final height = (values[index] / 5) * 100.0;
              return Column(
                children: [
                  Container(
                    width: 32.0,
                    height: height.clamp(20.0, 100.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    days[index],
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ).animate().fadeIn(
                    duration: 600.ms,
                    delay: (800 + (index * 100)).ms,
                  ).slideY(
                    begin: 0.5,
                    end: 0,
                    duration: 600.ms,
                    delay: (800 + (index * 100)).ms,
                    curve: Curves.easeOutBack,
                  );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 800.ms);
  }
}
