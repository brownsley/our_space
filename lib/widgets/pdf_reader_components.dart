import 'package:bcall/model/pdf_reader_models.dart';
import 'package:flutter/material.dart';

class PdfReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int currentPage;
  final int totalPages;
  final bool isLoaded;
  final PdfReadingMode mode;
  final bool isBookmarked;
  final List<int> bookmarks;

  final ValueChanged<PdfReadingMode> onModeChanged;
  final ValueChanged<String> onBookmarkAction;
  final VoidCallback onFullscreen;

  const PdfReaderAppBar({
    super.key,
    required this.title,
    required this.currentPage,
    required this.totalPages,
    required this.isLoaded,
    required this.mode,
    required this.isBookmarked,
    required this.bookmarks,
    required this.onModeChanged,
    required this.onBookmarkAction,
    required this.onFullscreen,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final foreground = PdfReaderStyle.foreground(mode);
    final surface = PdfReaderStyle.surface(mode);

    return AppBar(
      backgroundColor: surface,
      foregroundColor: foreground,
      elevation: 0,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Text(
            isLoaded ? 'Page $currentPage of $totalPages' : 'PDF Reader',
            style: TextStyle(fontSize: 11, color: foreground.withOpacity(0.65)),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          tooltip: 'Bookmarks',
          icon: Icon(
            isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: PdfReaderStyle.accent,
          ),
          onSelected: onBookmarkAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    isBookmarked
                        ? Icons.bookmark_remove_rounded
                        : Icons.bookmark_add_rounded,
                    color: PdfReaderStyle.accent,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isBookmarked
                        ? 'Remove page bookmark'
                        : 'Bookmark current page',
                  ),
                ],
              ),
            ),
            if (bookmarks.isNotEmpty) const PopupMenuDivider(),
            ...bookmarks.map(
              (page) => PopupMenuItem<String>(
                value: 'page:$page',
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: PdfReaderStyle.accent,
                    ),
                    const SizedBox(width: 12),
                    Text('Page $page'),
                  ],
                ),
              ),
            ),
          ],
        ),
        PopupMenuButton<PdfReadingMode>(
          tooltip: 'Reading appearance',
          initialValue: mode,
          color: surface,
          icon: const Icon(
            Icons.palette_outlined,
            color: PdfReaderStyle.accent,
          ),
          onSelected: onModeChanged,
          itemBuilder: (context) => [
            _modeItem(
              PdfReadingMode.light,
              Icons.light_mode_rounded,
              'Light mode',
              foreground,
            ),
            _modeItem(
              PdfReadingMode.night,
              Icons.dark_mode_rounded,
              'Night mode',
              foreground,
            ),
            _modeItem(
              PdfReadingMode.eyeComfort,
              Icons.remove_red_eye_rounded,
              'Eye comfort',
              foreground,
            ),
          ],
        ),
        IconButton(
          tooltip: 'Fullscreen',
          onPressed: onFullscreen,
          icon: const Icon(
            Icons.fullscreen_rounded,
            color: PdfReaderStyle.accent,
          ),
        ),
      ],
    );
  }

  PopupMenuItem<PdfReadingMode> _modeItem(
    PdfReadingMode value,
    IconData icon,
    String label,
    Color foreground,
  ) {
    final selected = value == mode;

    return PopupMenuItem<PdfReadingMode>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? PdfReaderStyle.accent : foreground,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: foreground,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (selected)
            const Icon(
              Icons.check_circle_rounded,
              color: PdfReaderStyle.accent,
              size: 18,
            ),
        ],
      ),
    );
  }
}

class PdfReaderBottomControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  const PdfReaderBottomControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _button(
              Icons.first_page_rounded,
              'First page',
              () => onPageSelected(1),
            ),
            _button(
              Icons.chevron_left_rounded,
              'Previous page',
              () => onPageSelected(currentPage - 1),
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () => _showPageDialog(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: PdfReaderStyle.accent.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$currentPage / $totalPages  ⌄',
                      style: const TextStyle(
                        color: PdfReaderStyle.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _button(
              Icons.chevron_right_rounded,
              'Next page',
              () => onPageSelected(currentPage + 1),
            ),
            _button(
              Icons.last_page_rounded,
              'Last page',
              () => onPageSelected(totalPages),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }

  void _showPageDialog(BuildContext context) {
    final controller = TextEditingController(text: currentPage.toString());

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Go to page'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '1 - $totalPages',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onSubmitted: (_) => _submitPage(dialogContext, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _submitPage(dialogContext, controller),
            child: const Text('Go'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _submitPage(BuildContext context, TextEditingController controller) {
    final page = int.tryParse(controller.text.trim());

    if (page == null || page < 1 || page > totalPages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a page between 1 and $totalPages.')),
      );
      return;
    }

    onPageSelected(page);
    Navigator.pop(context);
  }
}

class PdfReaderLoadingView extends StatelessWidget {
  final Color background;
  final Color foreground;

  const PdfReaderLoadingView({
    super.key,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              size: 64,
              color: PdfReaderStyle.accent,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: PdfReaderStyle.accent),
            const SizedBox(height: 16),
            Text(
              'Preparing your book...',
              style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfReaderErrorView extends StatelessWidget {
  final Color foreground;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const PdfReaderErrorView({
    super.key,
    required this.foreground,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 64,
              color: PdfReaderStyle.accent,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: foreground,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: foreground.withOpacity(0.7)),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
                style: FilledButton.styleFrom(
                  backgroundColor: PdfReaderStyle.accent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
