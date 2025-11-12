import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/constants/firebase_constants.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model for data layer with JSON serialization
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(false) bool isPremium,
    @Default('free') String subscriptionTier,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJsonNullable, toJson: _timestampToJsonNullable)
    DateTime? updatedAt,
  }) = _UserModel;

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      isPremium: isPremium,
      subscriptionTier: subscriptionTier,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      isPremium: entity.isPremium,
      subscriptionTier: entity.subscriptionTier,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// From Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      FirebaseConstants.userId: doc.id,
      ...data,
    });
  }

  /// To Firestore document
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove(FirebaseConstants.userId); // Remove ID from document data
    return json;
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
