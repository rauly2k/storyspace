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
import '../../features/home/presentation/screens/library_screen.dart';
import '../../features/home/presentation/screens/settings_screen.dart';
import '../../features/kid_profile/domain/entities/kid_profile_entity.dart';
import '../../features/story/domain/entities/story_entity.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/kid_profile/presentation/screens/kid_profiles_screen.dart';
import '../../features/kid_profile/presentation/screens/create_kid_profile_screen.dart';
import '../../features/kid_profile/presentation/providers/kid_profile_providers.dart';

part 'app_router.g.dart';

/// Routes
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String kidProfiles = '/kid-profiles';
  static const String createKidProfile = '/create-kid-profile';
  static const String storyLibrary = '/story-library';
  static const String storyViewer = '/story-viewer';
  static const String generateStory = '/generate-story';
  static const String storyWizard = '/story-wizard';
  static const String library = '/library';
  static const String settings = '/settings';
}

/// GoRouter provider with auth redirect logic
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  final kidProfilesAsync = ref.watch(kidProfilesProvider);

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
      final isCreatingProfile = state.matchedLocation == AppRoutes.createKidProfile;
      final isManagingProfiles = state.matchedLocation == AppRoutes.kidProfiles;

      // Allow splash and onboarding
      if (isSplash || isOnboarding) {
        return null;
      }

      // Redirect to login if not authenticated
      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      // If logged in, check for kid profiles
      if (isLoggedIn) {
        // Allow access to auth pages redirect
        if (isLoggingIn) {
          return AppRoutes.home;
        }

        // Allow access to profile creation/management screens
        if (isCreatingProfile || isManagingProfiles) {
          return null;
        }

        // Check if user has kid profiles
        final hasProfiles = kidProfilesAsync.maybeWhen(
          data: (profiles) => profiles.isNotEmpty,
          orElse: () => false,
        );

        // If no profiles and trying to access home or other screens, redirect to create profile
        if (!hasProfiles && state.matchedLocation != AppRoutes.createKidProfile) {
          return AppRoutes.createKidProfile;
        }
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
        path: AppRoutes.kidProfiles,
        builder: (context, state) => const KidProfilesScreen(),
      ),
      GoRoute(
        path: AppRoutes.createKidProfile,
        builder: (context, state) => const CreateKidProfileScreen(),
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
      GoRoute(
        path: AppRoutes.library,
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
