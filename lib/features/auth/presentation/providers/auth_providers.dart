import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

// ==================== DATA SOURCES ====================

/// Provider for AuthRemoteDataSource
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSource(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    googleSignIn: GoogleSignIn(),
  );
}

// ==================== REPOSITORIES ====================

/// Provider for AuthRepository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
}

// ==================== AUTH STATE ====================

/// Stream provider for auth state changes
/// Returns null when logged out, UserEntity when logged in
@riverpod
Stream<UserEntity?> authStateChanges(AuthStateChangesRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
}

/// Provider for current user (sync)
@riverpod
Future<UserEntity?> currentUser(CurrentUserRef ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getCurrentUser();
  return result.fold(
    (failure) => null,
    (user) => user,
  );
}

// ==================== AUTH CONTROLLER ====================

/// Auth controller state
class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth controller for handling auth operations
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithEmail(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  /// Sign up with email and password
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithGoogle();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  /// Sign out
  Future<bool> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signOut();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.sendPasswordResetEmail(email: email);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.errorMessage,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, error: null);
        return true;
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
