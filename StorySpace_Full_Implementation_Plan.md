# StorySpace App - Complete Implementation Plan

> **COMPREHENSIVE GUIDE:** This document contains all 15 phases with detailed Claude Code prompts for building StorySpace - an AI-powered children's story platform.

---

## 📚 QUICK NAVIGATION

**For 7-Day MVP:** Phases 1-6 only  
**For Full Launch:** All 15 phases (10 weeks)

| Phase | Title | Duration | Priority |
|-------|-------|----------|----------|
| 1 | Foundation | Week 1 | CRITICAL |
| 2 | Authentication | Week 1 | CRITICAL |
| 3 | Kid Profiles | Week 2 | CRITICAL |
| 4 | Story Library | Week 2-3 | CRITICAL |
| 5 | Story Reader | Week 3 | CRITICAL |
| 6 | AI Generation | Week 4 | CRITICAL |
| 7 | Image Generation | Week 5 | HIGH |
| 8 | Audio Narration | Week 5 | HIGH |
| 9 | Favorites & Offline | Week 6 | HIGH |
| 10 | Subscription | Week 6-7 | HIGH |
| 11 | PDF Export | Week 7 | MEDIUM |
| 12 | Home & Navigation | Week 7 | HIGH |
| 13 | Polish & Optimization | Week 8 | HIGH |
| 14 | Testing | Week 9 | CRITICAL |
| 15 | Launch Prep | Week 10 | CRITICAL |

---

## 🎯 OVERVIEW

### App Vision
StorySpace is a child-friendly app where kids can:
- Read curated stories from a library
- Create personalized AI stories featuring themselves
- Generate beautiful illustrations
- Listen to audio narration
- Build their story collection

### Target Users
- **Sprout (Ages 3-5):** Simple UI, short stories (250 words)
- **Explorer (Ages 6-8):** Early-reader friendly (500 words)
- **Visionary (Ages 9-12):** Complex themes (900 words)

### Technical Architecture
```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── error/
│   ├── router/
│   ├── database/ (Drift)
│   ├── services/ (Gemini)
│   └── widgets/
├── features/
│   ├── auth/ (domain/data/presentation)
│   ├── kid_profile/
│   ├── story_library/
│   ├── story_reader/
│   ├── story_creator/
│   ├── image_generation/
│   ├── audio_narration/
│   ├── favorites/
│   ├── offline/
│   ├── subscription/
│   ├── pdf_export/
│   ├── home/
│   └── settings/
└── main.dart
```

### Tech Stack
- **Framework:** Flutter 3.16+, Dart 3.0+
- **State:** Riverpod 2.6+ (@riverpod code generation)
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Local DB:** Drift (SQLite for offline)
- **AI:** Gemini API (text + image generation)
- **Navigation:** GoRouter
- **Code Gen:** freezed, json_serializable
- **Audio:** flutter_tts
- **Images:** cached_network_image
- **PDF:** pdf package

### Subscription Tiers

**FREE:**
- 5 pre-made stories
- 1 kid profile
- 2 AI stories/month (text only)
- Basic cartoon images

**PREMIUM ($4.99/month):**
- Unlimited pre-made stories
- 3 kid profiles
- 20 AI stories/month
- All art styles (Cartoon, Storybook, 3D, Anime)
- AI images (cover + 3 scenes)
- 10 offline downloads
- Audio narration

**PREMIUM+ ($9.99/month):**
- Everything in Premium
- Unlimited AI stories
- **"Put your kid in story" with photo**
- Unlimited AI images
- Unlimited downloads
- Export to PDF
- Priority generation

---

## PHASE 1: FOUNDATION (Week 1 - Day 1-2)

### 1.1 Project Setup

**Prompt for Claude Code:**
```
Create a new Flutter project called 'storyspace' with Clean Architecture.

Tasks:
1. Initialize: flutter create storyspace --org com.storyspace
2. Create folder structure:
   lib/core/{constants,theme,utils,error,widgets,router,database,services}
   lib/features/{auth,kid_profile,story_library,story_reader,story_creator,image_generation,audio_narration,favorites,offline,subscription,pdf_export,home,settings}
   Each feature: {domain,data,presentation}/{entities/repositories,models/datasources/repositories,screens/widgets/providers}

3. Add to pubspec.yaml:
   dependencies:
     cupertino_icons: ^1.0.8
  flutter_riverpod: ^3.0.3
  riverpod_annotation: ^3.0.3
  firebase_core: ^4.2.1
  firebase_auth: ^6.1.2
  cloud_firestore: ^6.1.0
  firebase_storage: ^13.0.4
  google_generative_ai: ^0.4.7
  drift: ^2.29.0
  sqlite3_flutter_libs: ^0.5.40
  go_router: ^17.0.0
  dio: ^5.9.0
  cached_network_image: ^3.4.1
  image_picker: ^1.2.1
  flutter_tts: ^4.2.3
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  google_fonts: ^6.3.2
  fpdart: ^1.2.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.7.1
  freezed: ^3.2.3
  json_serializable: ^6.11.1
  riverpod_generator: ^3.0.3
  drift_dev: ^2.29.0
  mocktail: ^1.0.4

4. Create assets/ folder structure
5. Create .gitignore for secrets
6. Create README.md
```

### 1.2 Firebase Configuration

