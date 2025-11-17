import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated_image.freezed.dart';

/// Represents a generated image result
@freezed
abstract class GeneratedImage with _$GeneratedImage {
  const factory GeneratedImage({
    required String id,
    required String url,
    required String prompt,
    String? localPath,
    required DateTime generatedAt,
    @Default(false) bool isCached,
  }) = _GeneratedImage;
}
