import 'package:flutter/material.dart';
import 'package:green_thumb/main.dart';

class NotificationSnackBar {
  String text;
  NotificationSnackBar({required this.text});

  void show() {
    scaffoldMessengerKey.currentState?.showSnackBar(get());
  }

  SnackBar get() {
    return SnackBar(
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.accessibility_new_rounded),
          const SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
    );
  }
}
