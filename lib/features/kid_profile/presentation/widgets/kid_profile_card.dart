import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/kid_profile_entity.dart';

/// Kid profile card widget with age bucket colors
class KidProfileCard extends StatelessWidget {
  final KidProfileEntity profile;
  final VoidCallback onTap;

  const KidProfileCard({
    super.key,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ageBucketColor = AppColors.getAgeBucketColor(profile.ageBucket);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ageBucketColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo section with gradient overlay
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildPhoto(),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ageBucketColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Age bucket badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ageBucketColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        profile.ageBucket.toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info section
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ageBucketColor.withOpacity(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name
                    Text(
                      profile.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Age
                    Row(
                      children: [
                        Icon(
                          Icons.cake,
                          size: 14,
                          color: ageBucketColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.ageDisplay,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profile.photoUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    final ageBucketColor = AppColors.getAgeBucketColor(profile.ageBucket);

    return Container(
      color: ageBucketColor.withOpacity(0.2),
      child: Center(
        child: Text(
          profile.initial,
          style: AppTextStyles.displayLarge.copyWith(
            color: ageBucketColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
