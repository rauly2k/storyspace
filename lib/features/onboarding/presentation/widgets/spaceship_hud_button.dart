import 'package:flutter/material.dart';

/// Spaceship HUD-style semi-transparent capsule button
/// Styled like a sci-fi interface element
class SpaceshipHudButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SpaceshipHudButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            // Semi-transparent background
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            // HUD-style border
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            // Subtle glow
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
