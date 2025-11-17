import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings_ro.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';

/// Screen showing detailed profile information
class ProfileDetailsScreen extends ConsumerWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final currentKidProfileAsync = ref.watch(currentKidProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStringsRo.profileDetails),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: currentKidProfileAsync.when(
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

          return _buildProfileContent(context, profile, textTheme);
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
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    KidProfileEntity profile,
    TextTheme textTheme,
  ) {
    final ageBucketColor = AppColors.getAgeBucketColor(profile.ageBucket);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ageBucketColor.withOpacity(0.2),
                  ageBucketColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: ageBucketColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // Profile Photo
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ageBucketColor,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ageBucketColor.withOpacity(0.3),
                        blurRadius: 20.0,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 56.0,
                    backgroundColor: ageBucketColor,
                    backgroundImage: profile.photoUrl != null
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    child: profile.photoUrl == null
                        ? Text(
                            profile.initial,
                            style: const TextStyle(
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ).animate().scale(
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    ),
                const SizedBox(height: 24.0),
                // Name
                Text(
                  profile.name,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                const SizedBox(height: 8.0),
                // Age
                Text(
                  profile.ageDisplay,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                const SizedBox(height: 16.0),
                // Age Bucket Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: ageBucketColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    profile.ageBucketDisplay,
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
              ],
            ),
          ),

          // Interests Section
          if (profile.interests.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStringsRo.interests,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: profile.interests.map((interest) {
                  return Chip(
                    label: Text(interest),
                    backgroundColor: ageBucketColor.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: ageBucketColor,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: ageBucketColor.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
            const SizedBox(height: 24.0),
          ],

          // Profile Info Card
          Container(
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
              children: [
                _buildInfoRow(
                  icon: Icons.cake_outlined,
                  label: AppStringsRo.age,
                  value: profile.ageDisplay,
                  textTheme: textTheme,
                ),
                const Divider(height: 24.0),
                _buildInfoRow(
                  icon: Icons.category_outlined,
                  label: AppStringsRo.category,
                  value: profile.ageBucketNameRo.toUpperCase(),
                  textTheme: textTheme,
                  valueColor: ageBucketColor,
                ),
                const Divider(height: 24.0),
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: AppStringsRo.created,
                  value: _formatDate(profile.createdAt),
                  textTheme: textTheme,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 700.ms),

          const SizedBox(height: 32.0),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(AppStringsRo.editProfile),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Switch to another profile
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(AppStringsRo.switchProfile),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 800.ms),

          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required TextTheme textTheme,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: 24.0,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return AppStringsRo.today;
    } else if (difference.inDays < 7) {
      return AppStringsRo.formatRelativeTime(difference.inDays, 'day');
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return AppStringsRo.formatRelativeTime(weeks, 'week');
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return AppStringsRo.formatRelativeTime(months, 'month');
    } else {
      final years = (difference.inDays / 365).floor();
      return AppStringsRo.formatRelativeTime(years, 'year');
    }
  }
}
