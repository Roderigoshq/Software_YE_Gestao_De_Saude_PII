import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;
  SuccessPopup({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 60, color: Colors.green),
          SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style:  TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
