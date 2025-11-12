import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/kid_profile_entity.dart';

/// Kid profile repository interface
/// Defines all kid profile-related operations
abstract class KidProfileRepository {
  /// Get all kid profiles for a user
  Future<Either<Failure, List<KidProfileEntity>>> getKidProfiles({
    required String userId,
  });

  /// Get a single kid profile by ID
  Future<Either<Failure, KidProfileEntity>> getKidProfile({
    required String profileId,
  });

  /// Create a new kid profile
  Future<Either<Failure, KidProfileEntity>> createKidProfile({
    required String userId,
    required String name,
    required int age,
    List<String>? interests,
    File? photo,
  });

  /// Update an existing kid profile
  Future<Either<Failure, KidProfileEntity>> updateKidProfile({
    required String profileId,
    String? name,
    int? age,
    List<String>? interests,
    File? photo,
  });

  /// Delete a kid profile
  Future<Either<Failure, void>> deleteKidProfile({
    required String profileId,
  });

  /// Upload profile photo
  Future<Either<Failure, String>> uploadProfilePhoto({
    required String userId,
    required String profileId,
    required File photo,
  });

  /// Stream of kid profiles for a user
  Stream<List<KidProfileEntity>> watchKidProfiles({
    required String userId,
  });
}
