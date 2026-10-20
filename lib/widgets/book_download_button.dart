import 'package:flutter/material.dart';

class BookDownloadButton extends StatelessWidget {
  final bool isDownloaded;
  final double? progress;
  final VoidCallback? onTap;

  const BookDownloadButton({
    super.key,
    required this.isDownloaded,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDownloading = progress != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isDownloading
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress == 0 ? null : progress,
                    strokeWidth: 3.5,
                    color: const Color(0xFFE05688),
                    backgroundColor: const Color(0xFFE05688).withOpacity(0.2),
                  ),
                  Text(
                    '${(progress! * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Icon(
                isDownloaded
                    ? Icons.check_circle_rounded
                    : Icons.file_download_rounded,
                size: 22,
                color: isDownloaded ? Colors.green : const Color(0xFFE05688),
              ),
      ),
    );
  }
}
