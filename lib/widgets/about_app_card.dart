import 'package:flutter/material.dart';

class AboutAppCard extends StatelessWidget {
  const AboutAppCard({super.key});

  static const Color pink = Color(0xFFE05688);
  static const Color dark = Color(0xFF30212A);
  static const Color muted = Color(0xFF947D87);
  static const Color borderPink = Color(0xFFF3DFE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderPink),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDF4),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: pink,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A LITTLE PIECE OF US',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: pink,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'About Our App',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: dark,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: pink,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Personal message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8FB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderPink),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.format_quote_rounded, color: pink, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'For My Dearest Nway,',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: dark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                Text(
                  'A little app for our long-distance journey. '
                  'Every milestone, note, and memory reminds us '
                  'that distance cannot lessen what we share.',
                  style: TextStyle(fontSize: 13, height: 1.6, color: muted),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forever in every little moment ♡',
                    style: TextStyle(
                      fontSize: 12,
                      color: pink,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
