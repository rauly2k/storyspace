import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/kid_profile_providers.dart';
import '../widgets/kid_profile_card.dart';
import 'create_kid_profile_screen.dart';

/// Kid profiles list screen with grid of profile cards
class KidProfilesScreen extends ConsumerWidget {
  const KidProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(kidProfilesProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kid Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: user.when(
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(child: Text('Please log in'));
          }

          return profilesAsync.when(
            data: (profiles) {
              if (profiles.isEmpty) {
                return _buildEmptyState(context, ref, currentUser.subscriptionTier);
              }

              return _buildProfilesGrid(
                context,
                ref,
                profiles,
                currentUser.subscriptionTier,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading profiles',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: user.maybeWhen(
        data: (currentUser) {
          if (currentUser == null) return null;

          return profilesAsync.maybeWhen(
            data: (profiles) {
              // Check subscription limits
              final canCreate = _canCreateProfile(
                currentProfileCount: profiles.length,
                subscriptionTier: currentUser.subscriptionTier,
              );

              return FloatingActionButton.extended(
                onPressed: canCreate
                    ? () => _navigateToCreateProfile(context)
                    : () => _showUpgradeDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Profile'),
              );
            },
            orElse: () => null,
          );
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, String tier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.family_restroom,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Kid Profiles Yet!',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a profile for your child to start your StorySpace adventure!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreateProfile(context),
              icon: const Icon(Icons.add),
              label: const Text('Create First Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(
    BuildContext context,
    WidgetRef ref,
    List profiles,
    String tier,
  ) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final profile = profiles[index];
                return KidProfileCard(
                  profile: profile,
                  onTap: () => _onProfileTap(context, profile),
                );
              },
              childCount: profiles.length,
            ),
          ),
        ),
        // Show subscription info
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getTierIcon(tier),
                          color: AppColors.getSubscriptionColor(tier),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getTierName(tier)} Plan',
                                style: AppTextStyles.titleMedium,
                              ),
                              Text(
                                '${profiles.length} / ${_getProfileLimit(tier)} profiles',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (tier == AppConstants.tierFree)
                          TextButton(
                            onPressed: () => _showUpgradeDialog(context),
                            child: const Text('Upgrade'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToCreateProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateKidProfileScreen(),
      ),
    );
  }

  void _onProfileTap(BuildContext context, dynamic profile) {
    // TODO: Navigate to home screen with selected profile
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${profile.name}\'s profile'),
      ),
    );
  }

  bool _canCreateProfile({
    required int currentProfileCount,
    required String subscriptionTier,
  }) {
    final limit = AppConstants.getKidProfileLimit(subscriptionTier);
    return currentProfileCount < limit;
  }

  int _getProfileLimit(String tier) {
    return AppConstants.getKidProfileLimit(tier);
  }

  String _getTierName(String tier) {
    switch (tier) {
      case AppConstants.tierFree:
        return 'Free';
      case AppConstants.tierPremium:
        return 'Premium';
      case AppConstants.tierPremiumPlus:
        return 'Premium+';
      default:
        return tier;
    }
  }

  IconData _getTierIcon(String tier) {
    switch (tier) {
      case AppConstants.tierFree:
        return Icons.star_border;
      case AppConstants.tierPremium:
        return Icons.star_half;
      case AppConstants.tierPremiumPlus:
        return Icons.star;
      default:
        return Icons.star_border;
    }
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to Premium', style: AppTextStyles.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You\'ve reached the limit for kid profiles on the Free plan.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Upgrade to Premium for:',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: 8),
            _buildFeature('Up to 3 kid profiles'),
            _buildFeature('20 AI stories per month'),
            _buildFeature('All art styles'),
            _buildFeature('Audio narration'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to subscription screen
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.success),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
