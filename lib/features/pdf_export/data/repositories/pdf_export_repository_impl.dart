import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/error/failures.dart';
import '../../../story/domain/entities/story_entity.dart';
import 'package:fpdart/fpdart.dart';

/// PDF Export Repository Implementation
/// Generates beautiful PDFs from stories
class PdfExportRepositoryImpl {
  /// Export story to PDF
  Future<Either<Failure, String>> exportStoryToPdf(StoryEntity story) async {
    try {
      final pdf = pw.Document();

      // Add cover page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    story.title,
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    'StorySpace',
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Where Stories Come Alive',
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Add story content pages
      final contentLines = _splitContentIntoPages(story.content);

      for (int i = 0; i < contentLines.length; i++) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(40),
                      child: pw.Text(
                        contentLines[i],
                        style: const pw.TextStyle(
                          fontSize: 14,
                          lineSpacing: 1.5,
                        ),
                        textAlign: pw.TextAlign.justify,
                      ),
                    ),
                  ),
                  pw.Divider(),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'StorySpace',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          'Pagina ${i + 2}',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      // Add end page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Sfârșit',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    'Creat cu StorySpace',
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    story.isAIGenerated
                        ? 'Poveste generată de AI'
                        : 'Poveste pre-fabricată',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Save PDF to file
      final output = await getTemporaryDirectory();
      final fileName = '${story.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return Right(file.path);
    } catch (e) {
      return Left(Failure.unknown(message: 'Eroare la generarea PDF: ${e.toString()}'));
    }
  }

  /// Export and share PDF
  Future<Either<Failure, void>> exportAndSharePdf(StoryEntity story) async {
    try {
      final result = await exportStoryToPdf(story);

      return result.fold(
        (failure) => Left(failure),
        (filePath) async {
          try {
            await Share.shareXFiles(
              [XFile(filePath)],
              subject: story.title,
              text: 'Iată povestea "${story.title}" din StorySpace!',
            );
            return const Right(null);
          } catch (e) {
            return Left(Failure.unknown(message: 'Eroare la partajarea PDF: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(Failure.unknown(message: 'Eroare: ${e.toString()}'));
    }
  }

  /// Split content into manageable chunks for pages
  List<String> _splitContentIntoPages(String content) {
    const int charactersPerPage = 2000; // Approximate characters per A4 page
    final List<String> pages = [];

    int start = 0;
    while (start < content.length) {
      int end = start + charactersPerPage;

      // Don't split in the middle of a word
      if (end < content.length) {
        while (end > start && content[end] != ' ' && content[end] != '\n') {
          end--;
        }
      } else {
        end = content.length;
      }

      pages.add(content.substring(start, end).trim());
      start = end;
    }

    return pages;
  }
}
