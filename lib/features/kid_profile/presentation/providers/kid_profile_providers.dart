import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../data/datasources/kid_profile_remote_datasource.dart';
import '../../data/repositories/kid_profile_repository_impl.dart';
import '../../domain/entities/kid_profile_entity.dart';
import '../../domain/repositories/kid_profile_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

part 'kid_profile_providers.g.dart';

// ==================== DATA SOURCES ====================

/// Provider for KidProfileRemoteDataSource
@riverpod
KidProfileRemoteDataSource kidProfileRemoteDataSource(
    Ref ref) {
  return KidProfileRemoteDataSource(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
}

// ==================== REPOSITORIES ====================

/// Provider for KidProfileRepository
@riverpod
KidProfileRepository kidProfileRepository(Ref ref) {
  final remoteDataSource = ref.watch(kidProfileRemoteDataSourceProvider);
  return KidProfileRepositoryImpl(remoteDataSource: remoteDataSource);
}

// ==================== KID PROFILES LIST ====================

/// Stream provider for kid profiles list
@riverpod
Stream<List<KidProfileEntity>> kidProfiles(Ref ref) async* {
  final user = await ref.watch(authStateChangesProvider.future);

  if (user == null) {
    yield [];
    return;
  }

  final repository = ref.watch(kidProfileRepositoryProvider);
  yield* repository.watchKidProfiles(userId: user.id);
}

/// Provider for single kid profile
@riverpod
Future<KidProfileEntity?> kidProfile(Ref ref, String profileId) async {
  final repository = ref.watch(kidProfileRepositoryProvider);
  final result = await repository.getKidProfile(profileId: profileId);

  return result.fold(
    (failure) => null,
    (profile) => profile,
  );
}

/// Provider for the current/selected kid profile
/// Returns the first profile from the list for now
@riverpod
Stream<KidProfileEntity?> currentKidProfile(Ref ref) async* {
  final user = await ref.watch(authStateChangesProvider.future);

  if (user == null) {
    yield null;
    return;
  }

  final repository = ref.watch(kidProfileRepositoryProvider);
  await for (final profiles in repository.watchKidProfiles(userId: user.id)) {
    yield profiles.isEmpty ? null : profiles.first;
  }
}

// ==================== KID PROFILE CONTROLLER ====================

/// Kid profile controller state
class KidProfileState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const KidProfileState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  KidProfileState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return KidProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Kid profile controller for CRUD operations
@riverpod
class KidProfileController extends _$KidProfileController {
  @override
  KidProfileState build() {
    return const KidProfileState();
  }

  /// Create a new kid profile
  Future<bool> createKidProfile({
    required String name,
    required int age,
    List<String>? interests,
    File? photo,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final user = await ref.read(authStateChangesProvider.future);
    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'You must be logged in to create a profile',
      );
      return false;
    }

    final repository = ref.read(kidProfileRepositoryProvider);
    final result = await repository.createKidProfile(
      userId: user.id,
      name: name,
      age: age,
      interests: interests,
      photo: photo,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (profile) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Profile created successfully!',
        );
        // Invalidate the kid profiles list to refresh
        ref.invalidate(kidProfilesProvider);
        return true;
      },
    );
  }

  /// Update an existing kid profile
  Future<bool> updateKidProfile({
    required String profileId,
    String? name,
    int? age,
    List<String>? interests,
    File? photo,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final repository = ref.read(kidProfileRepositoryProvider);
    final result = await repository.updateKidProfile(
      profileId: profileId,
      name: name,
      age: age,
      interests: interests,
      photo: photo,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (profile) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Profile updated successfully!',
        );
        // Invalidate the kid profiles list to refresh
        ref.invalidate(kidProfilesProvider);
        return true;
      },
    );
  }

  /// Delete a kid profile
  Future<bool> deleteKidProfile({
    required String profileId,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final repository = ref.read(kidProfileRepositoryProvider);
    final result = await repository.deleteKidProfile(profileId: profileId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Profile deleted successfully!',
        );
        // Invalidate the kid profiles list to refresh
        ref.invalidate(kidProfilesProvider);
        return true;
      },
    );
  }

  /// Clear error/success messages
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
