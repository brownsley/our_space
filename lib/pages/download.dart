import 'dart:io';

import 'package:bcall/pages/pdf_view_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with WidgetsBindingObserver {
  List<File> downloadedFiles = [];
  bool isLoading = true;

  static const Color primary = Color(0xFFE05688);
  static const Color background = Color(0xFFFFF7FA);
  static const Color primaryDark = Color(0xFF8F3159);
  static const Color textDark = Color(0xFF30212A);
  static const Color muted = Color(0xFF9B8791);
  static const Color borderColor = Color(0xFFF4DCE7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDownloadedBooks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDownloadedBooks();
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future<void> _loadDownloadedBooks() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final files = await appDir.list().toList();

      final pdfFiles = files
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.pdf'))
          .toList();

      pdfFiles.sort((a, b) {
        return b.statSync().modified.compareTo(a.statSync().modified);
      });

      if (!mounted) return;

      setState(() {
        downloadedFiles = pdfFiles;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading downloaded books: $e');

      if (mounted) {
        setState(() => isLoading = false);
        _showMessage('Unable to load downloaded books.', isError: true);
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getBookTitle(File file) {
    final name = file.uri.pathSegments.last;
    return name
        .replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '')
        .replaceAll('_', ' ');
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? const Color(0xFFB84252) : primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  Future<void> _confirmAndDelete(File file, String bookTitle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Delete book?',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Delete "$bookTitle" from your library?',
          style: const TextStyle(color: muted, fontSize: 14, height: 1.5),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel', style: TextStyle(color: muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteBook(file);
    }
  }

  Future<void> _deleteBook(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        await _loadDownloadedBooks();
        _showMessage('Book deleted successfully.');
      } else {
        await _loadDownloadedBooks();
        _showMessage('This book is no longer available.', isError: true);
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
      _showMessage('Could not delete this book.', isError: true);
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _iconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR COLLECTION',
                style: TextStyle(
                  color: primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'My Library',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${downloadedFiles.length} books available offline',
                style: const TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
        ),
        _iconButton(
          icon: Icons.refresh_rounded,
          onTap: _loadDownloadedBooks,
          isRefresh: true,
        ),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isRefresh = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: isRefresh ? primary : textDark, size: 21),
        ),
      ),
    );
  }

  Widget _buildLibraryBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE05688), Color(0xFFF09ABB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.13),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your little library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your favorite books, ready anytime.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${downloadedFiles.length} BOOKS DOWNLOADED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 54,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Downloaded Books',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E7F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${downloadedFiles.length} ITEMS',
            style: const TextStyle(
              color: primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF3E8FC), Color(0xFFE8D9F6)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 44,
                  color: primary,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Your library is waiting',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textDark,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Books you download will appear here, ready for offline reading whenever you need them.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 13, height: 1.7),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _loadDownloadedBooks,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Refresh library'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: const BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(File file, int index) {
    final bookTitle = _getBookTitle(file);
    final fileSize = _formatFileSize(file.statSync().size);

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PdfViewPage(pdfUrl: file.path, bookTitle: bookTitle),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                // Pink PDF icon
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE3EE),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: primary,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 11),

                // Book information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF43A879),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Offline ready',
                            style: TextStyle(
                              color: Color(0xFF43A879),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              fileSize,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // Simple delete button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE3EE), Color(0xFFFFF1F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF8D2E1)),
                  ),
                  child: IconButton(
                    onPressed: () => _confirmAndDelete(file, bookTitle),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFE05688),
                      size: 22,
                    ),
                    tooltip: 'Delete book',
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      maximumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildLibraryBanner(),
              const SizedBox(height: 25),
              _buildSectionTitle(),
              const SizedBox(height: 14),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : downloadedFiles.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        color: primary,
                        onRefresh: _loadDownloadedBooks,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: downloadedFiles.length,
                          itemBuilder: (context, index) {
                            return _buildBookCard(
                              downloadedFiles[index],
                              index,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
