import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphic (frosted glass) card for onboarding content
/// Allows space background to show through with subtle blur
class GlasmorphicContentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlasmorphicContentCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8.0, // Subtle blur for readability
          sigmaY: 8.0,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            // Semi-transparent white with gradient for glass effect
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.08),
              ],
            ),
            // Subtle border for definition
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(24.0),
            // Multiple shadows for depth
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF9B59B6).withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
