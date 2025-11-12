import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../models/story_model.dart';

/// Remote data source for story operations using Firestore.
class StoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  StoryRemoteDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get stories collection reference
  CollectionReference<Map<String, dynamic>> get _storiesCollection =>
      _firestore.collection(FirebaseConstants.storiesCollection);

  /// Watch all stories for a specific kid profile (real-time updates)
  Stream<List<StoryModel>> watchStoriesForKid({
    required String kidProfileId,
  }) {
    return _storiesCollection
        .where(FirebaseConstants.storyKidProfileIdField, isEqualTo: kidProfileId)
        .orderBy(FirebaseConstants.storyCreatedAtField, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StoryModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get all stories for a specific kid profile
  Future<List<StoryModel>> getStoriesForKid({
    required String kidProfileId,
  }) async {
    final snapshot = await _storiesCollection
        .where(FirebaseConstants.storyKidProfileIdField, isEqualTo: kidProfileId)
        .orderBy(FirebaseConstants.storyCreatedAtField, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => StoryModel.fromFirestore(doc))
        .toList();
  }

  /// Get a single story by ID
  Future<StoryModel> getStoryById({
    required String storyId,
  }) async {
    final doc = await _storiesCollection.doc(storyId).get();

    if (!doc.exists) {
      throw Exception('Story not found');
    }

    return StoryModel.fromFirestore(doc);
  }

  /// Create a new story
  Future<StoryModel> createStory({
    required String kidProfileId,
    required String userId,
    required String title,
    required String content,
    required String genre,
    String? coverImageUrl,
    bool isAIGenerated = false,
    String? aiPrompt,
  }) async {
    final docRef = _storiesCollection.doc();
    final now = DateTime.now();

    final story = StoryModel(
      id: docRef.id,
      kidProfileId: kidProfileId,
      userId: userId,
      title: title,
      content: content,
      genre: genre,
      coverImageUrl: coverImageUrl,
      isAIGenerated: isAIGenerated,
      aiPrompt: aiPrompt,
      readCount: 0,
      createdAt: now,
    );

    await docRef.set(story.toFirestore());

    return story;
  }

  /// Update a story
  Future<StoryModel> updateStory({
    required String storyId,
    String? title,
    String? content,
    String? genre,
    String? coverImageUrl,
  }) async {
    final updates = <String, dynamic>{};

    if (title != null) {
      updates[FirebaseConstants.storyTitleField] = title;
    }
    if (content != null) {
      updates[FirebaseConstants.storyContentField] = content;
    }
    if (genre != null) {
      updates[FirebaseConstants.storyGenreField] = genre;
    }
    if (coverImageUrl != null) {
      updates[FirebaseConstants.storyCoverImageUrlField] = coverImageUrl;
    }

    if (updates.isEmpty) {
      throw Exception('No fields to update');
    }

    await _storiesCollection.doc(storyId).update(updates);

    return getStoryById(storyId: storyId);
  }

  /// Increment read count and update last read time
  Future<void> markAsRead({
    required String storyId,
  }) async {
    await _storiesCollection.doc(storyId).update({
      FirebaseConstants.storyReadCountField: FieldValue.increment(1),
      FirebaseConstants.storyLastReadAtField: Timestamp.now(),
    });
  }

  /// Delete a story
  Future<void> deleteStory({
    required String storyId,
  }) async {
    await _storiesCollection.doc(storyId).delete();
  }

  /// Get total AI-generated story count for a user
  Future<int> getAIStoryCountForUser({
    required String userId,
  }) async {
    final snapshot = await _storiesCollection
        .where(FirebaseConstants.storyUserIdField, isEqualTo: userId)
        .where(FirebaseConstants.storyIsAIGeneratedField, isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }

  /// Get all stories for a user (across all kid profiles)
  Future<List<StoryModel>> getStoriesForUser({
    required String userId,
  }) async {
    final snapshot = await _storiesCollection
        .where(FirebaseConstants.storyUserIdField, isEqualTo: userId)
        .orderBy(FirebaseConstants.storyCreatedAtField, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => StoryModel.fromFirestore(doc))
        .toList();
  }
}
