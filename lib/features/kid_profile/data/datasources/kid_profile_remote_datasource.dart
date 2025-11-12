import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/kid_profile_model.dart';
import '../../../../core/constants/firebase_constants.dart';

/// Remote data source for kid profiles using Firebase
class KidProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  KidProfileRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  /// Get all kid profiles for a user
  Future<List<KidProfileModel>> getKidProfiles({
    required String userId,
  }) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.kidProfilesCollection)
        .where(FirebaseConstants.profileUserId, isEqualTo: userId)
        .orderBy(FirebaseConstants.profileCreatedAt, descending: false)
        .get();

    return snapshot.docs.map((doc) => KidProfileModel.fromFirestore(doc)).toList();
  }

  /// Get a single kid profile by ID
  Future<KidProfileModel> getKidProfile({
    required String profileId,
  }) async {
    final doc = await _firestore
        .collection(FirebaseConstants.kidProfilesCollection)
        .doc(profileId)
        .get();

    if (!doc.exists) {
      throw Exception('Kid profile not found');
    }

    return KidProfileModel.fromFirestore(doc);
  }

  /// Create a new kid profile
  Future<KidProfileModel> createKidProfile({
    required String userId,
    required String name,
    required int age,
    List<String>? interests,
    File? photo,
  }) async {
    final ageBucket = KidProfileModel.calculateAgeBucket(age);

    // Create profile document
    final docRef = _firestore.collection(FirebaseConstants.kidProfilesCollection).doc();

    String? photoUrl;
    if (photo != null) {
      photoUrl = await _uploadPhoto(
        userId: userId,
        profileId: docRef.id,
        photo: photo,
      );
    }

    final profile = KidProfileModel(
      id: docRef.id,
      userId: userId,
      name: name,
      age: age,
      ageBucket: ageBucket,
      photoUrl: photoUrl,
      interests: interests ?? [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set(profile.toFirestore());
    return profile;
  }

  /// Update an existing kid profile
  Future<KidProfileModel> updateKidProfile({
    required String profileId,
    String? name,
    int? age,
    List<String>? interests,
    File? photo,
  }) async {
    final doc = _firestore
        .collection(FirebaseConstants.kidProfilesCollection)
        .doc(profileId);

    // Get current profile
    final currentDoc = await doc.get();
    if (!currentDoc.exists) {
      throw Exception('Kid profile not found');
    }

    final currentProfile = KidProfileModel.fromFirestore(currentDoc);

    final updates = <String, dynamic>{
      FirebaseConstants.profileUpdatedAt: FieldValue.serverTimestamp(),
    };

    if (name != null) {
      updates[FirebaseConstants.profileName] = name;
    }

    if (age != null) {
      updates[FirebaseConstants.profileAge] = age;
      updates[FirebaseConstants.profileAgeBucket] = KidProfileModel.calculateAgeBucket(age);
    }

    if (interests != null) {
      updates[FirebaseConstants.profileInterests] = interests;
    }

    if (photo != null) {
      final photoUrl = await _uploadPhoto(
        userId: currentProfile.userId,
        profileId: profileId,
        photo: photo,
      );
      updates[FirebaseConstants.profilePhotoUrl] = photoUrl;
    }

    await doc.update(updates);

    // Fetch updated profile
    final updatedDoc = await doc.get();
    return KidProfileModel.fromFirestore(updatedDoc);
  }

  /// Delete a kid profile
  Future<void> deleteKidProfile({
    required String profileId,
  }) async {
    // Delete profile photo if exists
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.kidProfilesCollection)
          .doc(profileId)
          .get();

      if (doc.exists) {
        final profile = KidProfileModel.fromFirestore(doc);
        if (profile.photoUrl != null) {
          await _deletePhoto(
            userId: profile.userId,
            profileId: profileId,
          );
        }
      }
    } catch (e) {
      // Photo deletion failed, but continue with profile deletion
    }

    // Delete profile document
    await _firestore
        .collection(FirebaseConstants.kidProfilesCollection)
        .doc(profileId)
        .delete();
  }

  /// Watch kid profiles stream
  Stream<List<KidProfileModel>> watchKidProfiles({
    required String userId,
  }) {
    return _firestore
        .collection(FirebaseConstants.kidProfilesCollection)
        .where(FirebaseConstants.profileUserId, isEqualTo: userId)
        .orderBy(FirebaseConstants.profileCreatedAt, descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => KidProfileModel.fromFirestore(doc)).toList();
    });
  }

  // ==================== PRIVATE HELPERS ====================

  /// Upload profile photo to Firebase Storage
  Future<String> _uploadPhoto({
    required String userId,
    required String profileId,
    required File photo,
  }) async {
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = FirebaseConstants.getKidProfilePhotoPath(userId, profileId, fileName);

    final ref = _storage.ref().child(path);
    await ref.putFile(photo);

    return await ref.getDownloadURL();
  }

  /// Delete profile photo from Firebase Storage
  Future<void> _deletePhoto({
    required String userId,
    required String profileId,
  }) async {
    final path = '${FirebaseConstants.kidProfilesPath}/$userId/$profileId/';
    final ref = _storage.ref().child(path);

    try {
      final listResult = await ref.listAll();
      for (final item in listResult.items) {
        await item.delete();
      }
    } catch (e) {
      // Ignore errors if photos don't exist
    }
  }
}
