import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/preferences_service.dart';

/// Splash screen with logo and fade-in animation
/// Shows briefly before navigating to onboarding or home based on auth state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if onboarding has been completed
    final onboardingCompleted = await PreferencesService.isOnboardingCompleted();

    // Navigate to appropriate screen
    if (onboardingCompleted) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/LoadingSc2.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
