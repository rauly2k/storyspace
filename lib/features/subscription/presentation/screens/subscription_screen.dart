import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

/// Subscription tiers and upgrade screen
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Choose Your Plan',
              style: AppTextStyles.displaySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock unlimited storytelling magic',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Free Tier
            _buildPlanCard(
              context: context,
              tierName: 'Free',
              tierValue: AppConstants.tierFree,
              price: 'Free',
              period: 'Forever',
              color: AppColors.textSecondary,
              features: [
                '${AppConstants.getKidProfileLimit(AppConstants.tierFree)} Kid Profile',
                '${AppConstants.getAIStoryLimit(AppConstants.tierFree)} AI Stories/month',
                'Basic story templates',
                '1 art style',
              ],
              isCurrentPlan: true, // Default to free
            ),

            const SizedBox(height: 16),

            // Premium Tier
            _buildPlanCard(
              context: context,
              tierName: 'Premium',
              tierValue: AppConstants.tierPremium,
              price: '\$9.99',
              period: 'per month',
              color: AppColors.primary,
              features: [
                '${AppConstants.getKidProfileLimit(AppConstants.tierPremium)} Kid Profiles',
                '${AppConstants.getAIStoryLimit(AppConstants.tierPremium)} AI Stories/month',
                'All story templates',
                'All art styles',
                'Audio narration',
                'Priority support',
              ],
              isPopular: true,
            ),

            const SizedBox(height: 16),

            // Premium+ Tier
            _buildPlanCard(
              context: context,
              tierName: 'Premium+',
              tierValue: AppConstants.tierPremiumPlus,
              price: '\$19.99',
              period: 'per month',
              color: AppColors.accent,
              features: [
                'Unlimited Kid Profiles',
                'Unlimited AI Stories',
                'All story templates',
                'All art styles',
                'Audio narration',
                'Custom characters',
                'Priority support',
                'Early access to new features',
              ],
            ),

            const SizedBox(height: 32),

            // Info section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Subscription Information',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem('Cancel anytime, no questions asked'),
                  _buildInfoItem('All stories saved forever'),
                  _buildInfoItem('Secure payment processing'),
                  _buildInfoItem('Free trial available for Premium plans'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Note about implementation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                children: [
                  Icon(Icons.construction, color: AppColors.warning, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Subscription purchasing will be available in the next update.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String tierName,
    required String tierValue,
    required String price,
    required String period,
    required Color color,
    required List<String> features,
    bool isPopular = false,
    bool isCurrentPlan = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? color : AppColors.outline,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          // Popular badge
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan name
                Row(
                  children: [
                    Icon(Icons.star, color: color, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      tierName,
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.displayMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        period,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Features
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 12),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isCurrentPlan
                        ? null
                        : () => _handleSubscribe(context, tierValue),
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isCurrentPlan ? 'Current Plan' : 'Choose $tierName',
                      style: AppTextStyles.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscribe(BuildContext context, String tier) {
    // TODO: Implement actual subscription flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscription to $tier plan will be available soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
