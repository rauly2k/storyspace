# StorySpace 📚✨

**Unde poveștile prind viață** / **Where Stories Come Alive**

StorySpace is a beautiful Flutter mobile application that creates personalized, AI-generated children's stories in Romanian. Powered by Google's Gemini AI, it brings magical storytelling experiences to Romanian children aged 3-12.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase)

## ✨ Features

### Core Features
- 🤖 **AI Story Generation**: Personalized stories powered by Gemini 1.5 Flash
- 👶 **Age-Appropriate Content**: Stories tailored for three age groups (3-5, 6-8, 9-12 years)
- 🇷🇴 **Romanian Localization**: Full Romanian language support
- 👨‍👩‍👧‍👦 **Multiple Kid Profiles**: Each child gets personalized experiences
- 📚 **Rich Story Library**: 35+ pre-made stories across multiple genres
- 🎨 **Art Style Selection**: Choose from Cartoon, Storybook, 3D, and Anime styles
- 📱 **Offline Support**: Download stories for offline reading with Drift/SQLite
- 🔊 **Audio Narration**: Text-to-speech with adjustable speech rates
- ❤️ **Favorites**: Save and organize favorite stories
- 📄 **PDF Export**: Export stories as beautiful PDFs (Premium+)

### Technical Features
- 🏗️ **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- 🔄 **Riverpod State Management**: Modern, type-safe state management with code generation
- 🔥 **Firebase Backend**: Authentication, Firestore, and Cloud Storage
- 💾 **Local Database**: Drift (SQLite) for offline-first approach
- 🎯 **GoRouter Navigation**: Declarative routing with deep linking support
- 🎨 **Material 3 Design**: Modern, beautiful UI with custom theming
- ⚡ **Performance Optimized**: Image caching, lazy loading, efficient data fetching
- 🔒 **Secure**: Comprehensive Firebase Security Rules

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.8.1
- Dart SDK >= 3.8.1
- Firebase account and project
- Google Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rauly2k/storyspace.git
   cd storyspace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   Create a `.env` file in the root:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Deploy security rules:
     ```bash
     firebase deploy --only firestore:rules,storage:rules
     ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🎯 Subscription Tiers

| Feature | Free | Premium (4.99 LEI/mo) | Premium+ (9.99 LEI/mo) |
|---------|------|----------|-----------|
| Kid Profiles | 1 | 3 | Unlimited |
| AI Stories/Month | 2 | 20 | Unlimited |
| Pre-made Stories | 5 | Unlimited | Unlimited |
| Offline Downloads | ❌ | 10 | Unlimited |
| Audio Narration | ❌ | ✅ | ✅ |
| Photo in Story | ❌ | ❌ | ✅ |
| PDF Export | ❌ | ❌ | ✅ |

## 📚 Story Library

**35+ stories** in Romanian and English across genres:
- 🏰 Fantasy & Adventure
- 🚀 Sci-Fi
- 🔍 Mystery
- 😄 Funny
- ✨ Magical
- 🏫 School
- 👻 Spooky (friendly)
- 🌙 Bedtime
- 📖 Learning

## 🏗️ Architecture

Clean Architecture with feature-based modules:

```
lib/
├── core/                 # Shared infrastructure
│   ├── constants/        # App constants
│   ├── theme/            # Material 3 theme
│   ├── router/           # GoRouter config
│   ├── database/         # Drift database
│   └── widgets/          # Reusable widgets
│
└── features/             # Feature modules
    ├── auth/             # Authentication
    ├── kid_profile/      # Kid profiles
    ├── story/            # Stories
    ├── story_creator/    # AI story wizard
    ├── subscription/     # Subscriptions
    └── [more...]
```

## 📄 License

Private and proprietary. All rights reserved.

## 👨‍💻 Author

**Raul**
GitHub: [@rauly2k](https://github.com/rauly2k)

---

**Made with ❤️ in Romania for Romanian children**

*StorySpace - Unde poveștile prind viață*