**Prompt:**
```
Configure Firebase for Android.

Tasks:
1. Run: flutterfire configure --project=YOUR_PROJECT_ID
2. Enable Email/Password + Google Sign-In in Firebase Console
3. Create Firestore database (test mode initially)
4. Setup Storage buckets: user_photos/, story_images/, kid_profiles/
5. Add Firebase init in main.dart:
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
     runApp(ProviderScope(child: MyApp()));
   }
6. Create lib/core/constants/firebase_constants.dart with collection names
```

### 1.3 Core Infrastructure

**Prompt:**
```
Create core infrastructure with kid-friendly theme.

Create in lib/core/:

1. theme/app_colors.dart:
   - primary: Color(0xFFFF6B9D) // Pink
   - secondary: Color(0xFF4ECDC4) // Turquoise
   - accent: Color(0xFFFFC75F) // Yellow
   - sproutColor: Color(0xFF95E1D3) // Ages 3-5
   - explorerColor: Color(0xFF5DADE2) // Ages 6-8
   - visionaryColor: Color(0xFF9B59B6) // Ages 9-12
   - background: Color(0xFFFFF8F0) // Warm cream

2. theme/app_text_styles.dart:
   - Use GoogleFonts.quicksand for headers (playful)
   - Use GoogleFonts.nunito for body (readable)
   - Define all text styles

3. theme/app_theme.dart:
   - Material 3 theme with defined colors
   - Rounded corners (16px)
   - Large buttons (56px height)

4. constants/app_constants.dart:
   - appName, version
   - Subscription limits
   - API timeouts

5. error/failures.dart (using freezed):
   - NetworkFailure, ServerFailure, CacheFailure, AuthFailure, GeminiFailure

6. utils/validation_utils.dart:
   - Email, password validators

Run: dart run build_runner build --delete-conflicting-outputs
```

### 1.4 Splash & Onboarding

**Prompt:**
```
Implement splash screen and 3-slide onboarding.

1. features/splash/presentation/screens/splash_screen.dart:
   - Logo with fade-in animation
   - Check auth state → navigate accordingly

2. features/onboarding/presentation/screens/onboarding_screen.dart:
   - 3 slides with PageView
   - Slide 1: "Welcome to StorySpace - Where Stories Come Alive"
   - Slide 2: "Create Your Story - You're the Hero!"
   - Slide 3: "Ready for Adventure?"
   - Bottom: Page indicators + Next/Skip buttons
   - Navigate to register on completion
```

---

## PHASE 2: AUTHENTICATION (Week 1 - Day 2-3)

### 2.1 Domain Layer

**Prompt:**
```
Create auth domain layer.

1. features/auth/domain/entities/user_entity.dart (freezed):
   @freezed class UserEntity {
     const factory UserEntity({
       required String id,
       required String email,
       String? displayName,
       @Default(false) bool isPremium,
       @Default('free') String subscriptionTier,
       required DateTime createdAt,
     }) = _UserEntity;
   }

2. features/auth/domain/repositories/auth_repository.dart:
   abstract class AuthRepository {
     Stream<UserEntity?> get authStateChanges;
     Future<Either<Failure, UserEntity>> signInWithEmail(String email, String password);
     Future<Either<Failure, UserEntity>> signUpWithEmail(String email, String password);
     Future<Either<Failure, UserEntity>> signInWithGoogle();
     Future<Either<Failure, void>> signOut();
   }
```

### 2.2 Data Layer

**Prompt:**
```
Implement auth data layer with Firebase.

1. Create models/user_model.dart extending UserEntity
2. Create datasources/auth_remote_datasource.dart implementing Firebase Auth
3. Create repositories/auth_repository_impl.dart:
   - Handle Firebase Auth operations
   - Create/update user document in Firestore
   - Convert between Firebase User and UserEntity
   - Proper error handling

Add google_sign_in package.
Run build_runner.
```

### 2.3 Providers & UI

**Prompt:**
```
Create Riverpod providers and auth UI.

1. presentation/providers/auth_providers.dart:
   @riverpod AuthRepository authRepository(...)
   @riverpod Stream<UserEntity?> authStateChanges(...)
   @riverpod class AuthController extends _$AuthController {...}

2. presentation/screens/login_screen.dart:
   - Email + password fields
   - Login button
   - "Forgot password?" link
   - "Sign up" link
   - Divider with "OR"
   - "Continue with Google" button
   - Form validation
   - Loading states

3. presentation/screens/register_screen.dart:
   - Email, password, confirm password
   - Terms checkbox
   - Create account button
   - Google sign-in option

4. Setup GoRouter in core/router/app_router.dart with auth redirect logic

Run build_runner for providers.
```

---

## PHASE 3: KID PROFILES (Week 2 - Day 3-4)

### 3.1 Domain & Data

**Prompt:**
```
Implement kid profile feature.

1. domain/entities/kid_profile_entity.dart (freezed):
   @freezed class KidProfileEntity {
     const factory KidProfileEntity({
       required String id,
       required String userId,
       required String name,
       required String ageBucket, // 'sprout', 'explorer', 'visionary'
       required int age,
       String? photoUrl,
       @Default([]) List<String> interests,
       required DateTime createdAt,
     }) = _KidProfileEntity;
   }

2. Create repository interface with CRUD operations
3. Implement data layer with Firebase Firestore + Storage
4. Add photo upload functionality
5. Age bucket calculation: 3-5→sprout, 6-8→explorer, 9-12→visionary
```

### 3.2 UI

