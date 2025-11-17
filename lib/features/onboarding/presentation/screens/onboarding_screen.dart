import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/preferences_service.dart';
import '../widgets/onboarding_wave_clipper.dart';

/// Onboarding screen with 3 slides introducing the app
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Image assets for each slide
  final List<String> _imageAssets = [
    'assets/images/onboarding_slide1_image.png',
    'assets/images/onboarding_slide2_image.png',
    'assets/images/onboarding_slide3_image.png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Section: Image with Custom Wave Shape
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: AppConstants.onboardingSlideCount,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    // Image with wave clipper
                    ClipPath(
                      clipper: OnboardingWaveClipper(),
                      child: Image.asset(
                        _imageAssets[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        // Fallback for missing images
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.3),
                                  AppColors.secondary.withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getSlideIcon(index),
                                size: 120,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Skip Button (positioned at top-right)
                    if (_currentPage < AppConstants.onboardingSlideCount - 1)
                      Positioned(
                        top: 40.0,
                        right: 24.0,
                        child: TextButton(
                          onPressed: _skipOnboarding,
                          child: Text(
                            'Skip',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Bottom Content Section: Text, Indicator, Button
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Onboarding Title
                    Text(
                      AppConstants.onboardingSlides[_currentPage]['title']!,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16.0),

                    // Onboarding Description
                    Text(
                      AppConstants.onboardingSlides[_currentPage]['description']!,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32.0),

                    // Page Indicator (Dots)
                    _buildPageIndicator(),

                    const SizedBox(height: 32.0),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          _currentPage == AppConstants.onboardingSlideCount - 1
                              ? 'Get Started'
                              : 'Continue',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the page indicator (dots)
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        AppConstants.onboardingSlideCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  /// Returns appropriate icon for each slide (fallback when images are missing)
  IconData _getSlideIcon(int index) {
    final icons = [
      Icons.auto_stories_rounded,
      Icons.auto_awesome_rounded,
      Icons.rocket_launch_rounded,
    ];
    return icons[index];
  }
}
