import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/kid_profile_entity.dart';
import '../../domain/repositories/kid_profile_repository.dart';
import '../datasources/kid_profile_remote_datasource.dart';

/// Implementation of KidProfileRepository using Firebase
class KidProfileRepositoryImpl implements KidProfileRepository {
  final KidProfileRemoteDataSource _remoteDataSource;

  KidProfileRepositoryImpl({
    required KidProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<KidProfileEntity>>> getKidProfiles({
    required String userId,
  }) async {
    try {
      final models = await _remoteDataSource.getKidProfiles(userId: userId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on FirebaseException catch (e) {
      return Left(Failure.firestore(message: e.message ?? 'Failed to get kid profiles'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, KidProfileEntity>> getKidProfile({
    required String profileId,
  }) async {
    try {
      final model = await _remoteDataSource.getKidProfile(profileId: profileId);
      return Right(model.toEntity());
    } on FirebaseException catch (e) {
      return Left(Failure.firestore(message: e.message ?? 'Failed to get kid profile'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, KidProfileEntity>> createKidProfile({
    required String userId,
    required String name,
    required int age,
    List<String>? interests,
    File? photo,
  }) async {
    try {
      final model = await _remoteDataSource.createKidProfile(
        userId: userId,
        name: name,
        age: age,
        interests: interests,
        photo: photo,
      );
      return Right(model.toEntity());
    } on FirebaseException catch (e) {
      if (e.code == 'storage/unauthorized') {
        return Left(Failure.storage(message: 'Unauthorized to upload photo'));
      }
      return Left(Failure.firestore(message: e.message ?? 'Failed to create kid profile'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, KidProfileEntity>> updateKidProfile({
    required String profileId,
    String? name,
    int? age,
    List<String>? interests,
    File? photo,
  }) async {
    try {
      final model = await _remoteDataSource.updateKidProfile(
        profileId: profileId,
        name: name,
        age: age,
        interests: interests,
        photo: photo,
      );
      return Right(model.toEntity());
    } on FirebaseException catch (e) {
      if (e.code == 'storage/unauthorized') {
        return Left(Failure.storage(message: 'Unauthorized to upload photo'));
      }
      return Left(Failure.firestore(message: e.message ?? 'Failed to update kid profile'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteKidProfile({
    required String profileId,
  }) async {
    try {
      await _remoteDataSource.deleteKidProfile(profileId: profileId);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure.firestore(message: e.message ?? 'Failed to delete kid profile'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto({
    required String userId,
    required String profileId,
    required File photo,
  }) async {
    try {
      // This is handled in createKidProfile and updateKidProfile
      // But we can provide a standalone method if needed
      return Left(Failure.unknown(message: 'Use createKidProfile or updateKidProfile'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<List<KidProfileEntity>> watchKidProfiles({
    required String userId,
  }) {
    return _remoteDataSource.watchKidProfiles(userId: userId).map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }
}