**Prompt:**
```
Create kid profile UI.

1. screens/kid_profiles_screen.dart:
   - Grid of profile cards
   - Each card: photo, name, age bucket badge, age
   - "+" button to add profile
   - Tap to select → navigate to home

2. screens/create_kid_profile_screen.dart:
   - Name text field
   - Age selector (1-12)
   - Photo upload button with ImagePicker
   - Interests chips (optional)
   - "Create Profile" button
   - Form validation
   - Loading state

3. widgets/kid_profile_card.dart:
   - Beautiful rounded card
   - Age bucket color accent
   - Photo with gradient overlay

Check subscription limits before creating profiles.
```

---

## PHASE 4: STORY LIBRARY (Week 2-3 - Day 4-7)

### 4.1 Domain & Database

**Prompt:**
```
Create story domain layer and local database.

1. domain/entities/story_entity.dart (freezed):
   @freezed class StoryEntity {
     const factory StoryEntity({
       required String id,
       required String title,
       required String content,
       required String category,
       required String ageBucket,
       String? coverImageUrl,
       @Default([]) List<StoryPageEntity> pages,
       String? authorId,
       @Default(false) bool isAIGenerated,
       required StoryLength length,
     }) = _StoryEntity;
   }
   
   @freezed class StoryPageEntity {
     const factory StoryPageEntity({
       required int pageNumber,
       required String text,
       String? imageUrl,
     }) = _StoryPageEntity;
   }
   
   enum StoryLength { short, medium, long }

2. Create core/database/app_database.dart (Drift):
   @DriftDatabase(tables: [Stories, StoryPages])
   - Define Stories and StoryPages tables
   - Add CRUD methods
   - Add favorites toggle
   - Add read count tracking

3. Create repository interface for story operations

Run build_runner for Drift.
```

### 4.2 Seed Stories

**Prompt:**
```
Create seed stories for initial library.

Create assets/stories/seed_stories.json with 15 stories:
- 5 Sprout stories (Adventure, Funny, Bedtime)
- 5 Explorer stories (Fantasy, Mystery, Learning)
- 5 Visionary stories (Sci-Fi, Adventure, Mystery)

Structure:
{
  "stories": [
    {
      "id": "story_001",
      "title": "The Little Dragon Who Could",
      "summary": "A young dragon learns to believe in himself",
      "category": "adventure",
      "ageBucket": "sprout",
      "length": "short",
      "pages": [
        {
          "pageNumber": 1,
          "text": "Once upon a time...",
          "imagePrompt": "A cute small dragon..."
        }
      ]
    }
  ]
}

Include mix of adapted public domain + original AI-generated stories.
```

### 4.3 Data Layer & UI

**Prompt:**
```
Implement story data layer and library UI.

1. data layer:
   - Create story model
   - Implement remote datasource (Firestore)
   - Implement local datasource (Drift)
   - Repository impl with offline-first approach:
     * Check local cache first
     * Fetch from Firebase if not cached
     * Update local cache

2. screens/story_library_screen.dart:
   - Top tabs: All, Adventure, Fantasy, Sci-Fi, Mystery, Funny, Magical, School, Spooky
   - Filter chips for age buckets
   - Grid of story cards
   - Search bar
   - Pull to refresh
   - Loading/empty states

3. widgets/story_card.dart:
   - Cover image with gradient
   - Title, summary
   - Category badge
   - Age bucket color accent
   - Favorite icon
   - Tap → open reader

Load seed stories on first launch.
```

---

## PHASE 5: STORY READER (Week 3 - Day 7-8)

**Prompt:**
```
Create immersive story reading experience.

1. screens/story_reader_screen.dart:
   - Full-screen PageView for story pages
   - Layout: Image at top, text below
   - Large readable text (adjust by age bucket)
   - Bottom bar: Page indicator, audio button
   - Top bar: Back, favorite, share buttons
   - Smooth page transitions
   - Auto-save reading progress
   - Track read count when completed

2. widgets/story_page_widget.dart:
   - Display single page
   - Image with cached loading
   - Text with proper formatting
   - Page turn animation

3. widgets/reading_controls_widget.dart:
   - Font size adjustment (A-, A, A+)
   - Background theme (light/sepia/dark)
   - Audio playback controls

Age-specific layouts:
- Sprout: Large images, minimal text (20px font)
- Explorer: Balanced (18px font)
- Visionary: More text (16px font)
```

---

## PHASE 6: AI STORY GENERATION (Week 4 - Day 8-12)

### 6.1 Gemini Service

**Prompt:**
```
Setup Gemini AI integration for story generation.

1. core/services/gemini_service.dart:
   import 'package:google_generative_ai/google_generative_ai.dart';
   
   class GeminiService {
     final GenerativeModel _model;
     
     GeminiService(String apiKey) : _model = GenerativeModel(
       model: 'gemini-1.5-flash',
       apiKey: apiKey,
       generationConfig: GenerationConfig(
         temperature: 0.9,
         maxOutputTokens: 2048,
       ),
       safetySettings: [
         SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
         SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
         SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
         SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
       ],
     );
     
     Future<String> generateStory({
       required String childName,
       required int childAge,
       required String genre,
       required String length,
       required String ageBucket,
     }) async {
       final prompt = _buildStoryPrompt(...);
       final response = await _model.generateContent([Content.text(prompt)]);
       return response.text ?? '';
     }
     
     String _buildStoryPrompt(...) {
       // Age-appropriate word count
       int wordCount = length == 'short' ? 250 : length == 'medium' ? 500 : 900;
       
       return '''
You are a G-rated children's story generator for ages 3-12.

STRICT RULES:
1. Content must be 100% safe for $childAge-year-old
2. No violence, scary themes, profanity, inappropriate content
3. Positive, educational, fun
4. If request violates rules, refuse politely

REQUIREMENTS:
- Main character: $childName (age $childAge)
- Genre: $genre
- Length: Exactly $wordCount words
- Break into 3-5 pages with "--- PAGE X ---"
- Age-appropriate language for $ageBucket
- Make $childName the hero

OUTPUT FORMAT:
Title: [Story Title]
--- PAGE 1 ---
[Story text ~${wordCount ~/ 4} words]
...

Generate the story!
''';
     }
   }

2. core/constants/api_constants.dart:
   class ApiConstants {
     static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
   }

Run with: flutter run --dart-define=GEMINI_API_KEY=your_key
```

