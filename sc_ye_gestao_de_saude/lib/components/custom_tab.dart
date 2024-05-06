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
      mainAxisAlignment: MainAxisAlignment.start, // Alinhamento superior
      mainAxisSize: MainAxisSize.min, // Ocupar apenas o espaço mínimo vertical
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.center, // Alinhamento central horizontal
        ), // Texto da aba
        const SizedBox(height: 2), // Espaçamento entre os textos
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
        ), // Texto adicional abaixo da aba
      ],
    );
  }
}
