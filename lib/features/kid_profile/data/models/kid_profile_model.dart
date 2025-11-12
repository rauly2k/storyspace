import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/kid_profile_entity.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/constants/app_constants.dart';

part 'kid_profile_model.freezed.dart';
part 'kid_profile_model.g.dart';

/// Kid profile model for data layer with JSON serialization
@freezed
abstract class KidProfileModel with _$KidProfileModel {
  const KidProfileModel._();

  const factory KidProfileModel({
    required String id,
    required String userId,
    required String name,
    required int age,
    required String ageBucket,
    String? photoUrl,
    @Default([]) List<String> interests,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJsonNullable, toJson: _timestampToJsonNullable)
    DateTime? updatedAt,
  }) = _KidProfileModel;

  /// Convert to domain entity
  KidProfileEntity toEntity() {
    return KidProfileEntity(
      id: id,
      userId: userId,
      name: name,
      age: age,
      ageBucket: ageBucket,
      photoUrl: photoUrl,
      interests: interests,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from domain entity
  factory KidProfileModel.fromEntity(KidProfileEntity entity) {
    return KidProfileModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      age: entity.age,
      ageBucket: entity.ageBucket,
      photoUrl: entity.photoUrl,
      interests: entity.interests,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// From JSON
  factory KidProfileModel.fromJson(Map<String, dynamic> json) =>
      _$KidProfileModelFromJson(json);

  /// From Firestore document
  factory KidProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KidProfileModel.fromJson({
      FirebaseConstants.profileId: doc.id,
      ...data,
    });
  }

  /// To Firestore document
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove(FirebaseConstants.profileId); // Remove ID from document data
    return json;
  }

  /// Calculate age bucket from age
  static String calculateAgeBucket(int age) {
    return AppConstants.getAgeBucket(age);
  }
}

// Timestamp conversion helpers
DateTime _timestampFromJson(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is String) {
    return DateTime.parse(value);
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return DateTime.now();
}

dynamic _timestampToJson(DateTime dateTime) => Timestamp.fromDate(dateTime);

DateTime? _timestampFromJsonNullable(dynamic value) {
  if (value == null) return null;
  return _timestampFromJson(value);
}

dynamic _timestampToJsonNullable(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
