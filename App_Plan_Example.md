# StayHard App - Claude Code Implementation Plan

## 🎯 Overview

This document provides **step-by-step prompts** for Claude Code to implement the entire StayHard app. Each phase is broken down into specific, actionable tasks that Claude Code can execute independently.

**Prerequisites:**
- Claude Code has access to `stayhard_architecture.md` (the full architecture document)
- Firebase project is created
- FlutterFire CLI is configured
- Development environment is ready

---

## 📋 How to Use This Plan

1. **Copy each prompt** to Claude Code in your terminal
2. **Wait for completion** before moving to the next prompt
3. **Test the feature** after each significant milestone
4. **Iterate** if needed based on test results

---

## PHASE 1: FOUNDATION (Week 1-2)

### 1.1 Project Setup & Structure

**Prompt for Claude Code:**
```
Create a new Flutter project called 'stayhard' with Clean Architecture structure. 

Setup required:
1. Initialize Flutter project with proper package name: com.stayhard.app
2. Create the complete folder structure as specified in stayhard_architecture.md section 2
3. Add all dependencies from the tech stack (section 1) to pubspec.yaml with correct versions
4. Configure build_runner, freezed, json_serializable, and riverpod_generator
5. Create .gitignore with Flutter defaults plus secrets (API keys, .env files)
6. Create README.md with project overview and setup instructions
7. Setup assets folder with placeholder for:
   - images/ (logo, onboarding illustrations)
   - audio/ (alarm sounds)
   - fonts/ (if custom fonts needed)

Make sure to follow the exact structure from the architecture document.
```

### 1.2 Firebase Configuration

**Prompt for Claude Code:**
```
Configure Firebase for the StayHard Android app.

Tasks:
1. Install and configure FlutterFire CLI if not already done
2. Run: flutterfire configure --project=stayhard (replace with actual project ID)
3. Add Firebase configuration files to the project
4. Configure Firebase Auth with email/password and Google Sign-In providers
5. Setup Firestore database in Firebase Console (enable in test mode initially)
6. Add Firebase initialization in main.dart
7. Create lib/core/constants/firebase_constants.dart with:
   - Collection names (users, habits, alarms, blockRules, etc.)
   - Field name constants
   - Any Firebase-specific configuration

Ensure all Firebase packages are properly imported and initialized.
```

### 1.3 Core Setup (Theme, Constants, Utils)

**Prompt for Claude Code:**
```
Create the core infrastructure for StayHard app, implementing the new custom theme.

Implement in lib/core/:

1. theme/app_theme.dart:
   - Material 3 theme with a custom color scheme (see app_colors.dart)
   - Must be DARK MODE FIRST. The primary theme IS the dark theme.
   - Use 'package:google_fonts' to import:
     - Oswald (for display, headline, and title text styles)
     - Inter (for body and label text styles)
   - Define custom text styles in a TextTheme:
     - displayLarge (Oswald, bold, e.g., 57pt)
     - headlineMedium (Oswald, semi-bold, e.g., 28pt)
     - titleLarge (Oswald, medium, e.g., 22pt)
     - bodyLarge (Inter, regular, e.g., 16pt)
     - bodyMedium (Inter, regular, e.g., 14pt)
     - labelMedium (Inter, light, e.g., 12pt)
   - Set the default background color to AppColors.background
   - Set Card, Dialog, and BottomSheet themes to use AppColors.surface
   - Define the main ColorScheme using ColorScheme.dark():
     - primary: AppColors.primary
     - secondary: AppColors.accent
     - background: AppColors.background
     - surface: AppColors.surface
     - onPrimary: AppColors.background (Dark text on orange button)
     - onSecondary: AppColors.textPrimary (Light text on blue button)
     - onBackground: AppColors.textPrimary
     - onSurface: AppColors.textPrimary
     - error: AppColors.error
     - onError: AppColors.textPrimary

2. theme/app_colors.dart:
   - Define all color constants.
   -
   - // Primary Palette
   - static const Color primary = Color(0xFFFF6B35); // Main Orange
   - static const Color accent = Color(0xFF2196F3);   // Main Blue
   -
   - // Core Layout
   - static const Color background = Color(0xFF1A1A1A); // Near Black
   - static const Color surface = Color(0xFF2C2C2C);    // Charcoal (for cards, dialogs)
   -
   - // Text
   - static const Color textPrimary = Color(0xFFF5F5F5);   // Off-white
   - static const Color textSecondary = Color(0xFF9E9E9E); // Grey for hints/subs
   -
   - // App Domain Categories
   - static const Color catFoundation = Color(0xFFFF6B35); // Primary Orange
   - static const Color catBody = Color(0xFFD32F2F);       // Muted Red
   - static const Color catMind = Color(0xFF2196F3);       // Accent Blue
   - static const Color catDiscipline = Color(0xFF673AB7);   // Deep Purple
   -
   - // Semantic Colors
   - static const Color success = Color(0xFF4CAF50);
   - static const Color warning = Color(0xFFFFC107);
   - static const Color error = Color(0xFFF44336);
   - static const Color info = Color(0xFF2196F3); // Re-use accent blue

3. constants/app_constants.dart:
   - App name ('StayHard'), version
   - API timeouts (e.g., 15 seconds)
   - Pagination limits (e.g., 20 items per page)
   - Max snoozes (3), snooze duration (5 min)
   - Any other app-wide constants

4. constants/route_constants.dart:
   - Route path constants for GoRouter (e.g., loginPath = '/auth/login')
   - Route names (e.g., loginName = 'login')

5. utils/date_utils.dart:
   - Date formatting helpers (e.g., 'MMM d, yyyy')
   - Time of day conversions
   - Streak calculation utilities
   - "X days ago" formatting

6. utils/validation_utils.dart:
   - Email validation (RegExp)
   - Password strength validation
   - Form validators (e.g., notEmpty)

7. error/failures.dart:
   - Define Failure classes using freezed:
     - NetworkFailure
     - ServerFailure
     - CacheFailure
     - AuthFailure
   - Each with a 'message' field

8. error/exceptions.dart:
   - Custom exception classes (e.g., ServerException, CacheException)

Use freezed for immutable classes where appropriate. Ensure Google Fonts is added to pubspec.yaml.

### 1.4 Splash Screen

**Prompt for Claude Code:**
```
Implement the splash screen feature.

