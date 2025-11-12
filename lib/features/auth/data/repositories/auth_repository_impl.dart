import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository using Firebase
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((userModel) {
      return userModel?.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      if (e.toString().contains('cancelled')) {
        return Left(Failure.auth(message: 'Google sign in cancelled'));
      }
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final userModel = await _remoteDataSource.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      return Right(userModel.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _getAuthErrorMessage(e)));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ==================== PRIVATE HELPERS ====================

  /// Convert Firebase auth errors to user-friendly messages
  String _getAuthErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please sign in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address.';
      case 'invalid-credential':
        return 'The credential is malformed or has expired.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
