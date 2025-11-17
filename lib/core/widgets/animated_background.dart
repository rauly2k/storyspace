import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Animated background with floating clouds and twinkling stars
/// Creates a magical, whimsical atmosphere
class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final bool showStars;
  final bool showClouds;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.showStars = true,
    this.showClouds = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
        ),

        // Floating Stars
        if (showStars) ..._buildStars(),

        // Floating Clouds
        if (showClouds) ..._buildClouds(),

        // Content
        child,
      ],
    );
  }

  List<Widget> _buildStars() {
    return [
      Positioned(
        top: 50,
        left: 30,
        child: _Star(size: 16, delay: 0.ms),
      ),
      Positioned(
        top: 120,
        right: 50,
        child: _Star(size: 12, delay: 500.ms),
      ),
      Positioned(
        top: 200,
        left: 80,
        child: _Star(size: 20, delay: 1000.ms),
      ),
      Positioned(
        top: 80,
        right: 120,
        child: _Star(size: 14, delay: 1500.ms),
      ),
      Positioned(
        bottom: 150,
        left: 40,
        child: _Star(size: 18, delay: 2000.ms),
      ),
      Positioned(
        bottom: 250,
        right: 80,
        child: _Star(size: 10, delay: 2500.ms),
      ),
    ];
  }

  List<Widget> _buildClouds() {
    return [
      Positioned(
        top: 100,
        left: -20,
        child: _Cloud(size: 80, delay: 0.ms, duration: 60.seconds),
      ),
      Positioned(
        top: 180,
        right: -30,
        child: _Cloud(size: 100, delay: 10.seconds, duration: 80.seconds),
      ),
      Positioned(
        top: 300,
        left: -40,
        child: _Cloud(size: 60, delay: 20.seconds, duration: 50.seconds),
      ),
    ];
  }
}

/// Twinkling star widget
class _Star extends StatelessWidget {
  final double size;
  final Duration delay;

  const _Star({
    required this.size,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: size,
      color: AppColors.accent.withOpacity(0.6),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 1.seconds, delay: delay)
        .fadeOut(duration: 1.seconds, delay: 1.seconds + delay)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 2.seconds,
          delay: delay,
        );
  }
}

/// Floating cloud widget
class _Cloud extends StatelessWidget {
  final double size;
  final Duration delay;
  final Duration duration;

  const _Cloud({
    required this.size,
    required this.delay,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .moveX(
          begin: 0,
          end: MediaQuery.of(context).size.width + size,
          duration: duration,
          delay: delay,
          curve: Curves.linear,
        );
  }
}
