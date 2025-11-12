import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../../../../core/constants/firebase_constants.dart';

/// Remote data source for authentication using Firebase
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Get auth state changes as stream
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _getUserModel(firebaseUser.uid);
    });
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return await _getUserModel(firebaseUser.uid);
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Sign in failed');
    }

    return await _getUserModel(user.uid);
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Sign up failed');
    }

    // Update display name if provided
    if (displayName != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }

    // Create user document in Firestore
    final userModel = UserModel(
      id: user.uid,
      email: user.email!,
      displayName: displayName ?? user.displayName,
      photoUrl: user.photoURL,
      isPremium: false,
      subscriptionTier: 'free',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _createUserDocument(userModel);
    return userModel;
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the credential
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Google sign in failed');
    }

    // Check if user document exists, create if not
    final userDoc = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      final userModel = UserModel(
        id: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isPremium: false,
        subscriptionTier: 'free',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _createUserDocument(userModel);
      return userModel;
    }

    return await _getUserModel(user.uid);
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    // Update Firebase Auth profile
    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }
    await user.reload();

    // Update Firestore document
    final updates = <String, dynamic>{
      FirebaseConstants.userUpdatedAt: FieldValue.serverTimestamp(),
    };
    if (displayName != null) {
      updates[FirebaseConstants.userDisplayName] = displayName;
    }
    if (photoUrl != null) {
      updates[FirebaseConstants.userPhotoUrl] = photoUrl;
    }

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .update(updates);

    return await _getUserModel(user.uid);
  }

  /// Delete account
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    // Delete Firestore document
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .delete();

    // Delete Firebase Auth user
    await user.delete();
  }

  // ==================== PRIVATE HELPERS ====================

  /// Get user model from Firestore
  Future<UserModel> _getUserModel(String userId) async {
    final doc = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .get();

    if (!doc.exists) {
      throw Exception('User document not found');
    }

    return UserModel.fromFirestore(doc);
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(UserModel userModel) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userModel.id)
        .set(userModel.toFirestore());
  }
}
