import 'package:flutter/material.dart';

/// Custom clipper that creates a wave-like shape at the bottom
/// of the onboarding image area
class OnboardingWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top-left corner
    path.lineTo(0, 0);

    // Line to top-right corner
    path.lineTo(size.width, 0);

    // Line down to start of wave (about 85% of height)
    path.lineTo(size.width, size.height * 0.85);

    // Create smooth wave using cubic bezier curves
    // First wave curve (right to center)
    path.cubicTo(
      size.width * 0.75, // control point 1 x
      size.height * 0.90, // control point 1 y
      size.width * 0.6,   // control point 2 x
      size.height * 0.95, // control point 2 y
      size.width * 0.5,   // end point x
      size.height * 0.93, // end point y
    );

    // Second wave curve (center to left)
    path.cubicTo(
      size.width * 0.4,   // control point 1 x
      size.height * 0.91, // control point 1 y
      size.width * 0.25,  // control point 2 x
      size.height * 0.88, // control point 2 y
      0,                  // end point x
      size.height * 0.85, // end point y
    );

    // Line to bottom-left corner and close path
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