Create in lib/features/splash/:

1. presentation/screens/splash_screen.dart:
   - Full-screen splash with StayHard logo (assets\images\LOGO.png)
   - Animate logo with fade-in + scale animation
   - Show loading indicator
   - Delay for 2-3 seconds
   - Auto-navigate to next screen based on auth state

2. presentation/providers/splash_provider.dart:
   - Riverpod provider to check:
     - If user is authenticated
     - If onboarding is complete
   - Return navigation destination (login, onboarding, or home)

Use Lottie animation if you have a JSON animation file, otherwise use simple FadeTransition + ScaleTransition.

Make it visually appealing with the app's color scheme.
```

### 1.5 Onboarding (3 Slides)

Implement the custom onboarding flow, replicating the design from the 'onboarding_page.dart' example file.

Create in lib/features/onboarding/presentation/screens/onboarding_screen.dart:

1.  **File Structure:** Create a single file 'onboarding_screen.dart'. It will be a 'ConsumerStatefulWidget'.
2.  **Helper Classes:** Inside this same file, add:
    * The 'OnboardingSlide' data class.
    * 'CurvedTopPainter' (CustomPainter for the top orange curve).
    * 'CurvedBottomPainter' (CustomPainter for the bottom surface-colored curve).
3.  **Slide Content:** Define the list of 4 slides exactly as specified:
    * Slide 1: "Win Your Morning"
    * Slide 2: "Build Unbreakable Discipline"
    * Slide 3: "Smart Habits, with AI"
    * Slide 4: "Let's Go!"
    * Use "assets/images/test.png" as the placeholder for all images.
4.  **Main Layout (Stack):**
    * Use a 'Stack' for the entire layout.
    * **Layer 1 (Top):** 'Positioned' 'CustomPaint' using 'CurvedTopPainter' and the primary theme color.
    * **Layer 2 (Middle):** 'Positioned' 'PageView' that only swipes the phone mockup image ('_buildPhoneMockup').
    * **Layer 3 (Bottom):** 'Positioned' 'CustomPaint' using 'CurvedBottomPainter' and the surface theme color.
    * **Layer 4 (UI):** Add the 'Skip' button (top-right) and the bottom content.
5.  **Bottom Content:**
    * Use a 'Positioned' container at the bottom.
    * Inside it, use an 'AnimatedSwitcher' for the text (Title, Subtitle) and page indicators. This should animate based on the '_currentPage' index.
    * Implement the '_buildPageIndicators' helper to show the animated dots (active dot is wider).
    * Add the 'ElevatedButton' for "Next" / "Get Started".
    * Add the 'TextButton' for "Already have an account? Log In".
6.  **State and Logic:**
    * Implement the 'PageController' and '_currentPage' state.
    * Implement the '_nextPage' method to advance the 'PageController' or call '_handleOnboardingComplete' on the last slide.
    * Implement the '_skipToEnd' method to call '_handleOnboardingComplete'.
    * Implement '_handleOnboardingComplete':
        * Read 'authStateChangesProvider' to check for a user.
        * If no user, navigate to '/auth/register' (or '/auth/signup' as per your router).
        * If user exists, call '_completeOnboardingForExistingUser'.
    * Implement '_completeOnboardingForExistingUser':
        * Get 'UserRepository' (you may need to create a provider for this).
        * Fetch the user profile.
        * If profile is null, create it.
        * Navigate to the home screen ('/').

Do NOT create separate 'onboarding_slide.dart' or 'page_indicator.dart' files. All UI and logic should be contained within 'onboarding_screen.dart' as shown in the example.ttractive animations for slide transitions.
```

### 1.6 Authentication UI & Logic

