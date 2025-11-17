import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';
import '../../../story/presentation/providers/story_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';

/// Main app shell with bottom navigation bar
class AppShellScreen extends ConsumerStatefulWidget {
  const AppShellScreen({super.key});

  @override
  ConsumerState<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends ConsumerState<AppShellScreen> {
  int _selectedIndex = 0;

  // Main screens for bottom navigation
  static const List<Widget> _screens = [
    HomeScreen(),
    LibraryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentKidProfile = ref.watch(currentKidProfileProvider);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: currentKidProfile.maybeWhen(
        data: (profile) {
          if (profile == null) return null;
          return FloatingActionButton.extended(
            onPressed: () => _showStoryTypeDialog(context, profile),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Create Story'),
            backgroundColor: AppColors.primary,
          );
        },
        orElse: () => null,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.list_outlined,
                  selectedIcon: Icons.list,
                  label: 'Library',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: 'Settings',
                  index: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24.0,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryTypeDialog(BuildContext context, dynamic profile) {
    final currentUser = ref.read(currentUserProvider).value;
    final aiStoryCountAsync = ref.read(aiStoryCountProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Story'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Generate AI Story'),
              subtitle: aiStoryCountAsync.when(
                data: (count) {
                  final limit = AppConstants.getAIStoryLimit(
                    currentUser?.subscriptionTier ?? 'free',
                  );
                  if (limit != -1 && count >= limit) {
                    return const Text(
                      'Limit reached. Upgrade to create more!',
                      style: TextStyle(color: AppColors.error),
                    );
                  }
                  return Text(limit == -1 ? 'Unlimited' : '${limit - count} remaining');
                },
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text(''),
              ),
              onTap: () {
                aiStoryCountAsync.whenData((count) {
                  final limit = AppConstants.getAIStoryLimit(
                    currentUser?.subscriptionTier ?? 'free',
                  );
                  if (limit != -1 && count >= limit) {
                    Navigator.of(context).pop();
                    _showUpgradeDialog(context);
                    return;
                  }

                  Navigator.of(context).pop();
                  context.go(AppRoutes.storyWizard);
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Write Manual Story'),
              subtitle: const Text('Create your own story'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Manual story creation coming soon!'),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade Required'),
        content: const Text(
          'You\'ve reached your AI story limit. Upgrade to Premium or Premium+ '
          'to generate unlimited stories!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription management coming soon!'),
                ),
              );
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}
