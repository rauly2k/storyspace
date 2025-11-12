import 'package:freezed_annotation/freezed_annotation.dart';

part 'downloaded_story_info.freezed.dart';

/// Represents metadata about a downloaded story
@freezed
abstract class DownloadedStoryInfo with _$DownloadedStoryInfo {
  const DownloadedStoryInfo._();

  const factory DownloadedStoryInfo({
    required String storyId,
    required DateTime downloadedAt,
    required int downloadSize, // Size in bytes
    @Default(false) bool hasImages,
    @Default(0) int imageCount,
  }) = _DownloadedStoryInfo;

  /// Get formatted size
  String get formattedSize {
    if (downloadSize < 1024) {
      return '$downloadSize B';
    } else if (downloadSize < 1024 * 1024) {
      return '${(downloadSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(downloadSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Get time since download
  String get downloadedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(downloadedAt);

    if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