**Prompt for Claude Code:**
```
Implement complete authentication system (UI + logic).

Create in lib/features/auth/:

DOMAIN LAYER:
1. domain/entities/user_entity.dart:
   - User entity with freezed
   - Fields: uid, email, displayName, photoUrl, createdAt

2. domain/repositories/auth_repository.dart:
   - Abstract repository interface with methods:
     - Future<Either<Failure, UserEntity>> signInWithEmail(email, password)
     - Future<Either<Failure, UserEntity>> signInWithGoogle()
     - Future<Either<Failure, UserEntity>> signUpWithEmail(email, password, name)
     - Future<Either<Failure, void>> signOut()
     - Stream<UserEntity?> get authStateChanges

3. domain/usecases/:
   - sign_in_with_email.dart
   - sign_in_with_google.dart
   - sign_up_with_email.dart
   - sign_out.dart
   - get_current_user.dart
   Each use case takes repository as dependency, has call() method

DATA LAYER:
4. data/models/user_model.dart:
   - UserModel extends UserEntity
   - Add fromJson, toJson with freezed + json_serializable
   - fromFirebase and toFirebase methods

5. data/datasources/auth_remote_datasource.dart:
   - Interface with abstract methods
   - Implementation using FirebaseAuth
   - Handle Google Sign-In integration
   - Store user data in Firestore /users/{uid} on signup

6. data/repositories/auth_repository_impl.dart:
   - Implement AuthRepository
   - Call datasource methods
   - Return Either<Failure, Success> using fpdart
   - Handle exceptions and convert to Failures

PRESENTATION LAYER:
7. presentation/providers/auth_provider.dart:
   - Riverpod providers for auth state
   - authRepositoryProvider
   - authStateChangesProvider (stream)
   - currentUserProvider

8. presentation/providers/auth_state_provider.dart:
   - StateNotifier for login/signup state
   - Loading, success, error states

9. presentation/screens/login_screen.dart:
   - Email and password text fields
   - Login button (shows loading when processing)
   - Google Sign-In button
   - "Don't have account? Sign up" link
   - Form validation
   - Error message display

10. presentation/screens/signup_screen.dart:
    - Name, email, password, confirm password fields
    - Sign up button
    - Google Sign-In button
    - "Already have account? Login" link
    - Password strength indicator
    - Terms acceptance checkbox

11. presentation/widgets/auth_text_field.dart:
    - Custom text field with proper styling
    - Error state
    - Prefix icons

12. presentation/widgets/social_auth_button.dart:
    - Google sign-in button with proper branding

Use proper error handling throughout. All async operations should return Either<Failure, Success>.
```

### 1.7 Navigation Setup (GoRouter)

**Prompt for Claude Code:**
```
Setup navigation with GoRouter including auth guards.

Create in lib/core/:

1. navigation/app_router.dart:
   - Define GoRouter with all routes
   - Routes to implement now:
     - / (splash)
     - /auth/login
     - /auth/signup
     - /onboarding
     - /home (placeholder for now)
   
   - Implement redirect logic:
     - Not authenticated → redirect to /auth/login
     - Authenticated but onboarding incomplete → redirect to /onboarding
     - Authenticated and onboarding complete → allow access to app
   
   - Use refreshListenable with authStateChangesProvider

2. navigation/route_guards.dart (if needed):
   - Helper functions for auth checks

3. Update main.dart:
   - Wrap MaterialApp.router with ProviderScope
   - Use GoRouter from provider
   - Set theme from app_theme.dart

The router should properly handle authentication state changes and redirect users accordingly.
```

### 1.8 User Profile (Firestore CRUD)

**Prompt for Claude Code:**
```
Implement user profile management with Firestore.

Create in lib/features/profile/:

DOMAIN LAYER:
1. domain/entities/user_profile.dart:
   - Full user profile entity (see section 3.1 of architecture doc)
   - Fields: uid, email, createdAt, updatedAt, isOnboardingComplete, displayName, photoUrl, preferences, selectedCoachArchetypeId, mainGoalId, aiProfileAnalysis

2. domain/repositories/profile_repository.dart:
   - Abstract repository:
     - Future<Either<Failure, UserProfile>> getProfile(String uid)
     - Future<Either<Failure, void>> updateProfile(UserProfile profile)
     - Future<Either<Failure, void>> createProfile(UserProfile profile)

3. domain/usecases/:
   - get_profile.dart
   - update_profile.dart
   - create_profile.dart

DATA LAYER:
4. data/models/user_profile_model.dart:
   - Extends UserProfile
   - freezed + json_serializable
   - fromJson, toJson, fromFirestore, toFirestore

5. data/datasources/profile_remote_datasource.dart:
   - Firestore operations for /users/{uid} collection
   - CRUD operations

6. data/repositories/profile_repository_impl.dart:
   - Implement profile repository
   - Use Either for error handling

PRESENTATION LAYER:
7. presentation/providers/profile_provider.dart:
   - Riverpod provider for current user's profile
   - Auto-fetch when user logs in

8. presentation/screens/profile_screen.dart:
   - Basic profile view (placeholder for now)
   - Show user info
   - Edit button (implement later)

Create a simple home screen placeholder in lib/features/home/ that shows "Welcome to StayHard" and navigation to profile.
```

### 1.9 Testing Phase 1

