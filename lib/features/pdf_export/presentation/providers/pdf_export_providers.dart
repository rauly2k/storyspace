import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/pdf_export_repository_impl.dart';
import '../../../story/domain/entities/story_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

part 'pdf_export_providers.g.dart';

/// Provider for PDF export repository
@riverpod
PdfExportRepositoryImpl pdfExportRepository(Ref ref) {
  return PdfExportRepositoryImpl();
}

/// Provider for exporting a story to PDF
@riverpod
class PdfExportNotifier extends _$PdfExportNotifier {
  @override
  FutureOr<String?> build() => null;

  /// Export story to PDF and return file path
  Future<Either<Failure, String>> exportStory(StoryEntity story) async {
    state = const AsyncLoading();

    final repository = ref.read(pdfExportRepositoryProvider);
    final result = await repository.exportStoryToPdf(story);

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (filePath) => state = AsyncData(filePath),
    );

    return result;
  }

  /// Export story to PDF and share it
  Future<Either<Failure, void>> exportAndShare(StoryEntity story) async {
    state = const AsyncLoading();

    final repository = ref.read(pdfExportRepositoryProvider);
    final result = await repository.exportAndSharePdf(story);

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData(null),
    );

    return result;
  }
}
