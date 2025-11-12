import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/art_style.dart';
import '../../domain/entities/generated_image.dart';
import '../../domain/entities/image_generation_request.dart';
import '../../domain/repositories/image_generation_repository.dart';
import '../datasources/image_cache_local_datasource.dart';
import '../datasources/image_generation_remote_datasource.dart';

class ImageGenerationRepositoryImpl implements ImageGenerationRepository {
  final ImageGenerationRemoteDataSource _remoteDataSource;
  final ImageCacheLocalDataSource _localDataSource;

  ImageGenerationRepositoryImpl({
    required ImageGenerationRemoteDataSource remoteDataSource,
    required ImageCacheLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, GeneratedImage>> generateCoverImage({
    required String storyTitle,
    required String storyGenre,
    required ArtStyle artStyle,
    required String ageBucket,
    File? referencePhoto,
  }) async {
    try {
      // Build prompt for cover image
      final prompt = _buildCoverImagePrompt(
        storyTitle: storyTitle,
        storyGenre: storyGenre,
        artStyle: artStyle,
        ageBucket: ageBucket,
      );

      final request = ImageGenerationRequest(
        prompt: prompt,
        artStyle: artStyle,
        ageBucket: ageBucket,
        referencePhoto: referencePhoto,
        usePremiumFeatures: referencePhoto != null,
      );

      final model = await _remoteDataSource.generateImage(request);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Failed to generate cover image: $e'));
    }
  }

  @override
  Future<Either<Failure, List<GeneratedImage>>> generateSceneImages({
    required List<String> sceneDescriptions,
    required ArtStyle artStyle,
    required String ageBucket,
    File? referencePhoto,
  }) async {
    try {
      // Build requests for each scene
      final requests = sceneDescriptions.map((description) {
        final prompt = _buildSceneImagePrompt(
          sceneDescription: description,
          artStyle: artStyle,
          ageBucket: ageBucket,
        );

        return ImageGenerationRequest(
          prompt: prompt,
          artStyle: artStyle,
          ageBucket: ageBucket,
          referencePhoto: referencePhoto,
          usePremiumFeatures: referencePhoto != null,
        );
      }).toList();

      final models = await _remoteDataSource.generateMultipleImages(requests);
      final entities = models.map((model) => model.toEntity()).toList();

      return Right(entities);
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Failed to generate scene images: $e'));
    }
  }

  @override
  Future<Either<Failure, GeneratedImage>> generateImage(
    ImageGenerationRequest request,
  ) async {
    try {
      final model = await _remoteDataSource.generateImage(request);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Failed to generate image: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheImage({
    required String imageUrl,
    required String storyId,
    int? pageNumber,
  }) async {
    try {
      await _localDataSource.cacheImage(
        imageUrl: imageUrl,
        storyId: storyId,
        pageNumber: pageNumber,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(message: 'Failed to cache image: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getCachedImagePath({
    required String storyId,
    int? pageNumber,
  }) async {
    try {
      final path = await _localDataSource.getCachedImagePath(
        storyId: storyId,
        pageNumber: pageNumber,
      );

      if (path == null) {
        return Left(CacheFailure(message: 'Image not found in cache'));
      }

      return Right(path);
    } on Exception catch (e) {
      return Left(CacheFailure(message: 'Failed to get cached image: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCachedImages(String storyId) async {
    try {
      await _localDataSource.clearCachedImages(storyId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(message: 'Failed to clear cached images: $e'));
    }
  }

  /// Build prompt for cover image
  String _buildCoverImagePrompt({
    required String storyTitle,
    required String storyGenre,
    required ArtStyle artStyle,
    required String ageBucket,
  }) {
    final stylePrompt = artStyle.toPromptStyle();

    return '''
Create a ${stylePrompt} cover image for a children's story titled "$storyTitle"
in the $storyGenre genre. The image should be appropriate for $ageBucket age group,
featuring the main theme of the story in an engaging and colorful way.
The artwork should be safe for children, vibrant, and eye-catching.
'''.trim();
  }

  /// Build prompt for scene image
  String _buildSceneImagePrompt({
    required String sceneDescription,
    required ArtStyle artStyle,
    required String ageBucket,
  }) {
    final stylePrompt = artStyle.toPromptStyle();

    return '''
Create a ${stylePrompt} illustration showing: $sceneDescription.
The image should be appropriate for $ageBucket age group, child-friendly,
safe for all ages, and visually engaging.
'''.trim();
  }
}