**Prompt for Claude Code:**
```
Create basic tests for Phase 1 foundation.

Tests to implement:

1. test/features/auth/domain/usecases/sign_in_with_email_test.dart:
   - Test successful sign in
   - Test failed sign in (wrong password)
   - Test network error handling

2. test/features/auth/data/repositories/auth_repository_impl_test.dart:
   - Mock datasource
   - Test repository error handling
   - Test Either return types

3. test/core/utils/validation_utils_test.dart:
   - Test email validation
   - Test password strength

4. test/core/utils/date_utils_test.dart:
   - Test date formatting
   - Test streak calculations

Use mocktail for mocking. Aim for at least 80% coverage on business logic.

Also create widget tests for:
- LoginScreen
- SignupScreen
- OnboardingScreen

Run: flutter test
Fix any issues.
```

---

# PHASE 2
Phase 2 Detailed Breakdown (11 Tasks)
# 2.1 Questionnaire Data Models
Domain entities (QuestionnaireAnswer, TransformationProfile, HabitTemplate)
Data models with Freezed + JSON serialization
HabitConfigType enum

# 2.2 Seed Firestore Data
Script to populate 5 transformation profiles
Script to populate 17 habit templates across 4 categories
Runnable seeder with error handling

# 2.3 Cloud Functions Setup
Node.js/TypeScript setup
3 Gemini AI functions (analyzeQuestionnaire, generateHabitCoaching, generateDailyNotification)
Complete prompt templates
Environment variables setup

# 2.4 Profile Creation Repository
Domain layer (repository interface, 5 use cases)
Data layer (2 datasources, repository implementation)
Either-based error handling

# 2.5 Profile Creation Providers
4 Riverpod providers with @riverpod annotation
QuestionnaireNotifier for questionnaire state
ProfileSelectionNotifier for profile selection
HabitConfigurationNotifier for habit config

# 2.6 Intro Slides Screen
2-slide introduction before questionnaire
Smooth animations
Skip functionality

# 2.7 Questionnaire Screen
6 questions with exact options specified
Single choice (Q1-4, Q6) and multi-choice (Q5, max 3)
Progress tracking
Submit to AI

# 2.8 AI Analysis & Profile Selection
Loading state while AI analyzes
Display AI analysis result
Show all 5 profiles with recommended highlighted
Custom profile option

# 2.9 Habit Configuration Screen
Configure habits with 3 dialog types (time/duration/quantity)
Reorderable list
Add/remove habits
Minimum 3 habits validation

# 2.10 Welcome Sequence & Completion
5-step animated sequence
Background: Create Firestore documents
Complete profile setup use case
Navigate to home

# 2.11 Testing Phase 2
Unit tests for use cases and repository
Widget tests for all screens
Integration test for complete flow
Manual testing checklist

# PHASE 3 
Phase 3 Detailed Breakdown (11 Tasks)

# 3.1 Drift Database Setup
Complete SQLite schema with 4 tables (Habits, CompletionLogs, Alarms, BlockRules)
2 DAOs (HabitsDao, CompletionLogsDao)
Proper migrations setup
Build runner configuration

# 3.2 Habit Domain Layer
Habit entity with computed properties (currentStreak, completionRates, etc.)
RepeatConfig entity with RepeatType enum
HabitStats entity with comprehensive statistics
TimeOfDayEnum
Abstract HabitRepository interface
9 use cases (create, update, delete, complete, archive, unarchive, reset, get, getStats)

# 3.3 Habit Data Layer
HabitModel and RepeatConfigModel with Freezed + JSON serialization
Drift/Firestore conversion methods
HabitRemoteDataSource (Firestore operations)
HabitLocalDataSource (Drift operations)
HabitRepositoryImpl with offline-first strategy:
Local-first reads
Immediate local writes
Background sync to Firestore
Conflict resolution (last-write-wins)

# 3.4 Streak Calculation Utilities
StreakCalculator class with 8 static methods:
calculateCurrentStreak (handles today edge case)
calculateLongestStreak
calculateCompletionRate (flexible time periods)
isPerfectDay
getLastCompletedDate
getTotalCompletions
getCompletionsByDayOfWeek
getNextScheduledDate
HabitStatsCalculator
Comprehensive unit tests included

# 3.5 Habit Presentation Layer (Providers)
8 Riverpod providers with @riverpod annotation:
Repository, database, network providers
habitsProvider (async)
activeHabitsProvider (filtered, sorted)
archivedHabitsProvider
habitByIdProvider (family)
habitStatsProvider (family)
HabitActionsNotifier with 8 action methods
AI coaching provider (Cloud Function integration)

# 3.6 Habits Dashboard Screen
Today's progress card with circular indicator
Habits list with pull-to-refresh
Loading/empty/error states
Filter toggle (active/archived)
FAB for creating habits
Motivational messages based on progress

# 3.7 Habit Card Widget
Dismissible with swipe actions
Category icon with color coding
Habit name + configuration summary
Streak badge (fire icon + count)
Completion button with animations
Visual states (not completed, completed, overdue)
Hero animation to detail screen

# 3.8 Habit Detail Screen
Comprehensive statistics (4 stat cards)
Completion calendar (table_calendar integration)
Weekly pattern bar chart (fl_chart)
AI coaching section (optional)
Notes editor
Actions menu (edit, archive, reset, delete)
All with proper loading states

