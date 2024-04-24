import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/cadastroOptions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CadastroOptions(),
    );
  }
}
