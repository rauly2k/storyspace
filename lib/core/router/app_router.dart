import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/app_shell_screen.dart';
import '../../features/story/presentation/screens/story_library_screen.dart';
import '../../features/story/presentation/screens/story_viewer_screen.dart';
import '../../features/story/presentation/screens/generate_story_screen.dart';
import '../../features/story_creator/presentation/screens/story_wizard_screen.dart';
import '../../features/kid_profile/domain/entities/kid_profile_entity.dart';
import '../../features/story/domain/entities/story_entity.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

part 'app_router.g.dart';

/// Routes
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String storyLibrary = '/story-library';
  static const String storyViewer = '/story-viewer';
  static const String generateStory = '/generate-story';
  static const String storyWizard = '/story-wizard';
}

/// GoRouter provider with auth redirect logic
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Get auth status
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      // Allow splash and onboarding
      if (isSplash || isOnboarding) {
        return null;
      }

      // Redirect to login if not authenticated
      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      // Redirect to home if already logged in and trying to access auth pages
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const AppShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.storyLibrary,
        builder: (context, state) {
          final kidProfile = state.extra as KidProfileEntity;
          return StoryLibraryScreen(kidProfile: kidProfile);
        },
      ),
      GoRoute(
        path: AppRoutes.storyViewer,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final story = extra['story'] as StoryEntity;
          final kidProfile = extra['kidProfile'] as KidProfileEntity;
          return StoryViewerScreen(
            story: story,
            kidProfile: kidProfile,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.generateStory,
        builder: (context, state) {
          final kidProfile = state.extra as KidProfileEntity;
          return GenerateStoryScreen(kidProfile: kidProfile);
        },
      ),
      GoRoute(
        path: AppRoutes.storyWizard,
        builder: (context, state) => const StoryWizardScreen(),
      ),
    ],
  );
}
