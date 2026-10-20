import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  final String message;
  final VoidCallback onUpdatePressed;

  const UpdateDialog({
    super.key,
    required this.message,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Update Available"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Later"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onUpdatePressed();
          },
          child: const Text("Update Now"),
        ),
      ],
    );
  }
}
