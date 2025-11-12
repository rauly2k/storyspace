import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Offline Stories table
class OfflineStories extends Table {
  TextColumn get id => text()();
  TextColumn get kidProfileId => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get genre => text()();
  TextColumn get coverImageUrl => text().nullable()();
  BoolColumn get isAIGenerated => boolean().withDefault(const Constant(false))();
  TextColumn get aiPrompt => text().nullable()();
  IntColumn get readCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  DateTimeColumn get downloadedAt => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get downloadSize => integer().withDefault(const Constant(0))(); // Size in bytes

  @override
  Set<Column> get primaryKey => {id};
}

/// Downloaded images cache table
class DownloadedImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get storyId => text()();
  TextColumn get remoteUrl => text()();
  TextColumn get localPath => text()();
  IntColumn get fileSize => integer()();
  DateTimeColumn get downloadedAt => dateTime()();

  // Foreign key to stories
  @override
  List<Set<Column>> get uniqueKeys => [
    {storyId, remoteUrl}
  ];
}

/// Download progress tracking table
class DownloadProgress extends Table {
  TextColumn get storyId => text()();
  RealColumn get progress => real()(); // 0.0 to 1.0
  TextColumn get status => text()(); // pending, downloading, completed, failed
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {storyId};
}

/// Main database class
@DriftDatabase(tables: [OfflineStories, DownloadedImages, DownloadProgress])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ==================== OFFLINE STORIES QUERIES ====================

  /// Get all downloaded stories
  Future<List<OfflineStory>> getAllDownloadedStories() async {
    return await select(offlineStories).get();
  }

  /// Get downloaded stories for a user
  Future<List<OfflineStory>> getDownloadedStoriesForUser(String userId) async {
    return await (select(offlineStories)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.downloadedAt),
          ]))
        .get();
  }

  /// Get a specific story by ID
  Future<OfflineStory?> getStoryById(String storyId) async {
    return await (select(offlineStories)
          ..where((tbl) => tbl.id.equals(storyId)))
        .getSingleOrNull();
  }

  /// Check if a story is downloaded
  Future<bool> isStoryDownloaded(String storyId) async {
    final story = await getStoryById(storyId);
    return story != null;
  }

  /// Insert or update a story
  Future<int> upsertStory(OfflineStoriesCompanion story) async {
    return await into(offlineStories).insertOnConflictUpdate(story);
  }

  /// Delete a story
  Future<int> deleteStory(String storyId) async {
    // Also delete associated images
    await (delete(downloadedImages)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .go();

    // Delete progress tracking
    await (delete(downloadProgress)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .go();

    return await (delete(offlineStories)
          ..where((tbl) => tbl.id.equals(storyId)))
        .go();
  }

  /// Get download count for a user
  Future<int> getDownloadCount(String userId) async {
    final query = selectOnly(offlineStories)
      ..addColumns([offlineStories.id.count()])
      ..where(offlineStories.userId.equals(userId));

    final result = await query.getSingle();
    return result.read(offlineStories.id.count()) ?? 0;
  }

  /// Get total storage used by user's downloads (in bytes)
  Future<int> getTotalStorageUsed(String userId) async {
    final query = selectOnly(offlineStories)
      ..addColumns([offlineStories.downloadSize.sum()])
      ..where(offlineStories.userId.equals(userId));

    final result = await query.getSingle();
    return result.read(offlineStories.downloadSize.sum()) ?? 0;
  }

  /// Toggle favorite status
  Future<int> toggleFavorite(String storyId, bool isFavorite) async {
    return await (update(offlineStories)
          ..where((tbl) => tbl.id.equals(storyId)))
        .write(OfflineStoriesCompanion(isFavorite: Value(isFavorite)));
  }

  /// Update read count
  Future<int> incrementReadCount(String storyId) async {
    final story = await getStoryById(storyId);
    if (story == null) return 0;

    return await (update(offlineStories)
          ..where((tbl) => tbl.id.equals(storyId)))
        .write(OfflineStoriesCompanion(
      readCount: Value(story.readCount + 1),
      lastReadAt: Value(DateTime.now()),
    ));
  }

  /// Get favorite stories
  Future<List<OfflineStory>> getFavoriteStories(String userId) async {
    return await (select(offlineStories)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.isFavorite.equals(true))
          ..orderBy([
            (t) => OrderingTerm.desc(t.downloadedAt),
          ]))
        .get();
  }

  // ==================== DOWNLOADED IMAGES QUERIES ====================

  /// Insert a downloaded image
  Future<int> insertDownloadedImage(DownloadedImagesCompanion image) async {
    return await into(downloadedImages).insertOnConflictUpdate(image);
  }

  /// Get downloaded images for a story
  Future<List<DownloadedImage>> getImagesForStory(String storyId) async {
    return await (select(downloadedImages)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .get();
  }

  /// Get local path for a remote URL
  Future<String?> getLocalPathForUrl(String storyId, String remoteUrl) async {
    final image = await (select(downloadedImages)
          ..where((tbl) =>
              tbl.storyId.equals(storyId) & tbl.remoteUrl.equals(remoteUrl)))
        .getSingleOrNull();
    return image?.localPath;
  }

  /// Delete images for a story
  Future<int> deleteImagesForStory(String storyId) async {
    return await (delete(downloadedImages)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .go();
  }

  // ==================== DOWNLOAD PROGRESS QUERIES ====================

  /// Insert or update download progress
  Future<int> upsertDownloadProgress(DownloadProgressCompanion progress) async {
    return await into(downloadProgress).insertOnConflictUpdate(progress);
  }

  /// Get download progress for a story
  Future<DownloadProgressData?> getDownloadProgress(String storyId) async {
    return await (select(downloadProgress)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .getSingleOrNull();
  }

  /// Watch download progress (stream)
  Stream<DownloadProgressData?> watchDownloadProgress(String storyId) {
    return (select(downloadProgress)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .watchSingleOrNull();
  }

  /// Delete download progress
  Future<int> deleteDownloadProgress(String storyId) async {
    return await (delete(downloadProgress)
          ..where((tbl) => tbl.storyId.equals(storyId)))
        .go();
  }

  /// Get all active downloads
  Future<List<DownloadProgressData>> getActiveDownloads() async {
    return await (select(downloadProgress)
          ..where((tbl) => tbl.status.equals('downloading'))
          ..orderBy([
            (t) => OrderingTerm.desc(t.startedAt),
          ]))
        .get();
  }

  /// Clear completed or failed downloads
  Future<int> clearCompletedDownloads() async {
    return await (delete(downloadProgress)
          ..where((tbl) =>
              tbl.status.equals('completed') | tbl.status.equals('failed')))
        .go();
  }

  // ==================== CLEANUP OPERATIONS ====================

  /// Delete all data for a user (when user logs out)
  Future<void> deleteAllUserData(String userId) async {
    await (delete(offlineStories)..where((tbl) => tbl.userId.equals(userId)))
        .go();
    // Note: Images and progress will be cleaned up via foreign key cascade
  }

  /// Clear all offline data
  Future<void> clearAllData() async {
    await delete(offlineStories).go();
    await delete(downloadedImages).go();
    await delete(downloadProgress).go();
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'storyspace.db'));
    return NativeDatabase(file);
  });
}
