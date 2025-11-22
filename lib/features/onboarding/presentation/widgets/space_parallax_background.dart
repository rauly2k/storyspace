import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Parallax background with three layers creating 3D depth effect
/// Layer 1: Distant stars (slow movement)
/// Layer 2: Planets and nebulae (medium movement)
/// Layer 3: Main content (moves with page)
class SpaceParallaxBackground extends StatelessWidget {
  final double pageOffset;
  final int currentPage;

  const SpaceParallaxBackground({
    super.key,
    required this.pageOffset,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep space gradient background
        _buildSpaceGradient(),

        // Layer 1: Distant stars (very slow parallax)
        _buildDistantStars(pageOffset * 0.1),

        // Layer 2: Planets and nebulae (medium parallax)
        _buildPlanetsAndNebulae(pageOffset * 0.3),

        // Subtle nebula overlay
        _buildNebulaOverlay(),
      ],
    );
  }

  /// Deep purple space gradient extending to bottom of screen
  Widget _buildSpaceGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A0B2E), // Deep purple
            Color(0xFF2D1B4E), // Medium purple
            Color(0xFF3B2667), // Lighter purple
            Color(0xFF4A1E7C), // Purple with hint of magenta
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  /// Layer 1: Small twinkling distant stars
  Widget _buildDistantStars(double offset) {
    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(offset * 50, 0),
        child: CustomPaint(
          painter: _DistantStarsPainter(),
        ),
      ),
    );
  }

  /// Layer 2: Larger planets and colorful nebulae
  Widget _buildPlanetsAndNebulae(double offset) {
    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(offset * 100, 0),
        child: CustomPaint(
          painter: _PlanetsAndNebulaePainter(currentPage),
        ),
      ),
    );
  }

  /// Subtle nebula color overlay for depth
  Widget _buildNebulaOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              const Color(0xFFFF6B9D).withOpacity(0.05), // Pink nebula
              const Color(0xFF4ECDC4).withOpacity(0.05), // Turquoise nebula
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Painter for distant twinkling stars
class _DistantStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Generate deterministic stars using seeded random
    final random = math.Random(42);

    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width * 1.5;
      final y = random.nextDouble() * size.height;
      final opacity = 0.3 + random.nextDouble() * 0.7;
      final starSize = 1.0 + random.nextDouble() * 2.0;

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for planets and nebulae
class _PlanetsAndNebulaePainter extends CustomPainter {
  final int currentPage;

  _PlanetsAndNebulaePainter(this.currentPage);

  @override
  void paint(Canvas canvas, Size size) {
    // Planet positions change based on current page
    _drawPlanet1(canvas, size);
    _drawPlanet2(canvas, size);
    _drawColorfulNebulae(canvas, size);
  }

  void _drawPlanet1(Canvas canvas, Size size) {
    final planetPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF9B59B6).withOpacity(0.4),
          const Color(0xFF8E44AD).withOpacity(0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.15, size.height * 0.2),
        radius: 80,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.2),
      80,
      planetPaint,
    );
  }

  void _drawPlanet2(Canvas canvas, Size size) {
    final planetPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4ECDC4).withOpacity(0.3),
          const Color(0xFF45B7AF).withOpacity(0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.6),
        radius: 60,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.6),
      60,
      planetPaint,
    );
  }

  void _drawColorfulNebulae(Canvas canvas, Size size) {
    // Pink nebula
    final pinkNebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6B9D).withOpacity(0.15),
          const Color(0xFFFF6B9D).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.7, size.height * 0.3),
        radius: 120,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      120,
      pinkNebulaPaint,
    );

    // Turquoise nebula
    final turquoiseNebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4ECDC4).withOpacity(0.12),
          const Color(0xFF4ECDC4).withOpacity(0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.3, size.height * 0.7),
        radius: 100,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.7),
      100,
      turquoiseNebulaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlanetsAndNebulaePainter oldDelegate) =>
      currentPage != oldDelegate.currentPage;
}
