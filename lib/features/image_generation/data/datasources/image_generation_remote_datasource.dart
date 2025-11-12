import 'dart:io';
import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../domain/entities/art_style.dart';
import '../../domain/entities/image_generation_request.dart';
import '../models/generated_image_model.dart';

/// Remote datasource for image generation
/// MVP: Uses Unsplash placeholder images
/// Production: Will use Imagen API or Stable Diffusion
abstract class ImageGenerationRemoteDataSource {
  Future<GeneratedImageModel> generateImage(ImageGenerationRequest request);
  Future<List<GeneratedImageModel>> generateMultipleImages(
    List<ImageGenerationRequest> requests,
  );
}

class ImageGenerationRemoteDataSourceImpl
    implements ImageGenerationRemoteDataSource {
  final _uuid = const Uuid();
  final _random = Random();

  /// Collection categories based on story themes
  static const Map<String, List<String>> _unsplashCollections = {
    'adventure': ['3330445', '3356384', '1154337'],
    'fantasy': ['4489987', '1154654', '8892102'],
    'mystery': ['4329519', '8892102', '1154337'],
    'science fiction': ['2203755', '8892102', '1154654'],
    'educational': ['3356384', '1154337', '4489987'],
    'friendship': ['4489987', '1154337', '3356384'],
    'animal story': ['3330445', '139386', '1154337'],
    'fairy tale': ['4489987', '1154654', '8892102'],
  };

  @override
  Future<GeneratedImageModel> generateImage(
    ImageGenerationRequest request,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate placeholder image URL
    final imageUrl = _generatePlaceholderUrl(request);

    return GeneratedImageModel(
      id: _uuid.v4(),
      url: imageUrl,
      prompt: request.prompt,
      generatedAt: DateTime.now(),
      isCached: false,
    );
  }

  @override
  Future<List<GeneratedImageModel>> generateMultipleImages(
    List<ImageGenerationRequest> requests,
  ) async {
    final images = <GeneratedImageModel>[];

    for (final request in requests) {
      final image = await generateImage(request);
      images.add(image);
      // Small delay between generations
      await Future.delayed(const Duration(milliseconds: 200));
    }

    return images;
  }

  /// Generate placeholder image URL using Unsplash
  /// Format: https://source.unsplash.com/800x600/?keywords
  String _generatePlaceholderUrl(ImageGenerationRequest request) {
    // Extract keywords from prompt
    final keywords = _extractKeywords(request.prompt);

    // Use Picsum Photos as a reliable alternative to Unsplash Source
    // Random seed based on prompt for consistency
    final seed = request.prompt.hashCode.abs();

    // Return Picsum URL with blur for a more artistic look
    return 'https://picsum.photos/seed/$seed/800/600';
  }

  /// Extract relevant keywords from prompt for image search
  List<String> _extractKeywords(String prompt) {
    final keywords = <String>[];

    // Common story elements
    final elements = [
      'dragon', 'princess', 'castle', 'forest', 'ocean', 'space',
      'robot', 'animal', 'adventure', 'magic', 'hero', 'friend',
      'mountain', 'city', 'village', 'night', 'day', 'rainbow'
    ];

    final lowerPrompt = prompt.toLowerCase();
    for (final element in elements) {
      if (lowerPrompt.contains(element)) {
        keywords.add(element);
      }
    }

    if (keywords.isEmpty) {
      keywords.add('storybook');
    }

    return keywords.take(3).toList();
  }
}

/// Production implementation using Gemini Imagen (Future)
class ImageGenerationProduction implements ImageGenerationRemoteDataSource {
  // TODO: Implement Imagen API or Stable Diffusion integration
  // This will be used when the app is ready for production

  @override
  Future<GeneratedImageModel> generateImage(
    ImageGenerationRequest request,
  ) async {
    throw UnimplementedError('Production image generation not yet implemented');
  }

  @override
  Future<List<GeneratedImageModel>> generateMultipleImages(
    List<ImageGenerationRequest> requests,
  ) async {
    throw UnimplementedError('Production image generation not yet implemented');
  }
}
