import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_progress_entity.freezed.dart';

/// Download status enum
enum DownloadStatus {
  pending,
  downloading,
  completed,
  failed,
}

/// Represents the progress of a story download
@freezed
abstract class DownloadProgressEntity with _$DownloadProgressEntity {
  const DownloadProgressEntity._();

  const factory DownloadProgressEntity({
    required String storyId,
    @Default(0.0) double progress, // 0.0 to 1.0
    @Default(DownloadStatus.pending) DownloadStatus status,
    String? errorMessage,
    required DateTime startedAt,
    required DateTime updatedAt,
  }) = _DownloadProgressEntity;

  /// Get progress percentage
  int get progressPercentage => (progress * 100).round();

  /// Check if download is in progress
  bool get isDownloading => status == DownloadStatus.downloading;

  /// Check if download is completed
  bool get isCompleted => status == DownloadStatus.completed;

  /// Check if download failed
  bool get isFailed => status == DownloadStatus.failed;

  /// Check if download is pending
  bool get isPending => status == DownloadStatus.pending;

  /// Get status display text
  String get statusText {
    switch (status) {
      case DownloadStatus.pending:
        return 'Pending';
      case DownloadStatus.downloading:
        return 'Downloading $progressPercentage%';
      case DownloadStatus.completed:
        return 'Completed';
      case DownloadStatus.failed:
        return 'Failed';
    }
  }
}
