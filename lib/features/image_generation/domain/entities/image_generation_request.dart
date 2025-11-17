import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'art_style.dart';

part 'image_generation_request.freezed.dart';

/// Request entity for generating a story image
@freezed
abstract class ImageGenerationRequest with _$ImageGenerationRequest {
  const factory ImageGenerationRequest({
    required String prompt,
    required ArtStyle artStyle,
    required String ageBucket,
    File? referencePhoto,
    @Default(false) bool usePremiumFeatures,
  }) = _ImageGenerationRequest;
}
