import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/image_cache_local_datasource.dart';
import '../../data/datasources/image_generation_remote_datasource.dart';
import '../../data/repositories/image_generation_repository_impl.dart';
import '../../domain/repositories/image_generation_repository.dart';

part 'image_generation_providers.g.dart';

/// Provider for remote datasource
@riverpod
ImageGenerationRemoteDataSource imageGenerationRemoteDataSource(
  Ref ref,
) {
  return ImageGenerationRemoteDataSourceImpl();
}

/// Provider for local cache datasource
@riverpod
ImageCacheLocalDataSource imageCacheLocalDataSource(
  Ref ref,
) {
  return ImageCacheLocalDataSourceImpl();
}

/// Provider for image generation repository
@riverpod
ImageGenerationRepository imageGenerationRepository(
  Ref ref,
) {
  return ImageGenerationRepositoryImpl(
    remoteDataSource: ref.watch(imageGenerationRemoteDataSourceProvider),
    localDataSource: ref.watch(imageCacheLocalDataSourceProvider),
  );
}
