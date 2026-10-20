import 'package:bcall/model/book_model.dart';
import 'package:bcall/pages/pdf_view_page.dart';
import 'package:bcall/ui/book_grid_item.dart';
import 'package:bcall/widgets/book_download_button.dart';
import 'package:flutter/material.dart';

class BookGrid extends StatelessWidget {
  final List<Book> books;
  final Map<String, double> downloadProgress;
  final ValueChanged<Book> onDownload;

  const BookGrid({
    super.key,
    required this.books,
    required this.downloadProgress,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isDownloaded = book.localPath != null;
        final progress = downloadProgress[book.title];

        return Stack(
          children: [
            BookGridItem(
              name: book.title,
              author: book.author,
              cover: book.coverUrl,
              url: book.pdfUrl,
              category: book.category,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfViewPage(
                      pdfUrl: book.localPath ?? book.pdfUrl,
                      bookTitle: book.title,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: BookDownloadButton(
                isDownloaded: isDownloaded,
                progress: progress,
                onTap: progress != null || isDownloaded
                    ? null
                    : () => onDownload(book),
              ),
            ),
          ],
        );
      },
    );
  }
}
