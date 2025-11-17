import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../story/domain/entities/story_entity.dart';

/// Featured story carousel with smooth transitions and page indicators
class FeaturedStoryCarousel extends StatefulWidget {
  final List<StoryEntity> stories;
  final Function(StoryEntity) onStoryTap;

  const FeaturedStoryCarousel({
    super.key,
    required this.stories,
    required this.onStoryTap,
  });

  @override
  State<FeaturedStoryCarousel> createState() => _FeaturedStoryCarouselState();
}

class _FeaturedStoryCarouselState extends State<FeaturedStoryCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.stories.length,
          itemBuilder: (context, index, realIndex) {
            final story = widget.stories[index];
            return _FeaturedStoryCard(
              story: story,
              onTap: () => widget.onStoryTap(story),
            ).animate().fadeIn(duration: 500.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                );
          },
          options: CarouselOptions(
            height: 140, // Reduced from 280 to 140 (50% smaller)
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enlargeFactor: 0.25,
            enableInfiniteScroll: widget.stories.length > 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        // Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.stories.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _currentIndex == entry.key ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _currentIndex == entry.key
                      ? AppColors.primaryGradient
                      : null,
                  color: _currentIndex == entry.key
                      ? null
                      : AppColors.textLight.withOpacity(0.4),
                ),
              )
                  .animate(
                    target: _currentIndex == entry.key ? 1 : 0,
                  )
                  .scaleX(
                    begin: 1,
                    end: 3,
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Individual featured story card
class _FeaturedStoryCard extends StatelessWidget {
  final StoryEntity story;
  final VoidCallback onTap;

  const _FeaturedStoryCard({
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Story Cover Image
              _buildCoverImage(),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Story Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genre Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getGenreColor(story.genre).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          story.genre,
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Story Title
                      Text(
                        story.title,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Reading Time
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            story.readingTimeDisplay,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Featured',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    if (story.coverImageUrl != null && story.coverImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: story.coverImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.getGenreColor(story.genre).withOpacity(0.6),
            AppColors.getGenreColor(story.genre).withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_stories,
          size: 80,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
