import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/kid_profile_providers.dart';
import '../widgets/kid_profile_card.dart';
import 'create_kid_profile_screen.dart';
import 'edit_kid_profile_screen.dart';

/// Kid profiles list screen with grid of profile cards
class KidProfilesScreen extends ConsumerWidget {
  const KidProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(kidProfilesProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AccessibleHeader(text: 'Kid Profiles'),
        actions: [
          AccessibleIconButton(
            icon: Icons.logout,
            label: 'Sign Out',
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
              AccessibilityUtils.announce(context, 'Signed out successfully');
            },
          ),
        ],
      ),
      body: AsyncValueHandler(
        asyncValue: user,
        loadingBuilder: (context) => _buildLoadingSkeleton(),
        dataBuilder: (context, currentUser) {
          if (currentUser == null) {
            return const EmptyStateDisplay(
              title: 'Not Logged In',
              message: 'Please log in to view your kid profiles.',
              icon: Icons.person_outline,
            );
          }

          return AsyncValueHandler(
            asyncValue: profilesAsync,
            loadingBuilder: (context) => _buildLoadingSkeleton(),
            errorBuilder: (context, error, stack) => AsyncErrorDisplay(
              error: error,
              onRetry: () {
                ref.invalidate(kidProfilesProvider);
              },
            ),
            emptyBuilder: (context) => _buildEmptyState(
              context,
              ref,
              currentUser.subscriptionTier,
            ),
            dataBuilder: (context, profiles) => _buildProfilesGrid(
              context,
              ref,
              profiles,
              currentUser.subscriptionTier,
            ),
          );
        },
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
                onPressed: () => _navigateToCreateProfile(context),
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

  Widget _buildLoadingSkeleton() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => AnimatedGridItem(
        index: index,
        child: const ProfileCardSkeleton(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, String tier) {
    return EmptyStateDisplay(
      title: 'No Kid Profiles Yet!',
      message: 'Create a profile for your child to start your StorySpace adventure!',
      icon: Icons.family_restroom,
      actionLabel: 'Create First Profile',
      onAction: () => _navigateToCreateProfile(context),
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
                return AnimatedGridItem(
                  index: index,
                  child: KidProfileCard(
                    profile: profile,
                    onTap: () => _onProfileTap(context, profile),
                    onEdit: () => _onProfileEdit(context, profile),
                    onDelete: () => _onProfileDelete(context, ref, profile),
                  ),
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
    // Navigate to story library for the selected profile
    context.push(AppRoutes.storyLibrary, extra: profile);
  }

  void _onProfileEdit(BuildContext context, dynamic profile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditKidProfileScreen(profile: profile),
      ),
    );
  }

  void _onProfileDelete(BuildContext context, WidgetRef ref, dynamic profile) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Delete Profile'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete ${profile.name}\'s profile?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This will permanently delete:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• All stories for this profile'),
            const Text('• Profile information and settings'),
            const Text('• Reading history and favorites'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await ref
                  .read(kidProfileControllerProvider.notifier)
                  .deleteKidProfile(profile.id);

              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${profile.name}\'s profile deleted successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  bool _canCreateProfile({
    required int currentProfileCount,
    required String subscriptionTier,
  }) {
    // No limits - all users can create unlimited profiles
    return true;
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
