import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// User entity representing a parent account
@freezed
abstract class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(false) bool isPremium,
    @Default('free') String subscriptionTier,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserEntity;

  /// Check if user has premium access
  bool get hasPremiumAccess => isPremium || subscriptionTier != 'free';

  /// Check if user has premium+ access
  bool get hasPremiumPlusAccess => subscriptionTier == 'premium+';

  /// Get display name or fallback to email
  String get displayNameOrEmail => displayName ?? email.split('@').first;
}
