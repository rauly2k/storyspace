import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../kid_profile/presentation/providers/kid_profile_providers.dart';
import '../../../story/presentation/providers/story_providers.dart';
import '../../../story/domain/entities/story_entity.dart';
import '../widgets/category_chip.dart';
import '../widgets/recommended_story_card.dart';

/// Home screen content (without Scaffold - provided by AppShellScreen)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final currentKidProfileAsync = ref.watch(currentKidProfileProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcome Row
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Profile and greeting
                  Expanded(
                    child: Row(
                      children: [
                        // Profile Avatar
                        currentKidProfileAsync.when(
                          data: (profile) {
                            if (profile == null) {
                              return CircleAvatar(
                                radius: 24.0,
                                backgroundColor: AppColors.primary,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              );
                            }
                            return CircleAvatar(
                              radius: 24.0,
                              backgroundColor: AppColors.primary,
                              backgroundImage: profile.photoUrl != null
                                  ? NetworkImage(profile.photoUrl!)
                                  : null,
                              child: profile.photoUrl == null
                                  ? Text(
                                      profile.initial,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            );
                          },
                          loading: () => CircleAvatar(
                            radius: 24.0,
                            backgroundColor: AppColors.surfaceVariant,
                          ),
                          error: (_, __) => CircleAvatar(
                            radius: 24.0,
                            backgroundColor: AppColors.error,
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Greeting
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              currentKidProfileAsync.when(
                                data: (profile) {
                                  final name = profile?.name ?? 'Friend';
                                  return Text(
                                    '$name!',
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                                loading: () => Text(
                                  'Loading...',
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                error: (_, __) => Text(
                                  'Friend!',
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side: Notification bell
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      // TODO: Implement notifications
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to Library screen with search focused
                  context.push(AppRoutes.library);
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search for a story',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),

            // Story Categories Section
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
              child: Text(
                'Story Categories',
                style: textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 120.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16.0),
                itemCount: _storyCategories.length,
                itemBuilder: (context, index) {
                  final category = _storyCategories[index];
                  return CategoryChip(
                    label: category['label'] as String,
                    iconAssetPath: category['icon'] as String,
                    backgroundColor: category['color'] as Color,
                  );
                },
              ),
            ),

            // Recommended Section
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended',
                    style: textTheme.titleLarge,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Library screen (shows all stories)
                      context.push('/library');
                    },
                    child: Text(
                      'See all',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Recommended Stories List
            currentKidProfileAsync.when(
              data: (profile) {
                if (profile == null) {
                  return const SizedBox(
                    height: 220.0,
                    child: Center(
                      child: Text('No kid profile found'),
                    ),
                  );
                }

                final storiesAsync = ref.watch(storiesForKidProvider(profile.id));
                return storiesAsync.when(
                  data: (stories) {
                    if (stories.isEmpty) {
                      return SizedBox(
                        height: 220.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 48.0,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'No stories yet',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Create your first story!',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 220.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16.0),
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          final story = stories[index];
                          return RecommendedStoryCard(
                            story: story,
                            onTap: () {
                              // Navigate to story viewer
                              context.push(
                                AppRoutes.storyViewer,
                                extra: {
                                  'story': story,
                                  'kidProfile': profile,
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    height: 220.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (error, stack) => SizedBox(
                    height: 220.0,
                    child: Center(
                      child: Text(
                        'Error loading stories',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => SizedBox(
                height: 220.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
              error: (_, __) => SizedBox(
                height: 220.0,
                child: Center(
                  child: Text(
                    'Error loading profile',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

// Sample story categories (you can customize these)
final List<Map<String, dynamic>> _storyCategories = [
  {
    'label': 'Adventure',
    'icon': 'assets/icons/adventure.png',
    'color': AppColors.genreAdventure,
  },
  {
    'label': 'Fantasy',
    'icon': 'assets/icons/fantasy.png',
    'color': AppColors.genreFantasy,
  },
  {
    'label': 'Sci-Fi',
    'icon': 'assets/icons/scifi.png',
    'color': AppColors.genreSciFi,
  },
  {
    'label': 'Mystery',
    'icon': 'assets/icons/mystery.png',
    'color': AppColors.genreMystery,
  },
  {
    'label': 'Funny',
    'icon': 'assets/icons/funny.png',
    'color': AppColors.genreFunny,
  },
  {
    'label': 'Magical',
    'icon': 'assets/icons/magical.png',
    'color': AppColors.genreMagical,
  },
];
