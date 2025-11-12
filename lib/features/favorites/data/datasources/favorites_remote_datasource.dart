import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../models/favorite_model.dart';

/// Remote data source for favorites operations using Firestore.
class FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get favorites collection reference
  CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      _firestore.collection(FirebaseConstants.favoritesCollection);

  /// Get all favorite story IDs for a user
  Future<List<String>> getFavoriteStoryIds({
    required String userId,
  }) async {
    final snapshot = await _favoritesCollection
        .where(FirebaseConstants.favoriteUserId, isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()[FirebaseConstants.favoriteStoryId] as String)
        .toList();
  }

  /// Watch favorite story IDs (real-time updates)
  Stream<List<String>> watchFavoriteStoryIds({
    required String userId,
  }) {
    return _favoritesCollection
        .where(FirebaseConstants.favoriteUserId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()[FirebaseConstants.favoriteStoryId] as String)
          .toList();
    });
  }

  /// Check if a story is favorited
  Future<bool> isFavorite({
    required String userId,
    required String storyId,
  }) async {
    final snapshot = await _favoritesCollection
        .where(FirebaseConstants.favoriteUserId, isEqualTo: userId)
        .where(FirebaseConstants.favoriteStoryId, isEqualTo: storyId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Add a story to favorites
  Future<FavoriteModel> addFavorite({
    required String userId,
    required String storyId,
  }) async {
    // Check if already favorited
    final alreadyFavorited = await isFavorite(userId: userId, storyId: storyId);
    if (alreadyFavorited) {
      throw Exception('Story is already in favorites');
    }

    final docRef = _favoritesCollection.doc();
    final now = DateTime.now();

    final favorite = FavoriteModel(
      id: docRef.id,
      userId: userId,
      storyId: storyId,
      createdAt: now,
    );

    await docRef.set(favorite.toFirestore());

    return favorite;
  }

  /// Remove a story from favorites
  Future<void> removeFavorite({
    required String userId,
    required String storyId,
  }) async {
    final snapshot = await _favoritesCollection
        .where(FirebaseConstants.favoriteUserId, isEqualTo: userId)
        .where(FirebaseConstants.favoriteStoryId, isEqualTo: storyId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Favorite not found');
    }

    await snapshot.docs.first.reference.delete();
  }
}
