import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final String subText;

  const CustomTab({
    Key? key,
    required this.text,
    required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Alinhamento superior
      mainAxisSize: MainAxisSize.min, // Ocupar apenas o espaço mínimo vertical
      children: [
        Text(
          text,
          textAlign: TextAlign.center, // Alinhamento central horizontal
        ), // Texto da aba
        SizedBox(height: 2), // Espaçamento entre os textos
        Text(
          subText,
          style: TextStyle(
              fontSize: 11,
              color: Color.fromRGBO(177, 177, 177, 1),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 10,
        ), // Texto adicional abaixo da aba
      ],
    );
  }
}
