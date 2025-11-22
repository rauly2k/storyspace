import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/preferences_service.dart';
import '../widgets/space_parallax_background.dart';
import '../widgets/glassmorphic_content_card.dart';
import '../widgets/rocket_progress_indicator.dart';
import '../widgets/pulsing_gradient_button.dart';
import '../widgets/animated_onboarding_text.dart';
import '../widgets/spaceship_hud_button.dart';

/// Immersive space-themed onboarding screen with parallax effects
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _pageOffset = 0.0;

  // Image assets for each slide (bear astronaut character)
  final List<String> _imageAssets = [
    'assets/images/onb1.png',
    'assets/images/onb2.png',
    'assets/images/onb3.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    setState(() {
      _pageOffset = _pageController.page ?? 0.0;
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < AppConstants.onboardingSlideCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    // Mark onboarding as completed
    await PreferencesService.setOnboardingCompleted();

    // Navigate to login screen
    if (mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background images
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: AppConstants.onboardingSlideCount,
            itemBuilder: (context, index) {
              return Image.asset(
                _imageAssets[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to parallax background if image fails to load
                  return SpaceParallaxBackground(
                    pageOffset: _pageOffset,
                    currentPage: _currentPage,
                  );
                },
              );
            },
          ),

          // Main content overlaid on top
          SafeArea(
            child: Column(
              children: [
                // Skip button at top right (HUD style)
                if (_currentPage < AppConstants.onboardingSlideCount - 1)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, right: 24.0),
                      child: SpaceshipHudButton(
                        text: 'SKIP',
                        onPressed: _skipOnboarding,
                      ),
                    ),
                  ),

                const Spacer(),

                // Glassmorphic content card at bottom
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GlasmorphicContentCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated title with text shadow
                        AnimatedOnboardingText(
                          text: AppConstants.onboardingSlides[_currentPage]['title']!,
                          style: GoogleFonts.quicksand(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16.0),

                        // Animated description with cream color
                        AnimatedOnboardingText(
                          text: AppConstants.onboardingSlides[_currentPage]['description']!,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFFFF8F0), // Cream color
                            height: 1.5,
                            shadows: [
                              const Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32.0),

                        // Rocket ship progress indicator
                        RocketProgressIndicator(
                          currentPage: _currentPage,
                          totalPages: AppConstants.onboardingSlideCount,
                        ),

                        const SizedBox(height: 32.0),

                        // Pulsing gradient button
                        PulsingGradientButton(
                          text: _currentPage == AppConstants.onboardingSlideCount - 1
                              ? 'Launch Into StorySpace'
                              : 'Continue',
                          onPressed: _nextPage,
                          gradientColors: const [
                            AppColors.secondary, // Turquoise
                            AppColors.primary, // Pink
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
