import 'package:bcall/model/book_model.dart';
import 'package:bcall/services/book_service.dart';
import 'package:bcall/widgets/book_grid.dart';
import 'package:bcall/widgets/explore_status_view.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final Function(Book) onBookDownloaded;

  const ExplorePage({super.key, required this.onBookDownloaded});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final BookService _bookService = BookService();

  List<Book> books = [];
  bool isLoading = true;
  String? error;

  final Map<String, double> downloadProgress = {};

  static const Color primary = Color(0xFFE05688);
  static const Color background = Color(0xFFFFF7FA);
  static const Color textDark = Color(0xFF30212A);
  static const Color muted = Color(0xFF9B8791);
  static const Color borderColor = Color(0xFFF4DCE7);

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  Future<void> getBooks() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await _bookService.fetchBooks();

      if (!mounted) return;

      setState(() {
        books = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'Unable to load books. Check your connection.';
        isLoading = false;
      });
    }
  }

  Future<void> downloadBook(Book book) async {
    if (downloadProgress.containsKey(book.title)) return;

    setState(() {
      downloadProgress[book.title] = 0;
    });

    try {
      final path = await _bookService.downloadBook(
        book,
        onProgress: (progress) {
          if (!mounted) return;

          setState(() {
            downloadProgress[book.title] = progress;
          });
        },
      );

      if (!mounted) return;

      setState(() {
        book.localPath = path;
        downloadProgress.remove(book.title);
      });

      widget.onBookDownloaded(book);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${book.title} downloaded successfully!'),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        downloadProgress.remove(book.title);
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Download failed. Please try again.'),
            backgroundColor: const Color(0xFFB84252),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const Text(
                'Discover Books',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                  letterSpacing: -0.7,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: isLoading ? null : getBooks,
            borderRadius: BorderRadius.circular(13),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: isLoading ? muted : primary,
                size: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              Expanded(
                child: isLoading || error != null || books.isEmpty
                    ? ExploreStatusView(
                        isLoading: isLoading,
                        error: error,
                        onRetry: getBooks,
                      )
                    : BookGrid(
                        books: books,
                        downloadProgress: downloadProgress,
                        onDownload: downloadBook,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