### 6.2 Content Safety

**Prompt:**
```
Implement content filtering service.

core/services/content_filter_service.dart:

class ContentFilterService {
  final List<String> _profanityList = [...]; // Add blocklist
  
  bool containsProfanity(String text) {
    return _profanityList.any((word) => 
      text.toLowerCase().contains(word));
  }
  
  Future<bool> isContentSafe(String text) async {
    // 1. Check profanity
    if (containsProfanity(text)) return false;
    
    // 2. Gemini has built-in safety (SafetySettings)
    // Content is already filtered by Gemini API
    
    return true;
  }
  
  String sanitizeText(String text) {
    String clean = text;
    for (final word in _profanityList) {
      clean = clean.replaceAll(
        RegExp(word, caseSensitive: false), '***');
    }
    return clean;
  }
}

Apply to all user inputs and AI outputs.
```

### 6.3 Story Creator UI

**Prompt:**
```
Create AI story creation wizard.

1. screens/story_creator_screen.dart:
   Multi-step wizard with progress indicator:
   
   STEP 1: Select Kid Profile
   - List of profiles
   - Show selected
   
   STEP 2: Story Settings
   - Genre chips: Adventure, Fantasy, Sci-Fi, Mystery, Funny, Magical, School, Spooky
   - Length buttons: Short (5min), Medium (10min), Long (15min)
   - Optional: Interests multi-select
   - Optional: Moral lesson input
   
   STEP 3: Art Style (Premium+)
   - Grid: Cartoon, Storybook, 3D, Anime
   - Show sample images
   
   STEP 4: Add Photo (Premium+ only)
   - Photo picker
   - "Put your kid in the story!"
   - Skip button
   
   STEP 5: Review & Generate
   - Summary of selections
   - Show AI credits remaining
   - "Generate Story" button
   
   GENERATION:
   - Full-screen loading animation
   - Progress messages: "Crafting your adventure...", "Adding magic..."
   - Estimated: 30-60 seconds
   - On success: Navigate to story reader
   - On error: Show error with retry

2. Check subscription limits before generation:
   - Free: 2/month
   - Premium: 20/month
   - Premium+: Unlimited
   
3. Increment usage counter after successful generation
```

---

## PHASE 7: IMAGE GENERATION (Week 5 - Day 13-14)

**Prompt:**
```
Setup image generation (placeholder for MVP, production needs Imagen API).

1. features/image_generation/domain/repositories/image_generation_repository.dart:
   abstract class ImageGenerationRepository {
     Future<Either<Failure, String>> generateImage({
       required String prompt,
       required String artStyle,
       File? referencePhoto,
     });
     Future<Either<Failure, void>> cacheImage(String url, String storyId, int page);
   }

2. For MVP: Use placeholder images
   - Return placeholder URLs from Unsplash
   - Save image prompts for future implementation
   
3. For Production: Integrate Imagen API or alternatives:
   - Use Gemini to generate detailed prompts
   - Call image generation API
   - Store images in Firebase Storage
   
4. Add to story creator:
   - Generate cover image
   - Generate scene images based on page text
   - Show loading progress
   - Cache generated images

5. Premium+ feature: Use kid's photo as reference
   - Upload photo to Gemini vision model
   - Prompt: "Generate $artStyle illustration of this child as [character]"
   - Maintain appearance (hair, skin tone, features)
```

---

## PHASE 8: AUDIO NARRATION (Week 5 - Day 14-15)

**Prompt:**
```
Implement text-to-speech audio narration (Premium feature).

1. features/audio_narration/domain/repositories/tts_repository.dart:
   abstract class TTSRepository {
     Future<Either<Failure, void>> speak(String text);
     Future<Either<Failure, void>> pause();
     Future<Either<Failure, void>> stop();
     Future<Either<Failure, void>> setSpeechRate(double rate);
     Stream<TTSState> get stateStream;
   }
   enum TTSState { idle, playing, paused }

2. data/repositories/tts_repository_impl.dart:
   import 'package:flutter_tts/flutter_tts.dart';
   
   class TTSRepositoryImpl implements TTSRepository {
     final FlutterTts _flutterTts;
     
     // Initialize TTS with handlers
     // Implement speak, pause, stop methods
     // Handle state changes
   }

3. Update story_reader_screen.dart:
   - Add play/pause button in bottom bar
   - Audio controls in settings panel
   - Speech rate slider (0.5x - 2.0x)
   - Auto-read mode toggle
   - Visual highlight of current text
   - Progress indicator during playback

4. Premium check:
   - Show "Upgrade for Audio" if free tier
   - Enable controls only for Premium+

Voices: Use system TTS voices (English by default).
```

