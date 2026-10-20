import 'package:flutter/material.dart';

class MiniAppsHeader extends StatelessWidget {
  const MiniAppsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.widgets_rounded,
              color: Color(0xFFE05688),
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mini Apps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF30212A),
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Everything you need, in one place',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9B8791)),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.favorite_rounded,
            color: Color(0xFFE8A2BC),
            size: 19,
          ),
        ],
      ),
    );
  }
}
