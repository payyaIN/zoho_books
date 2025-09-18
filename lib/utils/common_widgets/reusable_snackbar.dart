import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PayzoSnackType { success, error, info }

void showPayzoSnackBar({
  required BuildContext context,
  required WidgetRef ref,
  required String message,
  PayzoSnackType type = PayzoSnackType.info,
}) {
  final backgroundColor = switch (type) {
    PayzoSnackType.success => Colors.green,
    PayzoSnackType.error => Colors.red,
    PayzoSnackType.info => Colors.blueGrey,
  };

  final icon = switch (type) {
    PayzoSnackType.success => Icons.check_circle,
    PayzoSnackType.error => Icons.error,
    PayzoSnackType.info => Icons.info,
  };

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
