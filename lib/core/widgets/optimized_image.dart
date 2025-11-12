import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shimmer_loading.dart';
import '../theme/app_colors.dart';

/// Optimized image widget with caching, loading, and error states
class OptimizedImage extends StatelessWidget {
  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.semanticLabel,
    this.errorIcon = Icons.broken_image_outlined,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final IconData errorIcon;

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildError(),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        errorIcon,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}

/// Avatar image with loading and error states
class OptimizedAvatar extends StatelessWidget {
  const OptimizedAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40.0,
    this.semanticLabel,
  });

  final String imageUrl;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Profile picture',
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerLoading(
            child: Container(
              width: size,
              height: size,
              color: Colors.grey[300],
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            color: AppColors.primary.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Story cover image with optimized loading
class StoryCoverImage extends StatelessWidget {
  const StoryCoverImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.semanticLabel,
  });

  final String imageUrl;
  final double aspectRatio;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Story cover image',
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerLoading(
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Thumbnail image with tap to view full screen
class OptimizedThumbnail extends StatelessWidget {
  const OptimizedThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 80.0,
    this.onTap,
    this.semanticLabel,
  });

  final String imageUrl;
  final double size;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Thumbnail image',
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => ShimmerLoading(
              child: Container(
                width: size,
                height: size,
                color: Colors.grey[300],
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: size,
              height: size,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
