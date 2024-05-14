import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final String subText;

  const CustomTab({
    super.key,
    required this.text,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ), // Texto da aba
        const SizedBox(height: 2),
        Text(
          subText,
          style: const TextStyle(
              fontSize: 11,
              color: Color.fromRGBO(177, 177, 177, 1),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
