import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Local datasource for caching images
abstract class ImageCacheLocalDataSource {
  Future<String> cacheImage({
    required String imageUrl,
    required String storyId,
    int? pageNumber,
  });

  Future<String?> getCachedImagePath({
    required String storyId,
    int? pageNumber,
  });

  Future<void> clearCachedImages(String storyId);
  Future<void> clearAllCache();
}

class ImageCacheLocalDataSourceImpl implements ImageCacheLocalDataSource {
  final Dio _dio;

  ImageCacheLocalDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<String> cacheImage({
    required String imageUrl,
    required String storyId,
    int? pageNumber,
  }) async {
    try {
      // Get cache directory
      final cacheDir = await _getImageCacheDirectory();

      // Generate filename
      final filename = pageNumber != null
          ? '${storyId}_page_$pageNumber.jpg'
          : '${storyId}_cover.jpg';

      final filePath = path.join(cacheDir.path, filename);

      // Download and save image
      final response = await _dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data);

      return filePath;
    } catch (e) {
      throw Exception('Failed to cache image: $e');
    }
  }

  @override
  Future<String?> getCachedImagePath({
    required String storyId,
    int? pageNumber,
  }) async {
    try {
      final cacheDir = await _getImageCacheDirectory();

      final filename = pageNumber != null
          ? '${storyId}_page_$pageNumber.jpg'
          : '${storyId}_cover.jpg';

      final filePath = path.join(cacheDir.path, filename);
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCachedImages(String storyId) async {
    try {
      final cacheDir = await _getImageCacheDirectory();
      final files = cacheDir.listSync();

      for (final file in files) {
        if (file is File && file.path.contains(storyId)) {
          await file.delete();
        }
      }
    } catch (e) {
      throw Exception('Failed to clear cached images: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final cacheDir = await _getImageCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
      }
    } catch (e) {
      throw Exception('Failed to clear all cache: $e');
    }
  }

  /// Get or create the image cache directory
  Future<Directory> _getImageCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(path.join(appDir.path, 'image_cache'));

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }
}
