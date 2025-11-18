import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

/// Subscription tiers and upgrade screen
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings_ro.dart';

/// Subscription/pricing screen showing available tiers
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringsRo.subscription),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header
          Text(
            'Alege Planul Perfect Pentru Tine',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Descoperă magia poveștilor personalizate!',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32.0),

          // Free Tier
          _SubscriptionCard(
            tier: AppConstants.tierFree,
            title: AppStringsRo.free,
            price: '0 LEI',
            priceSubtitle: 'Gratis pentru totdeauna',
            features: const [
              '1 profil copil',
              '2 povești AI/lună',
              '5 povești pre-făcute',
              'Citire offline: Nu',
              'Audio narațiune: Nu',
            ],
            color: Colors.grey,
            isCurrentPlan: true,
            onTap: null,
          ),

          const SizedBox(height: 16.0),

          // Premium Tier
          _SubscriptionCard(
            tier: AppConstants.tierPremium,
            title: AppStringsRo.premium,
            price: '${AppConstants.premiumPrice} LEI',
            priceSubtitle: 'pe lună',
            features: const [
              '3 profile copii',
              '20 povești AI/lună',
              'Povești nelimitate pre-făcute',
              '10 descărcări offline',
              'Audio narațiune activată',
              'Toate stilurile artistice',
            ],
            color: AppColors.secondary,
            isPopular: true,
            isCurrentPlan: false,
            onTap: () => _showComingSoonDialog(context),
          ),

          const SizedBox(height: 16.0),

          // Premium+ Tier
          _SubscriptionCard(
            tier: AppConstants.tierPremiumPlus,
            title: AppStringsRo.premiumPlus,
            price: '${AppConstants.premiumPlusPrice} LEI',
            priceSubtitle: 'pe lună',
            features: const [
              'Profile copii NELIMITATE',
              'Povești AI NELIMITATE',
              'Povești pre-făcute NELIMITATE',
              'Descărcări offline NELIMITATE',
              'Audio narațiune premium',
              'Fotografia copilului în poveste',
              'Export PDF',
              'Suport prioritar',
            ],
            color: AppColors.accent,
            isPremiumPlus: true,
            isCurrentPlan: false,
            onTap: () => _showComingSoonDialog(context),
          ),

          const SizedBox(height: 32.0),

          // Features comparison
          _buildFeaturesComparison(textTheme),

          const SizedBox(height: 32.0),

          // FAQ Section
          _buildFAQ(textTheme),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildFeaturesComparison(TextTheme textTheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compară Planurile',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildComparisonRow('Profile Copii', '1', '3', 'Nelimitate'),
            _buildComparisonRow('Povești AI/lună', '2', '20', 'Nelimitate'),
            _buildComparisonRow('Descărcări Offline', '-', '10', 'Nelimitate'),
            _buildComparisonRow('Audio Narațiune', '-', '✓', '✓'),
            _buildComparisonRow('Foto în Poveste', '-', '-', '✓'),
            _buildComparisonRow('Export PDF', '-', '-', '✓'),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String feature, String free, String premium, String premiumPlus) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(child: Text(free, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          Expanded(child: Text(premium, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          Expanded(child: Text(premiumPlus, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accent))),
        ],
      ),
    );
  }

  Widget _buildFAQ(TextTheme textTheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Întrebări Frecvente',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildFAQItem(
              'Pot anula oricând?',
              'Da! Poți anula abonamentul oricând din setări. Nu există taxe de anulare.',
            ),
            _buildFAQItem(
              'Ce se întâmplă cu poveștile mele?',
              'Poveștile create rămân salvate chiar și după anularea abonamentului.',
            ),
            _buildFAQItem(
              'Cum funcționează perioada de probă?',
              'Primele 7 zile sunt gratuite pentru Premium și Premium+. Poți anula oricând.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4.0),
          Text(
            answer,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disponibil În Curând'),
        content: const Text(
          'Sistemul de abonamente va fi disponibil în curând! '
          'Te vei putea abona direct din aplicație folosind Google Play.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Subscription plan card widget
class _SubscriptionCard extends StatelessWidget {
  final String tier;
  final String title;
  final String price;
  final String priceSubtitle;
  final List<String> features;
  final Color color;
  final bool isPopular;
  final bool isPremiumPlus;
  final bool isCurrentPlan;
  final VoidCallback? onTap;

  const _SubscriptionCard({
    required this.tier,
    required this.title,
    required this.price,
    required this.priceSubtitle,
    required this.features,
    required this.color,
    this.isPopular = false,
    this.isPremiumPlus = false,
    this.isCurrentPlan = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: isPremiumPlus ? 8 : isPopular ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPremiumPlus
                ? BorderSide(color: color, width: 2)
                : isPopular
                    ? BorderSide(color: color, width: 1.5)
                    : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isCurrentPlan)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Planul Curent',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: textTheme.headlineMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          priceSubtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Features
                  ...features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: color,
                              size: 20,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                feature,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 16.0),

                  // Button
                  if (!isCurrentPlan)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Alege ${title}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Popular badge
        if (isPopular)
          Positioned(
            top: -10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'CEL MAI POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
