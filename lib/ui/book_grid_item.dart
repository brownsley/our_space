import 'package:flutter/material.dart';

class BookGridItem extends StatelessWidget {
  final String name;
  final String url;
  final String cover;
  final String author;
  final String category;
  final VoidCallback onTap;

  const BookGridItem({
    super.key,
    required this.name,
    required this.url,
    required this.cover,
    required this.author,
    required this.category,
    required this.onTap,
  });

  static const Color primary = Color(0xFFE05688);
  static const Color textDark = Color(0xFF30212A);
  static const Color muted = Color(0xFF9B8791);
  static const Color borderColor = Color(0xFFF4DCE7);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    cover.isNotEmpty
                        ? Image.network(
                            cover,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),

                    // Subtle top gradient
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 48,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Pink category badge
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 110),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Small decorative book icon
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: primary,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Book information
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            author.isEmpty ? 'Unknown author' : author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFFFE8F0),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, size: 36, color: primary),
      ),
    );
  }
}
