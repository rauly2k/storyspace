import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';

/// Service for generating AI content using Google's Gemini API.
class GeminiService {
  late final GenerativeModel _model;
  static const String _modelName = 'gemini-1.5-flash';

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY not found in environment variables. '
        'Please add it to your .env file.',
      );
    }

    _model = GenerativeModel(
      model: _modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.9, // More creative
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
      safetySettings: [
        SafetySetting(
          HarmCategory.harassment,
          HarmBlockThreshold.high,
        ),
        SafetySetting(
          HarmCategory.hateSpeech,
          HarmBlockThreshold.high,
        ),
        SafetySetting(
          HarmCategory.sexuallyExplicit,
          HarmBlockThreshold.high,
        ),
        SafetySetting(
          HarmCategory.dangerousContent,
          HarmBlockThreshold.high,
        ),
      ],
    );
  }

  /// Generate a personalized story for a child.
  ///
  /// Parameters:
  /// - [kidName]: Name of the child (protagonist)
  /// - [age]: Age of the child (determines complexity and length)
  /// - [genre]: Story genre (adventure, fantasy, educational, etc.)
  /// - [interests]: List of child's interests to incorporate
  /// - [customPrompt]: Optional custom prompt from parent
  Future<String> generateStory({
    required String kidName,
    required int age,
    required String genre,
    required List<String> interests,
    String? customPrompt,
  }) async {
    final ageBucket = AppConstants.getAgeBucket(age);
    final wordCount = AppConstants.getWordCountForAgeBucket(ageBucket);
    final interestsText = interests.isEmpty
        ? 'general themes suitable for their age'
        : interests.join(', ');

    final prompt = _buildPrompt(
      kidName: kidName,
      age: age,
      ageBucket: ageBucket,
      genre: genre,
      interests: interestsText,
      wordCount: wordCount,
      customPrompt: customPrompt,
    );

    try {
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Generated story is empty');
      }

      return response.text!;
    } catch (e) {
      throw Exception('Failed to generate story: ${e.toString()}');
    }
  }

  /// Build the prompt for story generation.
  String _buildPrompt({
    required String kidName,
    required int age,
    required String ageBucket,
    required String genre,
    required String interests,
    required int wordCount,
    String? customPrompt,
  }) {
    final basePrompt = '''
You are a professional children's story writer. Create an engaging, age-appropriate $genre story for a $age-year-old child named $kidName.

STORY REQUIREMENTS:
- Age Group: $ageBucket ($age years old)
- Target Length: Approximately $wordCount words
- Genre: $genre
- Protagonist: $kidName (the child reading the story)
- Themes/Interests: $interests
- Writing Style: Age-appropriate vocabulary, sentence structure, and themes
- Content: Safe, educational, and inspiring for children

STORY STRUCTURE:
1. Engaging opening that captures attention
2. Clear problem or adventure for $kidName to navigate
3. Age-appropriate challenges and solutions
4. Positive message or lesson
5. Satisfying conclusion

TONE & STYLE:
- Use vivid, descriptive language suitable for $age-year-olds
- Include dialogue to make the story engaging
- Incorporate sensory details (what $kidName sees, hears, feels)
- Keep sentences ${ageBucket == 'Sprout' ? 'short and simple' : ageBucket == 'Explorer' ? 'moderately complex' : 'varied and engaging'}
- Make $kidName the hero of the story

${customPrompt != null && customPrompt.isNotEmpty ? '\nADDITIONAL PARENT REQUEST:\n$customPrompt\n' : ''}

Write the complete story now. Do not include a title or any preamble - start directly with the story.
''';

    return basePrompt;
  }

  /// Generate a story title based on the story content.
  Future<String> generateTitle({
    required String storyContent,
    required String genre,
  }) async {
    final prompt = '''
Based on this children's story, create a short, catchy title (maximum 6 words) that captures the essence of the adventure:

$storyContent

Genre: $genre

Provide only the title, nothing else.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Generated title is empty');
      }

      return response.text!.trim();
    } catch (e) {
      // Fallback to generic title if generation fails
      return 'An Amazing $genre Adventure';
    }
  }
}
