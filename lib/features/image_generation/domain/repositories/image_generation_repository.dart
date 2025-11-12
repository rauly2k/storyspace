import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/art_style.dart';
import '../entities/generated_image.dart';
import '../entities/image_generation_request.dart';

/// Repository interface for image generation operations
abstract class ImageGenerationRepository {
  /// Generate a cover image for a story
  Future<Either<Failure, GeneratedImage>> generateCoverImage({
    required String storyTitle,
    required String storyGenre,
    required ArtStyle artStyle,
    required String ageBucket,
    File? referencePhoto,
  });

  /// Generate scene images based on story text
  Future<Either<Failure, List<GeneratedImage>>> generateSceneImages({
    required List<String> sceneDescriptions,
    required ArtStyle artStyle,
    required String ageBucket,
    File? referencePhoto,
  });

  /// Generate a single image from a request
  Future<Either<Failure, GeneratedImage>> generateImage(
    ImageGenerationRequest request,
  );

  /// Cache an image locally for offline access
  Future<Either<Failure, void>> cacheImage({
    required String imageUrl,
    required String storyId,
    int? pageNumber,
  });

  /// Get cached image path
  Future<Either<Failure, String>> getCachedImagePath({
    required String storyId,
    int? pageNumber,
  });

  /// Clear cached images for a story
  Future<Either<Failure, void>> clearCachedImages(String storyId);
}