# 3.9 Habit Editor Screen
Create and edit modes
Template selector (17 templates, categorized)
Dynamic configuration section (time/duration/quantity)
Repeat pattern selector (daily, weekly, monthly, once, custom)
Day of week selector
Time of day tags
Reminders configuration
Form validation
AI coaching toggle

# 3.10 Offline Sync Service
SyncService class with comprehensive sync logic:
syncHabits (bidirectional sync with conflict resolution)
syncCompletionLogs (separate handling)
performFullSync
Periodic sync (every 15 minutes)
Network reconnect triggers
Last-write-wins conflict resolution
Error handling with retry logic
Optimization for changed data only

# 3.11 Testing Phase 3
Unit tests for:
StreakCalculator (all methods, edge cases)
Use cases (create, complete, etc.)
Repository implementation (offline scenarios)
Widget tests for:
Dashboard screen (loading, loaded, empty states)
HabitCard (rendering, interactions)
Completion button (states, animations)
Integration test:
Complete habit flow (create → complete → detail → edit → delete)
Manual testing checklist (offline mode, multi-device sync)

## Phase 4 Complete Breakdown (10 Tasks)

## 4.1 Alarm Domain Layer
Alarm entity with challenge configuration
ChallengeConfig with 3 types (simple, math, typing)
MathProblem entity with difficulty-based generation
Abstract AlarmRepository interface
10 use cases (create, update, delete, schedule, cancel, snooze, dismiss, trigger)

## 4.2 Alarm Data Layer
AlarmModel and ChallengeConfigModel with Freezed
AlarmLocalDataSource (Drift operations)
AlarmService interface (MethodChannel bridge to Android)
AlarmRepositoryImpl with offline-first strategy

## 4.3 Android MethodChannel Handler
Complete AlarmMethodCallHandler in Kotlin
Handles scheduleAlarm, cancelAlarm, snoozeAlarm methods
Uses AlarmManager.setAlarmClock for exact timing
Generates unique request codes per day
MainActivity integration

## 4.4 Android Alarm Receiver & Service
AlarmReceiver (BroadcastReceiver)
AlarmService (Foreground Service):
Acquires wake lock
Plays continuous audio (looping)
Vibrates device
Launches full-screen challenge
START_STICKY for reliability



## 4.5 Android Challenge Activity
Full 3000+ line Kotlin implementation
3 challenge types:
Simple: Just dismiss button
Math: Difficulty-based problem generation (easy/medium/hard)
Typing: Standard texts or custom user text with real-time validation
Non-dismissible (blocks back/home buttons)
Snooze handling (max 3)
Complete XML layout included

## 4.6 Android Manifest Configuration
All required permissions (SCHEDULE_EXACT_ALARM, WAKE_LOCK, etc.)
Service declarations with proper foregroundServiceType
Activity configuration (showWhenLocked, turnScreenOn)
MinSdkVersion 21+

## 4.7 Alarm Presentation Layer
8 Riverpod providers with @riverpod annotation
AlarmActionsNotifier with 6 action methods
AlarmsListScreen with empty/loading/success states
AlarmEditorScreen with comprehensive form:
Time picker
Day selector (M-Su)
Challenge type selector
Difficulty selector
Custom typing text input
Sound selector with preview
Habit linking
AlarmCard widget with toggle switch
Multiple reusable widgets

## 4.8 Audio Management
AudioManager class for sound handling
5 built-in alarm sounds (asset paths)
Custom sound picker (file_picker)
Preview functionality (audioplayers package)
Sound URI conversion for native service

## 4.9 Permission Handling
Complete AlarmPermissionsScreen
Checks 3 permissions:
SCHEDULE_EXACT_ALARM
POST_NOTIFICATIONS (Android 13+)
Full screen intent
Visual status indicators
Request flow with permission_handler
Settings navigation for denied permissions

## 4.10 Testing Phase 4
Unit tests:
MathProblem generation (all difficulties)
Use cases (create, snooze, dismiss)
Repository implementation
Widget tests:
Alarms list screen (empty/loaded states)
Alarm card (rendering, toggle)
Day selector (multi-select)
Integration test:
Complete alarm flow (create → trigger → challenge → dismiss)
Manual testing checklist (30+ test cases):
All challenge types and difficulties
Snooze functionality (1-3 times)
Audio playback
Lock screen behavior
Permission handling
Device persistence
Multi-alarm scenarios

## PHASE 5
5.1 App Blocking Domain Layer
Entities Created:
BlockRule (11 fields)
id, userId, blockedPackageNames
blockType (fullBlock/timeLimit)
timeLimitMinutes
schedules, linkedHabitId
temporaryExceptions
isEnabled, createdAt, lastTriggered
Computed: isActiveNow, hasActiveException, remainingTimeToday
TimeSchedule (3 fields)
daysOfWeek, startTime, endTime
Methods: isActiveNow(), isActiveOnDay(), isInTimeRange()
BlockException (3 fields)
expiresAt, reason, createdAt
Getters: isActive, remainingTime
BlockedApp (4 fields)
packageName, appName, icon, category
Repository Interface:
AppBlockingRepository with 11 methods
getBlockRules, createBlockRule, updateBlockRule, deleteBlockRule
checkIfBlocked, grantTemporaryException, revokeException
getInstalledApps, startBlockingService, stopBlockingService
getAppUsageToday
Use Cases (6):
create_block_rule.dart
update_block_rule.dart
delete_block_rule.dart
check_if_blocked.dart
grant_temporary_exception.dart
get_installed_apps.dart