---

## PHASE 9: FAVORITES & OFFLINE (Week 6 - Day 15-17)

### 9.1 Favorites

**Prompt:**
```
Implement favorites/bookmarks functionality.

1. features/favorites/domain/repositories/favorites_repository.dart:
   abstract class FavoritesRepository {
     Future<Either<Failure, void>> addFavorite(String storyId, String userId);
     Future<Either<Failure, void>> removeFavorite(String storyId, String userId);
     Future<Either<Failure, List<StoryEntity>>> getFavorites(String userId);
     Future<Either<Failure, bool>> isFavorite(String storyId, String userId);
   }

2. Implement with Firestore + Drift sync:
   - favorites collection in Firestore
   - isFavorite column in local Stories table
   - Sync across devices

3. screens/favorites_screen.dart:
   - Grid of favorite story cards
   - Same layout as library
   - Empty state: "No favorites yet! ❤️"
   - Pull to refresh
   - Swipe to remove

4. Add heart icon to:
   - Story cards (toggle favorite)
   - Story reader top bar
   - Animate heart fill/unfill

Favorites available to all tiers.
```

### 9.2 Offline Downloads

**Prompt:**
```
Implement offline story downloads (Premium feature).

1. features/offline/domain/repositories/offline_repository.dart:
   abstract class OfflineRepository {
     Future<Either<Failure, void>> downloadStory(String storyId);
     Future<Either<Failure, void>> deleteDownload(String storyId);
     Future<Either<Failure, List<StoryEntity>>> getDownloadedStories();
     Stream<DownloadProgress> watchDownloadProgress(String storyId);
   }
   
   @freezed class DownloadProgress {
     const factory DownloadProgress({
       required String storyId,
       required double progress, // 0.0 to 1.0
       required DownloadStatus status,
     }) = _DownloadProgress;
   }
   enum DownloadStatus { pending, downloading, completed, failed }

2. Implementation:
   - Download story data to Drift
   - Cache images to local storage (path_provider)
   - Track download progress
   - Enforce limits: Free=0, Premium=10, Premium+=unlimited

3. UI:
   - Download icon in story reader
   - Download progress indicator
   - Download manager screen
   - Show storage space used
   - Delete downloads option

Offline stories readable without internet.
```

---

## PHASE 10: SUBSCRIPTION & MONETIZATION (Week 6-7 - Day 17-20)

**Prompt:**
```
Implement three-tier subscription system.

1. features/subscription/domain/entities/subscription_entity.dart:
   @freezed class SubscriptionEntity {
     const factory SubscriptionEntity({
       required String id,
       required String userId,
       required SubscriptionTier tier,
       required DateTime startDate,
       DateTime? endDate,
       required bool isActive,
       @Default(0) int aiStoriesUsed,
       @Default(0) int aiStoriesLimit,
     }) = _SubscriptionEntity;
   }
   
   enum SubscriptionTier { free, premium, premiumPlus }

2. Create SubscriptionService:
   class SubscriptionService {
     bool canCreateAIStory(SubscriptionEntity sub) {
       if (sub.tier == SubscriptionTier.premiumPlus) return true;
       return sub.aiStoriesUsed < sub.tier.aiStoriesLimit;
     }
     
     bool canCreateKidProfile(SubscriptionEntity sub, int current) {
       final limits = {free: 1, premium: 3, premiumPlus: 999};
       return current < limits[sub.tier]!;
     }
     
     bool canDownloadStory(SubscriptionEntity sub, int current) {
       if (sub.tier == SubscriptionTier.free) return false;
       final limits = {premium: 10, premiumPlus: 999};
       return current < limits[sub.tier]!;
     }
     
     Future<void> incrementAIUsage(String userId) async {
       // Update Firestore counter
     }
   }

3. screens/subscription_screen.dart:
   - Three beautiful pricing cards
   - Feature comparison table
   - Current plan highlighted
   - "Upgrade" buttons
   - Success animations
   
4. Add paywall checks:
   - Before AI story creation
   - Before adding kid profiles (>limit)
   - Before downloading stories
   - Before using "kid in story" feature
   - Before PDF export
   
5. For MVP: Mock payments, focus on feature gating
   For Production: Integrate RevenueCat or Google Play Billing

Show upgrade prompts when limits reached.
```

### Parental Controls

**Prompt:**
```
Implement parental gate and content safety.

1. widgets/parental_gate_dialog.dart:
   - Simple math problem: "What is 15 + 8?"
   - Parent must solve to proceed
   - Use before: settings, subscription, photo upload, reporting

2. features/parental_controls/:
   - Toggle per kid: "Allow [Name] to create stories"
   - Requires parental gate to change
   - Enforced in story creator

3. Story reporting:
   - "Report Story" button in reader menu
   - Reasons: Inappropriate, Technical issue, Other
   - Store in Firestore for manual review

4. Safety guidelines screen:
   - Explain content policies
   - Age-appropriate guidelines
   - What to do if inappropriate content found
   - Contact support
```

---

## PHASE 11: PDF EXPORT (Week 7 - Day 20-21)

