import 'package:flutter/material.dart';

class Consult extends StatefulWidget {
  const Consult({super.key});

  @override
  State<Consult> createState() => _ConsultState();
}

class _ConsultState extends State<Consult> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Teste Consulta'),
      ),
    );
  }
}