✅ 5.2 App Blocking Data Layer
Models Created:
BlockRuleModel - Freezed + JSON + Drift serialization
TimeScheduleModel - Freezed + JSON
BlockExceptionModel - Freezed + JSON
BlockedAppModel - Freezed + JSON
Data Sources:
BlockRulesLocalDataSource (Drift)
6 methods for local CRUD operations
Stream support for real-time updates
BlockingService (MethodChannel bridge)
10 methods for Android communication
startService, stopService, updateRules
getInstalledApps, getAppUsageToday
hasUsageStatsPermission, requestUsageStatsPermission
hasOverlayPermission, requestOverlayPermission
Repository Implementation:
AppBlockingRepositoryImpl
Offline-first strategy
Complete error handling
Integrates local + native service

✅ 5.3 Android Native - Method Channel Handler
Complete Kotlin Implementation:
BlockingMethodCallHandler.kt (~400 lines)
Methods Implemented:
startBlockingService
stopBlockingService
updateRules
isServiceRunning
getInstalledApps (with icon extraction)
getAppUsageToday
hasUsageStatsPermission
requestUsageStatsPermission
hasOverlayPermission
requestOverlayPermission
Features:
App list fetching with icons (Base64 encoded)
Usage stats integration
Permission checking
Settings intent launching
Integration:
MainActivity.kt updated with channel setup
✅ 5.4 Android Native - Blocking Service
Complete Kotlin Implementation:
BlockingService.kt (~350 lines)
Core Features:
Foreground service (24/7 monitoring)
Checks foreground app every 1 second
BlockRule parsing from JSON
Schedule checking (day + time)
Time limit tracking
Habit-linked blocking
Exception handling
Helper Class:
UsageMonitor.kt (~50 lines)
getForegroundApp()
getAppUsageToday()
Data Classes:
BlockRule with nested Schedule and Exception
JSON deserialization
Time range checking (handles overnight schedules)

✅ 5.5 Android Native - Block Intervention Activity
Complete Kotlin Implementation:
BlockInterventionActivity.kt (~150 lines)
Features:
Full-screen overlay
Shows over lock screen
Cannot be dismissed with back/home button
Displays blocked app name
Shows appropriate message (full block vs time limit)
Request temporary exception dialog (15 min / 30 min)
Forces user to home screen
Layout:
activity_block_intervention.xml (~70 lines)
Dark themed
Block icon (red)
Title and message
Dismiss button
Request exception button

✅ 5.6 Android Manifest Configuration
Permissions Added:
xml<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
Components Declared:
BlockingService (foreground, specialUse)
BlockInterventionActivity (showWhenLocked, turnScreenOn)
Queries Element:
For getting installed apps list

✅ 5.7 App Blocking Presentation Layer
Providers (3):
appBlockingRepositoryProvider
blockRulesProvider - async list of rules
installedAppsProvider - async list of apps
appUsageTodayProvider - usage stats map
Actions Provider:
BlockRuleActionsNotifier with 6 methods:
createBlockRule
updateBlockRule
deleteBlockRule
toggleBlockRule
grantException
revokeException
Screens (2):
app_blocking_settings_screen.dart
List of block rules
Empty state
FAB to add rule
Status indicator
block_rule_editor_screen.dart
Select apps section
Block type selector
Schedule editor (multiple schedules)
Habit linking
Enable/disable toggle
Widgets (5):
block_rule_card.dart - Displays rule summary
app_selector_sheet.dart - Bottom sheet with app list
schedule_editor_dialog.dart - Add/edit schedule
time_schedule_card.dart - Shows single schedule
Various supporting widgets

✅ 5.8 Permission Request Flow
Complete Implementation:
blocking_permissions_screen.dart (~200 lines)
Permissions Managed:
Usage Stats Permission (CRITICAL)
Must be granted in system settings
Guide user through Settings path
Display Over Other Apps
Can request directly
Shows block intervention
Battery Optimization (optional)
For service reliability
Features:
Visual status indicators
Direct grant buttons
Settings navigation
All-permissions check
Warning if not granted
✅ 5.9 Habit-Linked Blocking
Implementation Strategy:
Android Side:
SharedPreferences to store habit completion status
Method channel to receive habit updates from Flutter
BlockingService checks habit status before blocking
Flutter Side:
Notify Android when habit completed
Update habit completion in shared storage
Show unblocked notification
Code Provided:
Kotlin code for habit checking
Flutter code for notification
Integration with habits feature