**Prompt:**
```
Implement PDF export (Premium+ feature).

1. Add to pubspec.yaml:
   pdf: ^3.11.1
   printing: ^5.13.4
   share_plus: ^10.1.2

2. features/pdf_export/domain/repositories/pdf_repository.dart:
   abstract class PDFRepository {
     Future<Either<Failure, File>> generatePDF(StoryEntity story);
     Future<Either<Failure, void>> sharePDF(File pdfFile);
     Future<Either<Failure, void>> printPDF(File pdfFile);
   }

3. Implementation:
   import 'package:pdf/pdf.dart';
   import 'package:pdf/widgets.dart' as pw;
   
   Future<Either<Failure, File>> generatePDF(StoryEntity story) async {
     final pdf = pw.Document();
     
     // Cover page
     pdf.addPage(pw.Page(
       build: (context) => pw.Center(
         child: pw.Column(
           mainAxisAlignment: pw.MainAxisAlignment.center,
           children: [
             pw.Text(story.title, style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold)),
             pw.SizedBox(height: 40),
             pw.Text('Created with StorySpace'),
           ],
         ),
       ),
     ));
     
     // Story pages
     for (final page in story.pages) {
       pdf.addPage(pw.Page(
         build: (context) => pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.start,
           children: [
             pw.Text(page.text, style: pw.TextStyle(fontSize: 14, lineSpacing: 1.5)),
             pw.Spacer(),
             pw.Align(
               alignment: pw.Alignment.bottomRight,
               child: pw.Text('Page ${page.pageNumber}'),
             ),
           ],
         ),
       ));
     }
     
     final output = await getTemporaryDirectory();
     final file = File('${output.path}/${story.title}.pdf');
     await file.writeAsBytes(await pdf.save());
     return Right(file);
   }

4. Add to story reader menu:
   - "Export to PDF" button (Premium+ only)
   - Loading during generation
   - Options: Save, Share, Print
   - Check subscription before allowing

For production: Include actual images in PDF.
```

---

## PHASE 12: HOME & NAVIGATION (Week 7 - Day 21-22)

**Prompt:**
```
Create main home screen with bottom navigation.

1. features/home/presentation/screens/home_screen.dart:
   class HomeScreen extends ConsumerStatefulWidget {
     // Bottom navigation with 4 tabs
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       return Scaffold(
         body: IndexedStack(
           index: _currentIndex,
           children: [
             StoryLibraryScreen(),    // Tab 1
             StoryCreatorScreen(),    // Tab 2
             FavoritesScreen(),       // Tab 3
             ProfileScreen(),         // Tab 4
           ],
         ),
         bottomNavigationBar: NavigationBar(
           selectedIndex: _currentIndex,
           onDestinationSelected: (index) => setState(() => _currentIndex = index),
           destinations: [
             NavigationDestination(icon: Icon(Icons.library_books), label: 'Library'),
             NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'Create'),
             NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
             NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
           ],
         ),
       );
     }
   }

2. ProfileScreen:
   - Current kid profile display
   - Switch profiles button
   - Subscription tier badge
   - Reading stats: Stories read, Stories created, Streak
   - Settings button
   - Upgrade button (if not Premium+)
   - Sign out button

3. SettingsScreen:
   Sections:
   - Account: Edit profile, Change password, Delete account
   - Kid Profiles: Manage profiles
   - Subscription: Current plan, Usage stats, Manage
   - Audio: TTS settings, Speech rate, Voice
   - Content: Age filters, Creation permissions
   - Privacy: Data policy, Photo permissions
   - About: Version, Terms, Privacy, Support
   
   Require parental gate for all changes.
```

---

## PHASE 13: POLISH & OPTIMIZATION (Week 8 - Day 23-25)

### 13.1 Loading States & Errors

**Prompt:**
```
Implement comprehensive loading states and error handling.

1. core/widgets/loading_states.dart:
   - ShimmerLoading for lists
   - SkeletonLoader for cards
   - FullScreenLoading with branding
   - InlineLoading (circular indicator)

2. core/widgets/error_widgets.dart:
   - ErrorDisplay with retry button
   - NoInternetError
   - NotFoundError (404-style)
   - PermissionError

3. core/widgets/empty_states.dart:
   - EmptyLibrary: "No stories yet"
   - EmptyFavorites: "Add some favorites! ❤️"
   - EmptySearchResults: "No results found"
   - NoKidProfiles: "Create a profile to start"

Apply throughout:
- All API calls have loading states
- All errors user-friendly with retry
- All lists have empty states
- Network errors offer retry
- Offline mode graceful
```

### 13.2 Animations

**Prompt:**
```
Add smooth animations throughout.

1. Page transitions:
   - Fade + slide for screens
   - Hero animation: story card → reader
   - Custom wizard step transitions

2. List animations:
   - Staggered grid animation
   - Fade in for loaded items
   - Swipe animation for delete

3. Button animations:
   - Scale on press
   - Ripple effect
   - Loading → success transitions

4. Story reader:
   - Page turn animation
   - Image fade-in
   - Text reveal

5. Favorites:
   - Heart fill animation
   - Bounce effect

Keep under 300ms, smooth 60fps.
Use implicit animations where possible.
```

### 13.3 Performance

**Prompt:**
```
Optimize performance for smooth experience.

1. Images:
   - cached_network_image with proper config
   - Compress before upload
   - Lazy load in lists
   - Placeholders while loading

2. Lists:
   - ListView.builder for long lists
   - Pagination (20 items/page)
   - RepaintBoundary for expensive widgets

3. Memory:
   - Dispose controllers properly
   - Clear image cache periodically
   - Limit in-memory cache

4. Database:
   - Add indexes to Drift tables
   - Optimize queries
   - Batch operations

5. Build optimization:
   - Use const constructors everywhere
   - Avoid rebuilds with proper Riverpod usage
   - Extract static widgets

Profile with Flutter DevTools.
Target: 60fps on mid-range devices.
```

