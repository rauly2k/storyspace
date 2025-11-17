import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/generated_image.dart';

part 'generated_image_model.freezed.dart';
part 'generated_image_model.g.dart';

/// Data model for GeneratedImage
@freezed
abstract class GeneratedImageModel with _$GeneratedImageModel {
  const GeneratedImageModel._();

  const factory GeneratedImageModel({
    required String id,
    required String url,
    required String prompt,
    String? localPath,
    required DateTime generatedAt,
    @Default(false) bool isCached,
  }) = _GeneratedImageModel;

  /// Convert to domain entity
  GeneratedImage toEntity() {
    return GeneratedImage(
      id: id,
      url: url,
      prompt: prompt,
      localPath: localPath,
      generatedAt: generatedAt,
      isCached: isCached,
    );
  }

  /// Create from domain entity
  factory GeneratedImageModel.fromEntity(GeneratedImage entity) {
    return GeneratedImageModel(
      id: entity.id,
      url: entity.url,
      prompt: entity.prompt,
      localPath: entity.localPath,
      generatedAt: entity.generatedAt,
      isCached: entity.isCached,
    );
  }

  /// Create from JSON
  factory GeneratedImageModel.fromJson(Map<String, dynamic> json) =>
      _$GeneratedImageModelFromJson(json);
}