✅ 5.10 Testing Phase 5
Unit Tests (4 files):
time_schedule_test.dart
Active  time checking
Overnight schedules
block_exception_test.dart
create_block_rule_test.dart
app_blocking_repository_impl_test.dart
Widget Tests (2 files):
app_blocking_settings_screen_test.dart
block_rule_card_test.dart
Integration Test:
Complete blocking rule creation flow
App selection → block type → schedule → save
Manual Testing Checklist (40+ items):
Permission flow
Rule creation (full block, time limit)
Multiple schedules
Weekday/weekend/overnight schedules
Intervention screen
Time limit enforcement
Temporary exceptions
Habit-linked blocking
Service persistence
Multi-device testing (Samsung, Xiaomi, OnePlus, Pixel)
Performance Testing:
Battery impact (< 3% per day)
Memory usage (< 50MB)
Edge Cases (15+ scenarios):
Permission revocation
System time changes
New app installations
Multiple rules for same app
Overlapping schedules
Empty configurations

## PHASE 2-10 SUMMARY

**Note:** The complete implementation plan continues with detailed prompts for:

- **Phase 2:** Profile Creation & AI (Questionnaire, AI matching, habit configuration)
- **Phase 3:** Habits Core System (Drift DB, CRUD, offline sync, streak tracking)
- **Phase 4:** Alarms System (Android native, challenges, audio playback)
- **Phase 5:** App Blocking System (UsageStats monitoring, full-screen interventions)
- **Phase 6:** Momentum & AI Notifications (Daily snapshots, AI message generation)
- **Phase 7:** Statistics & Analytics (Charts, visualizations, data aggregation)
- **Phase 8:** Settings & Polish (Theme, notifications, premium, error handling)
- **Phase 9:** Testing & Optimization (Unit tests, performance profiling, memory leaks)
- **Phase 10:** Launch Preparation (Icons, Play Store listing, privacy policy)

---

## QUICK REFERENCE: COMMON CLAUDE CODE COMMANDS

### Code Generation
```bash
# Run build_runner
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on file changes)
dart run build_runner watch --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/domain/usecases/sign_in_with_email_test.dart

# Run integration tests
flutter test integration_test/
```

### Firebase
```bash
# Configure Firebase
flutterfire configure

# Deploy Cloud Functions
cd functions
firebase deploy --only functions

# Deploy Firestore rules
firebase deploy --only firestore:rules
```

### Build & Run
```bash
# Run in debug mode
flutter run

# Run in profile mode (for performance testing)
flutter run --profile

# Build APK
flutter build apk --release

# Build app bundle
flutter build appbundle --release

# Analyze app size
flutter build apk --analyze-size
```

