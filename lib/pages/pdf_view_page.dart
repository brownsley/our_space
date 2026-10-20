import 'dart:io';

import 'package:bcall/model/pdf_reader_models.dart';
import 'package:bcall/widgets/pdf_reader_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  const PdfViewPage({super.key, required this.pdfUrl, required this.bookTitle});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  static const Color primary = Color(0xFFE05688);
  // static const Color background = Color(0xFFFFF7FA);
  // static const Color textDark = Color(0xFF30212A);
  // static const Color muted = Color(0xFF9B8791);
  static const Color borderColor = Color(0xFFF4DCE7);

  late final PdfViewerController _pdfController;

  PdfReadingMode _readingMode = PdfReadingMode.light;

  int _currentPage = 1;
  int _totalPages = 0;
  int _reloadKey = 0;

  bool _isLoaded = false;
  bool _hasError = false;
  bool _isFullscreen = false;
  bool _restoredLastPage = false;

  final Set<int> _bookmarks = <int>{};

  Color get _background => PdfReaderStyle.background(_readingMode);

  Color get _foreground => PdfReaderStyle.foreground(_readingMode);

  Color get _accent => PdfReaderStyle.accent;

  bool get _isLocalFile {
    final uri = Uri.tryParse(widget.pdfUrl.trim());

    return uri == null || !uri.hasScheme || uri.scheme == 'file';
  }

  String get _bookmarkKey => 'pdf_bookmarks_${widget.pdfUrl.trim()}';

  String get _lastPageKey => 'pdf_last_page_${widget.pdfUrl.trim()}';

  @override
  void initState() {
    super.initState();

    _pdfController = PdfViewerController();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _pdfController.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  // BOOKMARKS

  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_bookmarkKey) ?? [];

      final pages = saved
          .map(int.tryParse)
          .whereType<int>()
          .where((page) => page > 0)
          .toSet();

      if (!mounted) return;

      setState(() {
        _bookmarks
          ..clear()
          ..addAll(pages);
      });
    } catch (error) {
      debugPrint('Load bookmarks error: $error');
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pages = _bookmarks.toList()..sort();

      await prefs.setStringList(
        _bookmarkKey,
        pages.map((page) => page.toString()).toList(),
      );
    } catch (error) {
      debugPrint('Save bookmarks error: $error');
    }
  }

  Future<void> _handleBookmarkAction(String action) async {
    if (action == 'toggle') {
      if (!_isLoaded || _currentPage < 1) return;

      final wasBookmarked = _bookmarks.contains(_currentPage);

      setState(() {
        if (wasBookmarked) {
          _bookmarks.remove(_currentPage);
        } else {
          _bookmarks.add(_currentPage);
        }
      });

      await _saveBookmarks();

      if (!mounted) return;

      _showMessage(wasBookmarked ? 'Bookmark removed' : 'Page bookmarked');
      return;
    }

    if (action == 'clear') {
      setState(_bookmarks.clear);
      await _saveBookmarks();
      return;
    }

    if (action.startsWith('page:')) {
      final page = int.tryParse(action.substring(5));

      if (page != null) {
        _changePage(page);
      }
    }
  }

  // ignore: unused_element
  Future<void> _showBookmarks() async {
    if (_bookmarks.isEmpty) {
      _showMessage('No bookmarks yet.');
      return;
    }

    final pages = _bookmarks.toList()..sort();

    final selectedPage = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: _background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.bookmarks_rounded, color: _accent),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'My Bookmarks',
                        style: TextStyle(
                          color: _foreground,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        await _handleBookmarkAction('clear');
                        if (mounted) {
                          _showMessage('Bookmarks cleared');
                        }
                      },
                      child: Text(
                        'Clear all',
                        style: TextStyle(color: _accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: pages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (_, index) {
                      final page = pages[index];

                      return ListTile(
                        onTap: () => Navigator.pop(sheetContext, page),
                        tileColor: _readingMode == PdfReadingMode.night
                            ? const Color(0xFF26232B)
                            : (_readingMode == PdfReadingMode.eyeComfort
                                  ? const Color(0xFFEBDCC5)
                                  : const Color(0xFFFFF0F5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        leading: Icon(Icons.bookmark_rounded, color: _accent),
                        title: Text(
                          'Page $page',
                          style: TextStyle(
                            color: _foreground,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: _accent,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedPage != null) {
      _changePage(selectedPage);
    }
  }

  // SAVE AND RESTORE READING POSITION

  Future<void> _restoreLastPage(int totalPages) async {
    if (_restoredLastPage) return;
    _restoredLastPage = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final page = prefs.getInt(_lastPageKey);

      if (!mounted || !_isLoaded) return;

      if (page != null && page >= 1 && page <= totalPages) {
        _pdfController.jumpToPage(page);
      }
    } catch (error) {
      debugPrint('Restore page error: $error');
    }
  }

  Future<void> _saveCurrentPage(int page) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastPageKey, page);
    } catch (error) {
      debugPrint('Save page error: $error');
    }
  }

  // PDF EVENTS

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    if (!mounted) return;

    final totalPages = details.document.pages.count;

    setState(() {
      _totalPages = totalPages;
      _currentPage = 1;
      _isLoaded = true;
      _hasError = false;

      _bookmarks.removeWhere((page) => page < 1 || page > totalPages);
    });

    _saveBookmarks();
    _restoreLastPage(totalPages);
  }

  void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    debugPrint('PDF load error: ${details.error}');

    if (!mounted) return;

    setState(() {
      _hasError = true;
      _isLoaded = false;
    });
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    if (!mounted) return;

    setState(() {
      _currentPage = details.newPageNumber;
    });

    _saveCurrentPage(details.newPageNumber);
  }

  void _changePage(int page) {
    if (!_isLoaded || page < 1 || page > _totalPages) {
      return;
    }

    _pdfController.jumpToPage(page);
  }

  void _retry() {
    setState(() {
      _reloadKey++;
      _currentPage = 1;
      _totalPages = 0;
      _isLoaded = false;
      _hasError = false;
      _restoredLastPage = false;
    });
  }

  // GO TO PAGE

  void _setReadingMode(PdfReadingMode mode) {
    if (_readingMode == mode) return;

    setState(() {
      _readingMode = mode;
    });
  }

  // ignore: unused_element
  Future<void> _showReadingModes() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reading appearance',
                  style: TextStyle(
                    fontSize: 19,
                    color: _foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Choose your preferred reading theme.',
                  style: TextStyle(
                    fontSize: 13,
                    color: _foreground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 14),
                _modeTile(
                  context: sheetContext,
                  title: 'Light',
                  subtitle: 'Classic reading appearance',
                  icon: Icons.light_mode_rounded,
                  mode: PdfReadingMode.light,
                  previewColor: const Color(0xFFFFF7FA),
                ),
                _modeTile(
                  context: sheetContext,
                  title: 'Dark',
                  subtitle: 'Dark appearance for low-light settings',
                  icon: Icons.dark_mode_rounded,
                  mode: PdfReadingMode.night,
                  previewColor: const Color(0xFF242129),
                ),
                _modeTile(
                  context: sheetContext,
                  title: 'Eye Comfort',
                  subtitle: 'Warm, paper-like appearance',
                  icon: Icons.visibility_rounded,
                  mode: PdfReadingMode.eyeComfort,
                  previewColor: const Color(0xFFF4E8D5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _modeTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required PdfReadingMode mode,
    required Color previewColor,
  }) {
    final selected = _readingMode == mode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: previewColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, color: primary),
      ),
      title: Text(
        title,
        style: TextStyle(color: _foreground, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: _foreground.withOpacity(0.7), fontSize: 12),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: _accent)
          : null,
      onTap: () {
        _setReadingMode(mode);
        Navigator.pop(context);
      },
    );
  }

  // FULLSCREEN

  Future<void> _toggleFullscreen() async {
    final next = !_isFullscreen;

    try {
      await SystemChrome.setEnabledSystemUIMode(
        next ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
      );

      if (!mounted) return;

      setState(() {
        _isFullscreen = next;
      });
    } catch (error) {
      debugPrint('Fullscreen error: $error');
    }
  }

  // UI HELPERS

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF8F3159),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          margin: const EdgeInsets.all(14),
        ),
      );
  }

  // ignore: unused_element
  Widget _iconButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, color: _accent, size: 21),
      style: IconButton.styleFrom(
        backgroundColor: _background,
        minimumSize: const Size(40, 40),
        maximumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return PdfReaderErrorView(
      foreground: _foreground,
      title: widget.pdfUrl.trim().isEmpty
          ? 'PDF link is missing'
          : 'Unable to open this book',
      message: widget.pdfUrl.trim().isEmpty
          ? 'This book does not have a valid PDF path.'
          : 'Check your connection or make sure the PDF file exists.',
      onRetry: widget.pdfUrl.trim().isEmpty ? null : _retry,
    );
  }

  Widget _buildPdfViewer() {
    if (widget.pdfUrl.trim().isEmpty || _hasError) {
      return _buildErrorView();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: KeyedSubtree(
            key: ValueKey(_reloadKey),
            child: ColorFiltered(
              colorFilter: PdfReaderStyle.colorFilter(_readingMode),
              child: _isLocalFile ? _buildLocalPdf() : _buildNetworkPdf(),
            ),
          ),
        ),
        if (!_isLoaded)
          Positioned.fill(
            child: PdfReaderLoadingView(
              background: _background,
              foreground: _foreground,
            ),
          ),
      ],
    );
  }

  Widget _buildLocalPdf() {
    final uri = Uri.tryParse(widget.pdfUrl.trim());

    final path = uri != null && uri.scheme == 'file'
        ? uri.toFilePath()
        : widget.pdfUrl.trim();

    return SfPdfViewer.file(
      File(path),
      controller: _pdfController,
      canShowPaginationDialog: false,
      canShowScrollHead: true,
      pageLayoutMode: PdfPageLayoutMode.continuous,
      onDocumentLoaded: _onDocumentLoaded,
      onDocumentLoadFailed: _onDocumentLoadFailed,
      onPageChanged: _onPageChanged,
    );
  }

  Widget _buildNetworkPdf() {
    return SfPdfViewer.network(
      widget.pdfUrl.trim(),
      controller: _pdfController,
      canShowPaginationDialog: false,
      canShowScrollHead: true,
      pageLayoutMode: PdfPageLayoutMode.continuous,
      onDocumentLoaded: _onDocumentLoaded,
      onDocumentLoadFailed: _onDocumentLoadFailed,
      onPageChanged: _onPageChanged,
    );
  }

  // MAIN BUILD

  @override
  Widget build(BuildContext context) {
    final isBookmarked = _bookmarks.contains(_currentPage);

    return Scaffold(
      backgroundColor: _background,
      appBar: _isFullscreen
          ? null
          : PdfReaderAppBar(
              key: ValueKey(_readingMode),
              title: widget.bookTitle,
              currentPage: _currentPage,
              totalPages: _totalPages,
              isLoaded: _isLoaded,
              mode: _readingMode,
              isBookmarked: isBookmarked,
              bookmarks: _bookmarks.toList()..sort(),
              onModeChanged: _setReadingMode,
              onBookmarkAction: _handleBookmarkAction,
              onFullscreen: _toggleFullscreen,
            ),
      body: Column(
        children: [
          if (_isLoaded && !_hasError && !_isFullscreen)
            LinearProgressIndicator(
              value: _totalPages > 0
                  ? (_currentPage / _totalPages).clamp(0.0, 1.0)
                  : 0.0,
              minHeight: 2,
              backgroundColor: _accent.withOpacity(0.12),
              color: _accent,
            ),
          Expanded(child: _buildPdfViewer()),
        ],
      ),
      floatingActionButton: _isFullscreen && _isLoaded && !_hasError
          ? FloatingActionButton.small(
              heroTag: 'exitPdfFullscreen',
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              tooltip: 'Exit fullscreen',
              onPressed: _toggleFullscreen,
              child: const Icon(Icons.fullscreen_exit_rounded),
            )
          : _isLoaded && !_hasError
          ? FloatingActionButton(
              heroTag: 'pdfBookmarkButton',
              backgroundColor: _background,
              foregroundColor: _foreground,
              elevation: 3,
              tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark this page',
              onPressed: () {
                _handleBookmarkAction('toggle');
              },
              child: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_add_outlined,
                color: _accent,
              ),
            )
          : null,
    );
  }
}
