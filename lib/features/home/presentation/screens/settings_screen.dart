import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Settings screen with account management and app preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final currentUserAsync = ref.watch(currentUserProvider);
    final authController = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: currentUserAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text(
                'Please log in',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return ListView(
            children: [
              // Account Section
              _SectionHeader(title: 'Account'),
              _SettingsTile(
                icon: Icons.person,
                title: 'Email',
                subtitle: user.email,
                onTap: null, // Email is read-only
              ),
              _SettingsTile(
                icon: Icons.badge,
                title: 'Display Name',
                subtitle: user.displayName ?? 'Not set',
                onTap: () {
                  _showEditDisplayNameDialog(context, ref, user.displayName);
                },
              ),

              const Divider(height: 32.0),

              // App Preferences Section
              _SectionHeader(title: 'Preferences'),
              _SettingsTile(
                icon: Icons.palette,
                title: 'Theme',
                subtitle: 'Light mode',
                onTap: () {
                  // TODO: Implement theme selection when ready
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Theme selection coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  // TODO: Implement notifications settings when ready
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification settings coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const Divider(height: 32.0),

              // About Section
              _SectionHeader(title: 'About'),
              _SettingsTile(
                icon: Icons.info,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: null,
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                onTap: () {
                  // TODO: Open privacy policy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening privacy policy...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'View terms of service',
                onTap: () {
                  // TODO: Open terms of service
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening terms of service...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const Divider(height: 32.0),

              // Danger Zone
              _SectionHeader(title: 'Account Actions', isError: true),
              _SettingsTile(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                iconColor: AppColors.warning,
                onTap: () {
                  _showSignOutDialog(context, authController);
                },
              ),
              _SettingsTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account and all data',
                iconColor: AppColors.error,
                onTap: () {
                  _showDeleteAccountDialog(context, ref);
                },
              ),

              const SizedBox(height: 32.0),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80.0,
                color: AppColors.error,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Error loading user data',
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

  void _showEditDisplayNameDialog(
    BuildContext context,
    WidgetRef ref,
    String? currentName,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Display Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement update display name when auth repository supports it
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Display name update coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(
    BuildContext context,
    AuthController authController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await authController.signOut();
              if (success && context.mounted) {
                // Navigation will be handled by auth redirect in router
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signed out successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            const SizedBox(width: 8.0),
            const Text('Delete Account'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action cannot be undone. All your data including:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text('• Kid profiles'),
            const Text('• All stories'),
            const Text('• Account information'),
            const SizedBox(height: 16.0),
            const Text(
              'will be permanently deleted.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Type DELETE to confirm',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (confirmController.text.trim() == 'DELETE') {
                Navigator.pop(dialogContext);
                _performDeleteAccount(context, ref);
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Please type DELETE to confirm'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteAccount(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16.0),
                const Text('Deleting account...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // TODO: Implement actual account deletion when repository supports it
      // This would include:
      // 1. Delete all kid profiles
      // 2. Delete all stories
      // 3. Delete user document
      // 4. Delete Firebase Auth account

      await Future.delayed(const Duration(seconds: 2)); // Simulate deletion

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deletion feature coming soon!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isError;

  const _SectionHeader({
    required this.title,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isError ? AppColors.error : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right)
          : null,
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}