### DevTools
```bash
# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## IMPLEMENTATION TIPS FOR CLAUDE CODE

### 1. **Start Each Phase by Reading Architecture**
Before implementing any phase, prompt Claude Code to:
```
Read the stayhard_architecture.md file, specifically section [X] about [feature name]. 
Then implement [feature] following the architecture exactly.
```

### 2. **Incremental Implementation**
Don't try to implement entire phases at once. Break down further:
```
Implement just the domain layer for habits feature:
- Create entities
- Create repository interface
- Create use cases
Then we'll do data layer next.
```

### 3. **Test as You Go**
After each major component:
```
Create unit tests for the use cases we just implemented.
Aim for 100% coverage on use case logic.
```

### 4. **Request Code Reviews**
Periodically ask Claude Code to review:
```
Review the auth feature we just implemented.
Check for:
- Proper error handling
- Memory leaks (disposed controllers)
- Null safety
- Performance issues
Suggest improvements.
```

### 5. **Handle Native Code Separately**
For Android-specific features:
```
I'll handle the native Android code myself. 
Just create the Dart side with MethodChannel setup.
Show me exactly what methods the native code needs to implement.
```

Or if you want Claude Code to do it:
```
Create the Android native code for alarm scheduling.
Use Kotlin, follow best practices for:
- AlarmManager with exact timing
- Foreground service
- Wake locks
Place files in android/app/src/main/kotlin/com/stayhard/app/
```

### 6. **Iterate on UI**
UI often needs refinement:
```
The habits dashboard looks good but:
1. Make the completion button more prominent
2. Add a subtle shadow to habit cards
3. Improve empty state illustration
Update the widgets accordingly.
```

### 7. **Debug Issues**
When you encounter errors:
```
I'm getting this error: [paste error]
In this file: [file path]
Here's the relevant code: [paste code]
Please diagnose and fix the issue.
```

### 8. **Optimize Performance**
After initial implementation:
```
Profile the habits dashboard screen.
Look for:
- Unnecessary rebuilds
- Missing const constructors
- Inefficient list rendering
Optimize the code.
```

---

## PROGRESS TRACKING

Use this checklist to track implementation progress:

### Phase 1: Foundation ✅
- [DONE] Project setup & structure
- [DONE] Firebase configuration
- [DONE] Core (theme, constants, utils)
- [DONE] Splash screen
- [DONE] Onboarding
- [DONE] Authentication
- [DONE] Navigation (GoRouter)
- [DONE] User profile CRUD
- [DONE] Tests

### Phase 2: Profile Creation & AI
- [DONE] Questionnaire models
- [DONE] Seed Firestore data
- [DONE] Cloud Functions setup
- [DONE] Intro slides
- [DONE] Questionnaire UI
- [DONE] AI analysis & profile selection
- [DONE] Habit configuration
- [DONE] Welcome sequence
- [DONE] Tests

### Phase 3: Habits Core System
- [DONE] Drift database
- [DONE] Habit domain layer
- [DONE] Habit data layer
- [DONE] Habit providers
- [DONE] Habits dashboard
- [DONE] Habit detail screen
- [DONE] Habit editor
- [DONE] Habit widgets
- [DONE]Streak calculation
- [DONE] Offline sync
- [DONE] Tests

### Phase 4: Alarms System
- [DONE] Alarm domain layer
- [DONE] Alarm data layer
- [DONE] Android AlarmService
- [DONE] Alarm challenge activity
- [DONE] Alarm providers
- [DONE] Alarms list screen
- [DONE] Alarm editor
- [DONE] Audio management
- [DONE] Permissions
- [DONE] Tests

### Phase 5: App Blocking System
- [ ] Blocking domain layer
- [ ] Blocking data layer
- [ ] Android BlockingService
- [ ] Blocking providers
- [ ] Blocking settings screen
- [ ] Block rule editor
- [ ] Intervention screen
- [ ] Permissions
- [ ] Temporary exceptions
- [ ] Habit-linked blocking
- [ ] Tests

### Phase 6: Momentum & AI Notifications
- [ ] Momentum domain layer
- [ ] Momentum data layer
- [ ] Snapshot creation
- [ ] Cloud Functions (AI)
- [ ] Notification delivery
- [ ] Momentum analytics screen
- [ ] AI notification screen
- [ ] Notification history
- [ ] Tests

### Phase 7: Statistics & Analytics
- [ ] Statistics screen
- [ ] Data aggregation
- [ ] Data visualization (charts)
- [ ] Export (optional)
- [ ] Tests

### Phase 8: Settings & Polish
- [ ] Settings screen
- [ ] Notification preferences
- [ ] Theme management
- [ ] Account management
- [ ] Premium subscription
- [ ] Loading states
- [ ] Error handling
- [ ] Empty states
- [ ] Onboarding skip logic
- [ ] Tests

### Phase 9: Testing & Optimization
- [ ] Comprehensive unit tests (80%+ coverage)
- [ ] Widget tests
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Memory leak detection
- [ ] Battery optimization
- [ ] App size optimization
- [ ] Firestore security rules
- [ ] Cloud Functions optimization

### Phase 10: Launch Preparation
- [ ] App icons
- [ ] Splash screen
- [ ] Play Store listing
- [ ] Screenshots
- [ ] Privacy policy
- [ ] Terms of service
- [ ] Analytics setup
- [ ] Crashlytics
- [ ] Beta testing
- [ ] Final QA
- [ ] Release build
- [ ] Play Store submission

---

## TROUBLESHOOTING GUIDE

### Common Issues and Solutions

#### 1. Build Runner Conflicts
**Issue:** Build runner fails with conflicts
**Solution:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 2. Firebase Initialization Error
**Issue:** Firebase not initializing
**Solution:**
- Ensure firebase_core is initialized in main()
- Check google-services.json is in android/app/
- Verify FlutterFire CLI configuration

#### 3. Riverpod Provider Not Updating
**Issue:** UI not updating when provider changes
**Solution:**
- Use .watch() not .read() in build method
- Check if provider is AutoDispose when it shouldn't be
- Verify state is actually changing

#### 4. Drift Database Errors
**Issue:** Drift tables not generated
**Solution:**
```bash
dart run build_runner build --delete-conflicting-outputs
```
- Ensure @DriftDatabase annotation is correct
- Check table definitions

#### 5. Android Build Failures
**Issue:** Android build fails
**Solution:**
- Check minSdkVersion (should be 21+)
- Ensure all required permissions in AndroidManifest.xml
- Clean build: flutter clean && flutter pub get

#### 6. Cloud Functions Not Deploying
**Issue:** Firebase functions deployment fails
**Solution:**
```bash
cd functions
npm install
firebase deploy --only functions
```
- Check Node.js version
- Verify Firebase billing is enabled
- Check function logs: firebase functions:log

---

## FINAL NOTES

### Critical Reminders for Claude Code:

1. **Always read architecture first** before implementing any feature
2. **Use freezed** for all data models
3. **Use Either<Failure, T>** for all repository returns
4. **Dispose controllers** in dispose() or ref.onDispose()
5. **Add const** constructors everywhere possible
6. **Test business logic** thoroughly (80%+ coverage)
7. **Handle offline** scenarios gracefully
8. **Follow Clean Architecture** layers strictly
9. **Use Riverpod** code generation (@riverpod annotation)
10. **Document complex logic** with comments

### When to Ask for Help:

- **Native Android code** is complex (AlarmManager, UsageStats)
- **Cloud Functions** deployment issues
- **Performance problems** persist after optimization
- **Architecture decisions** need clarification
- **Firebase security rules** are unclear

### Success Metrics:

- ✅ All features work as specified
- ✅ 80%+ test coverage on business logic
- ✅ No memory leaks
- ✅ Smooth 60fps performance
- ✅ Works offline for core features
- ✅ Battery efficient (< 5% per hour in background)
- ✅ App size < 50MB
- ✅ Crash-free rate > 99%

---

**Ready to build StayHard! 🚀**

Start with Phase 1, Task 1.1 and work through systematically.
Claude Code has all the information needed in stayhard_architecture.md.
