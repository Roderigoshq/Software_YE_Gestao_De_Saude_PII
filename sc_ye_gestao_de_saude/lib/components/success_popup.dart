import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;
  const SuccessPopup({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 60, color: Colors.green),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style:  const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
