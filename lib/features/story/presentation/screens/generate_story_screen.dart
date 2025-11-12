import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../kid_profile/domain/entities/kid_profile_entity.dart';
import '../../../image_generation/domain/entities/art_style.dart';
import '../../../image_generation/presentation/widgets/art_style_selector.dart';
import '../providers/story_providers.dart';

/// Screen for generating AI stories using Gemini.
class GenerateStoryScreen extends ConsumerStatefulWidget {
  final KidProfileEntity kidProfile;

  const GenerateStoryScreen({
    super.key,
    required this.kidProfile,
  });

  @override
  ConsumerState<GenerateStoryScreen> createState() => _GenerateStoryScreenState();
}

class _GenerateStoryScreenState extends ConsumerState<GenerateStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customPromptController = TextEditingController();

  String _selectedGenre = 'Adventure';
  ArtStyle _selectedArtStyle = ArtStyle.cartoon;
  bool _generateImages = true;
  bool _isGenerating = false;

  static const List<String> _genres = [
    'Adventure',
    'Fantasy',
    'Mystery',
    'Science Fiction',
    'Educational',
    'Friendship',
    'Animal Story',
    'Fairy Tale',
  ];

  @override
  void dispose() {
    _customPromptController.dispose();
    super.dispose();
  }

  Future<void> _generateStory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    final controller = ref.read(storyControllerProvider.notifier);
    final success = await controller.generateAIStory(
      kidProfileId: widget.kidProfile.id,
      kidName: widget.kidProfile.name,
      kidAge: widget.kidProfile.age,
      genre: _selectedGenre,
      interests: widget.kidProfile.interests,
      customPrompt: _customPromptController.text.trim().isEmpty
          ? null
          : _customPromptController.text.trim(),
      artStyle: _selectedArtStyle.label,
      generateImages: _generateImages,
    );

    if (mounted) {
      setState(() => _isGenerating = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Story generated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        final error = ref.read(storyControllerProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error != null ? error.toString() : 'Failed to generate story',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageBucketColor = AppColors.getAgeBucketColor(widget.kidProfile.ageBucket);
    final wordCount = AppConstants.getWordCountForAgeBucket(widget.kidProfile.ageBucket);

    return Scaffold(
      backgroundColor: ageBucketColor.withOpacity(0.05),
      appBar: AppBar(
        title: const Text('Generate AI Story'),
      ),
      body: _isGenerating ? _buildGeneratingView() : _buildForm(ageBucketColor, wordCount),
    );
  }

  Widget _buildGeneratingView() {
    final ageBucketColor = AppColors.getAgeBucketColor(widget.kidProfile.ageBucket);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: ageBucketColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Creating a magical story for ${widget.kidProfile.name}...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ageBucketColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _generateImages
                  ? 'Generating story and images...\nThis may take 30-60 seconds'
                  : 'This may take 10-30 seconds',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(Color ageBucketColor, int wordCount) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ageBucketColor.withOpacity(0.2),
                    ageBucketColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 32,
                        color: ageBucketColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Story for ${widget.kidProfile.name}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: ageBucketColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Age: ${widget.kidProfile.age} years (${widget.kidProfile.ageBucket})',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Story length: ~$wordCount words',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Genre selection
            Text(
              'Story Genre',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _genres.map((genre) {
                final isSelected = _selectedGenre == genre;
                return ChoiceChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedGenre = genre);
                    }
                  },
                  selectedColor: ageBucketColor.withOpacity(0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? ageBucketColor : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                  side: BorderSide(
                    color: isSelected ? ageBucketColor : Colors.grey[300]!,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Art Style Selection
            ArtStyleSelector(
              selectedStyle: _selectedArtStyle,
              onStyleSelected: (style) {
                setState(() => _selectedArtStyle = style);
              },
              isPremium: true, // TODO: Check actual subscription status
            ),

            const SizedBox(height: 32),

            // Generate Images Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ageBucketColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ageBucketColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.image,
                    color: ageBucketColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate Images',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create cover and scene images for your story',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _generateImages,
                    onChanged: (value) {
                      setState(() => _generateImages = value);
                    },
                    activeColor: ageBucketColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Interests display
            if (widget.kidProfile.interests.isNotEmpty) ...[
              Text(
                '${widget.kidProfile.name}\'s Interests',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ageBucketColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ageBucketColor.withOpacity(0.3),
                  ),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.kidProfile.interests.map((interest) {
                    return Chip(
                      label: Text(interest),
                      backgroundColor: ageBucketColor.withOpacity(0.2),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The AI will incorporate these interests into the story',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 32),
            ],

            // Custom prompt
            Text(
              'Custom Request (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _customPromptController,
              maxLines: 4,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'e.g., Include a dragon, make it funny, teach about sharing...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Generate button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isGenerating ? null : _generateStory,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Story'),
                style: FilledButton.styleFrom(
                  backgroundColor: ageBucketColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Story generation typically takes ${_generateImages ? '30-60' : '10-30'} seconds. '
                      'The AI will create a personalized story${_generateImages ? ' with beautiful illustrations' : ''} '
                      'based on ${widget.kidProfile.name}\'s age, interests, and your custom request.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[900],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