---

## PHASE 14: TESTING (Week 9 - Day 26-28)

### 14.1 Unit Tests

**Prompt:**
```
Create comprehensive unit tests for business logic.

test/features/:

1. Auth tests:
   - Sign in/up validation
   - Repository methods
   - Error handling

2. Kid profile tests:
   - CRUD operations
   - Age bucket calculation
   - Photo upload

3. Story tests:
   - Fetching, searching
   - Favorites toggle
   - Offline caching

4. Subscription tests:
   - Tier validation
   - Limit checking
   - Usage tracking

5. AI generation tests:
   - Mock Gemini responses
   - Story parsing
   - Content filtering

Use mocktail for mocking.
Target: 80%+ coverage on domain/data layers.

Example structure:
test/features/auth/domain/repositories/auth_repository_test.dart
```

### 14.2 Widget Tests

**Prompt:**
```
Create widget tests for UI components.

1. Test auth screens:
   - Form validation
   - Button interactions
   - Error display

2. Test story library:
   - Card rendering
   - Filters
   - Search

3. Test story reader:
   - Page navigation
   - Controls

4. Test creator wizard:
   - Step progression
   - Form validation

Use ProviderScope for Riverpod.
Mock providers where needed.
```

### 14.3 Integration Tests

**Prompt:**
```
Create integration tests for critical flows.

integration_test/:

1. auth_flow_test.dart:
   - Complete signup
   - Login and navigate
   - Logout

2. story_reading_flow_test.dart:
   - Browse library
   - Open and read story
   - Add to favorites

3. story_creation_flow_test.dart:
   - Create kid profile
   - Complete wizard
   - Generate AI story

4. subscription_flow_test.dart:
   - Attempt premium feature (blocked)
   - View pricing
   - Upgrade flow

Run on real devices.
```

---

## PHASE 15: LAUNCH PREPARATION (Week 10 - Day 29-30)

### 15.1 Assets & Branding

**Prompt:**
```
Prepare all launch assets.

1. App Icons:
   - Create adaptive icon
   - Multiple sizes (48-192dp)
   - Use flutter_launcher_icons package

2. Splash Screen:
   - Update native splash
   - Use flutter_native_splash package

3. Onboarding illustrations:
   - Create/source 3 high-quality images
   - Optimize for mobile

4. Compress all assets
   - Optimize images
   - Remove unused assets

Run generators:
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### 15.2 Firebase Security Rules

**Prompt:**
```
Create production Firestore rules.

firestore.rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if false;
    }
    
    match /kid_profiles/{profileId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    match /stories/{storyId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.resource.data.authorId == request.auth.uid;
      allow update: if isAuthenticated() && resource.data.authorId == request.auth.uid;
      allow delete: if isAuthenticated() && resource.data.authorId == request.auth.uid;
    }
    
    match /favorites/{favoriteId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    match /subscriptions/{subscriptionId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow write: if false; // Server only
    }
  }
}

storage.rules:

rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /kid_profiles/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == userId &&
        request.resource.size < 5 * 1024 * 1024 &&
        request.resource.contentType.matches('image/.*');
    }
    
    match /story_images/{storyId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null &&
        request.resource.size < 10 * 1024 * 1024 &&
        request.resource.contentType.matches('image/.*');
    }
  }
}

Deploy: firebase deploy --only firestore:rules,storage
```

### 15.3 Play Store Preparation

**Prompt:**
```
Prepare for Google Play Store.

1. Update build.gradle:
   - versionName: "1.0.0"
   - versionCode: 1
   - minSdkVersion: 23
   - targetSdkVersion: 34

2. Generate signing key:
   keytool -genkey -v -keystore storyspace-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias storyspace

3. Create key.properties (add to .gitignore)

4. Update android/app/build.gradle with signing config

5. Build release:
   flutter build appbundle --release --dart-define=GEMINI_API_KEY=prod_key

6. Play Store listing:
   - App name: StorySpace
   - Short description (80 chars)
   - Full description (4000 chars)
   - Category: Education > Family
   - Content rating: PEGI 3 / Everyone
   - Privacy policy URL
   - Support email

7. Screenshots (4-8 per device type):
   - Phone screenshots
   - 7" tablet screenshots
   - 10" tablet screenshots
   Show: Library, Reader, AI Creation, Profiles

8. Feature graphic: 1024x500px
9. App icon: 512x512px

10. Privacy policy & Terms of Service

11. Testing stages:
    - Internal testing
    - Closed alpha (small group)
    - Open beta (larger audience)
    - Production (gradual rollout: 10% → 50% → 100%)
