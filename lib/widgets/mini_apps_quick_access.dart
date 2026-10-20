import 'package:bcall/ui/mini_apps_header.dart';
import 'package:flutter/material.dart';
import 'package:bcall/ui/mini_app_card.dart';

import '../model/book_model.dart';
import '../pages/explore.dart';
import '../pages/download.dart';

class MiniAppsQuickAccess extends StatelessWidget {
  final List<Book> savedBooks;
  final Function(Book) onBookDownloaded;

  const MiniAppsQuickAccess({
    super.key,
    required this.savedBooks,
    required this.onBookDownloaded,
  });

  static const Color pink = Color(0xFFE05688);
  static const Color purple = Color(0xFF8A2387);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MiniAppsHeader(),
        // First row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MiniAppCard(
                title: 'Explore',
                subtitle: 'Discover books',
                description: 'Find your next favorite',
                icon: Icons.explore_rounded,
                accentColor: const Color(0xFF5C8DCA),
                backgroundColor: const Color(0xFFEDF4FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ExplorePage(onBookDownloaded: onBookDownloaded),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MiniAppCard(
                title: 'Downloads',
                subtitle: 'Offline library',
                description: 'Read anytime, anywhere',
                icon: Icons.download_for_offline_rounded,
                accentColor: const Color(0xFF8A2387), // Purple
                backgroundColor: const Color(0xFFF5ECF7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DownloadPage()),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Second row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MiniAppCard(
                title: 'Favorites',
                subtitle: 'Your saved books',
                description: 'Keep your favorite books close',
                icon: Icons.favorite_rounded,
                accentColor: const Color(0xFFE85D75), // Rose red
                backgroundColor: const Color(0xFFFFEEF0),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF30223A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: const Row(
                        children: [
                          Icon(Icons.warning_rounded, color: Color(0xFFFFD740)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Favorites feature is coming soon!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MiniAppCard(
                title: 'My Notes',
                subtitle: 'Save your thoughts',
                description: 'Keep your reading notes',
                icon: Icons.my_library_books,
                accentColor: const Color(0xFFD69A36),
                backgroundColor: const Color(0xFFFFF6E5),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF30223A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      content: const Row(
                        children: [
                          Icon(Icons.warning_rounded, color: Color(0xFFFFD740)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'My Notes feature is coming soon!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
