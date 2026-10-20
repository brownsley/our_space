import 'package:bcall/services/telegram_service.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const Color _pink = Color(0xFFE05688);
  static const Color _dark = Color(0xFF2C1820);

  Future<void> _sendLoveMessage(BuildContext context) async {
    try {
      await TelegramService.sendMessage('Thinking of you, always 💗');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF30223A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: Color(0xFFFF91B9)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ('Love message sent successfully!'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Special Space',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Miles Apart, Close at Heart ✨',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _sendLoveMessage(context),
          icon: const Icon(Icons.favorite_rounded, color: _pink, size: 23),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(11),
            side: const BorderSide(color: Colors.white70, width: 2),
          ),
          tooltip: 'Send love',
        ),
      ],
    );
  }
}
