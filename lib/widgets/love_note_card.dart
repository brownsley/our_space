import 'package:flutter/material.dart';

class LoveNoteCard extends StatelessWidget {
  final String note;
  final VoidCallback onRefresh;

  const LoveNoteCard({super.key, required this.note, required this.onRefresh});

  static const Color pink = Color(0xFFE05688);
  static const Color dark = Color(0xFF30212A);
  static const Color muted = Color(0xFF947D87);
  static const Color borderPink = Color(0xFFF3DFE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderPink),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Subtle decorative circles
            Positioned(
              top: -35,
              right: -30,
              child: Container(
                height: 95,
                width: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFEAF2).withOpacity(0.7),
                ),
              ),
            ),
            Positioned(
              bottom: -35,
              left: -25,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF2F7).withOpacity(0.8),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE3ED), Color(0xFFFFF3F7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.mail_rounded,
                          color: pink,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'A LITTLE LOVE NOTE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: pink,
                                letterSpacing: 1.1,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Just for you ♡',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: dark,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Refresh action
                      Material(
                        color: const Color(0xFFFFF5F8),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: onRefresh,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderPink),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 15,
                                  color: pink,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'New',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: pink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Animated note
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.03),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: SizedBox(
                      key: ValueKey<String>(note),
                      width: double.infinity,
                      child: Text(
                        note,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: dark,
                          height: 1.55,
                          letterSpacing: 0.05,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom accent
                  Row(
                    children: [
                      Container(
                        height: 3,
                        width: 28,
                        decoration: BoxDecoration(
                          color: pink,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 3,
                        width: 10,
                        decoration: BoxDecoration(
                          color: pink.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.favorite_rounded,
                        size: 12,
                        color: pink.withOpacity(0.75),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Made with love',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: muted,
                          letterSpacing: 0.2,
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
    );
  }
}
