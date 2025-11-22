import 'package:flutter/material.dart';

/// Animated text widget for onboarding slides
/// Old text slides out/fades, new text pops in with bounce
class AnimatedOnboardingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const AnimatedOnboardingText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.center,
  });

  @override
  State<AnimatedOnboardingText> createState() => _AnimatedOnboardingTextState();
}

class _AnimatedOnboardingTextState extends State<AnimatedOnboardingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String _currentText = '';
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Slide animation for new text (comes from right)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Fade in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Scale animation (pop in with bounce)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedOnboardingText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _previousText = _currentText;
      _currentText = widget.text;

      // Reset and replay animation
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Text(
                _currentText,
                style: widget.style,
                textAlign: widget.textAlign,
              ),
            ),
          ),
        );
      },
    );
  }
}
