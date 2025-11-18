import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Animated story card with beautiful hover and tap effects
class AnimatedStoryCard extends StatefulWidget {
  final String title;
  final String excerpt;
  final String? imageUrl;
  final String genre;
  final VoidCallback onTap;
  final int index;

  const AnimatedStoryCard({
    super.key,
    required this.title,
    required this.excerpt,
    this.imageUrl,
    required this.genre,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<AnimatedStoryCard> createState() => _AnimatedStoryCardState();
}

class _AnimatedStoryCardState extends State<AnimatedStoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0),
          child: Card(
            elevation: _isHovered ? 8 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with gradient overlay
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Image or placeholder
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _getGenreColors(widget.genre),
                          ),
                        ),
                        child: widget.imageUrl != null
                            ? Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                      // Gradient overlay
                      Container(
                        height: 150,
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
                      // Genre badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.genre,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            widget.excerpt,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.auto_stories,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Citește',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: AppColors.textSecondary,
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
        ),
      ),
    ).animate().fadeIn(
      duration: 300.ms,
      delay: (widget.index * 100).ms,
    ).slideY(
      begin: 0.2,
      end: 0,
      duration: 400.ms,
      delay: (widget.index * 100).ms,
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.auto_stories,
        size: 64,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }

  List<Color> _getGenreColors(String genre) {
    switch (genre.toLowerCase()) {
      case 'adventure':
      case 'aventură':
        return [Colors.orange.shade400, Colors.deepOrange.shade600];
      case 'fantasy':
      case 'fantezie':
        return [Colors.purple.shade400, Colors.deepPurple.shade600];
      case 'sci-fi':
        return [Colors.blue.shade400, Colors.indigo.shade600];
      case 'mystery':
      case 'mister':
        return [Colors.grey.shade700, Colors.grey.shade900];
      case 'funny':
      case 'amuzant':
        return [Colors.yellow.shade400, Colors.amber.shade600];
      case 'magical':
        return [Colors.pink.shade400, Colors.purple.shade600];
      case 'school':
      case 'școală':
        return [Colors.green.shade400, Colors.teal.shade600];
      case 'spooky':
      case 'înfiorător':
        return [Colors.deepPurple.shade800, Colors.black];
      case 'bedtime':
        return [Colors.indigo.shade300, Colors.blue.shade700];
      case 'learning':
        return [Colors.cyan.shade400, Colors.blue.shade600];
      default:
        return [AppColors.primary, AppColors.secondary];
    }
  }
}