```

---

## ✅ PROGRESS TRACKING {#progress}

### MVP (7 Days)
- [ ] Phase 1: Foundation (Day 1-2)
- [ ] Phase 2: Authentication (Day 2-3)
- [ ] Phase 3: Kid Profiles (Day 3-4)
- [ ] Phase 4: Story Library (Day 4-7)
- [ ] Phase 5: Story Reader (Day 7-8)
- [ ] Phase 6: AI Generation (Day 8-12)

### Full Launch (10 Weeks)
- [ ] Phase 7: Image Generation (Week 5)
- [ ] Phase 8: Audio Narration (Week 5)
- [ ] Phase 9: Favorites & Offline (Week 6)
- [ ] Phase 10: Subscription (Week 6-7)
- [ ] Phase 11: PDF Export (Week 7)
- [ ] Phase 12: Home & Navigation (Week 7)
- [ ] Phase 13: Polish (Week 8)
- [ ] Phase 14: Testing (Week 9)
- [ ] Phase 15: Launch Prep (Week 10)

---

## 🔧 TROUBLESHOOTING {#troubleshooting}

### Common Issues

**1. Build Runner Conflicts**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**2. Firebase Init Error**
- Check google-services.json in android/app/
- Verify FlutterFire CLI configuration
- Ensure firebase_core initialized in main()

**3. Riverpod Not Updating**
- Use .watch() not .read() in build
- Check if AutoDispose when shouldn't be
- Use ref.invalidate() to force refresh

**4. Gemini API Errors**
- Verify API key correct
- Check internet connection
- Review safety settings
- Check API quotas

**5. Images Not Loading**
- Check Storage rules
- Verify URLs valid
- Check network permissions in AndroidManifest.xml

**6. TTS Not Working**
- Check audio permissions
- Verify TTS engine installed
- Test with simple text
- Check volume settings

**7. Drift Database Errors**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**8. Subscription Limits Not Enforced**
- Check subscription state in Firestore
- Verify checks before actions
- Ensure counters updating

---

## 🎯 CRITICAL REMINDERS

### For Claude Code:

1. ✅ **Always use freezed** for data models/entities
2. ✅ **Use Either<Failure, T>** for repository returns
3. ✅ **Dispose controllers** in dispose()/ref.onDispose()
4. ✅ **Add const** constructors everywhere
5. ✅ **Follow Clean Architecture** (domain → data → presentation)
6. ✅ **Use @riverpod** code generation
7. ✅ **Handle offline** scenarios gracefully
8. ✅ **Check subscription** before premium features
9. ✅ **Content safety** filters for all AI content
10. ✅ **Test business logic** (80%+ coverage)

### When to Ask for Help:

- Gemini API integration issues
- Firebase rules optimization
- Performance problems
- Payment integration
- Complex animations

### Security Checklist:

- ✅ API keys in environment variables
- ✅ Firebase rules configured
- ✅ User data encrypted
- ✅ Photos stored securely
- ✅ Content filtering active
- ✅ Parental gate implemented
- ✅ HTTPS for all requests

### Success Metrics:

- ✅ All features work
- ✅ 80%+ test coverage
- ✅ No memory leaks
- ✅ 60fps performance
- ✅ Offline reading works
- ✅ AI generation < 60s
- ✅ App size < 50MB
- ✅ Crash-free > 99.5%
- ✅ Subscription limits enforced
- ✅ Content safety 100%

---

## 🚀 DEPLOYMENT COMMANDS

### Development:
```bash
# Run with API key
flutter run --dart-define=GEMINI_API_KEY=your_key

# Run tests
flutter test

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get
```

### Production:
```bash
# Build release
flutter build appbundle --release --dart-define=GEMINI_API_KEY=prod_key

# Deploy Firebase rules
firebase deploy --only firestore:rules,storage

# Deploy Cloud Functions (if added)
firebase deploy --only functions
```

---

## 📅 TIMELINE SUMMARY

### Fast MVP (7 days):
- **Day 1-2:** Foundation + Auth (Phases 1-2)
- **Day 3-4:** Kid Profiles + Library (Phases 3-4)
- **Day 4-7:** Story Library completion
- **Day 7-8:** Story Reader (Phase 5)
- **Day 8-12:** AI Generation (Phase 6)

**Result:** Functional app with user auth, kid profiles, story library, reading, and AI story generation (text only, placeholder images).

### Full Launch (10 weeks):
- **Week 1:** Foundation + Auth
- **Week 2:** Profiles + Library
- **Week 3:** Reader + AI Start
- **Week 4:** AI Complete
- **Week 5:** Images + Audio
- **Week 6:** Favorites + Offline + Subscription
- **Week 7:** PDF + Home + Navigation
- **Week 8:** Polish + Optimization
- **Week 9:** Testing
- **Week 10:** Launch Prep

---

## 📚 RESOURCE LINKS

- **Flutter:** https://docs.flutter.dev
- **Riverpod:** https://riverpod.dev
- **Firebase:** https://firebase.google.com/docs
- **Gemini API:** https://ai.google.dev/docs
- **Material 3:** https://m3.material.io
- **Drift:** https://drift.simonbinder.eu

---

## 🎉 FINAL NOTES

### For Rapid Development:

1. **Start with MVP** (Phases 1-6 = 7-12 days)
2. **Use placeholders** for images initially
3. **Mock payments** for subscription
4. **Focus on core loop**: Browse → Read → Create → Read
5. **Test continuously** as you build

### Post-MVP Enhancements:

- **Phase 16:** Story sharing, collaborative creation
- **Phase 17:** Analytics dashboard, achievements
- **Phase 18:** Social features, contests
- **Phase 19:** Advanced AI (voice cloning, interactive)
- **Phase 20:** iOS, Web, Desktop

### Key Success Factors:

1. **Content safety** is non-negotiable
2. **Performance** matters (kids expect smooth)
3. **Simplicity** in UI (age-appropriate)
4. **Delight** in animations and visuals
5. **Value** in subscription tiers

---

**🚀 Ready to build StorySpace!**

Start with Phase 1, Task 1.1.  
Work systematically through each phase.  
Test thoroughly at each milestone.  
Launch with confidence!

**Good luck! 📚✨🎨**