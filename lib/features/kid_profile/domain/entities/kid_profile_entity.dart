import 'package:freezed_annotation/freezed_annotation.dart';

part 'kid_profile_entity.freezed.dart';

/// Kid profile entity representing a child account
@freezed
abstract class KidProfileEntity with _$KidProfileEntity {
  const KidProfileEntity._();

  const factory KidProfileEntity({
    required String id,
    required String userId,
    required String name,
    required int age,
    required String ageBucket,
    String? photoUrl,
    @Default([]) List<String> interests,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _KidProfileEntity;

  /// Get display age string
  String get ageDisplay => '$age years old';

  /// Get age bucket display name
  String get ageBucketDisplay {
    switch (ageBucket.toLowerCase()) {
      case 'sprout':
        return 'Sprout (3-5)';
      case 'explorer':
        return 'Explorer (6-8)';
      case 'visionary':
        return 'Visionary (9-12)';
      default:
        return ageBucket;
    }
  }

  /// Get age bucket name in Romanian
  String get ageBucketNameRo {
    switch (ageBucket.toLowerCase()) {
      case 'sprout':
        return 'Boboc (3-5)';
      case 'explorer':
        return 'Explorator (6-8)';
      case 'visionary':
        return 'Vizionar (9-12)';
      default:
        return ageBucket;
    }
  }

  /// Get first initial for avatar
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
