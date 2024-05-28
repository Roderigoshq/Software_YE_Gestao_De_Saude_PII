import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
      ),
      body: Container(
        color: Colors.white, // Cor de fundo do corpo da tela
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'lib/assets/Logo_gestao_de_saude.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Termos de Uso',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Ao utilizar este aplicativo, você concorda com a coleta, processamento e armazenamento dos seus dados pessoais conforme descrito na nossa Política de Privacidade. Isso inclui informações fornecidas durante o uso do aplicativo, como nome, e-mail e informações de perfil. Os dados coletados serão utilizados apenas para os propósitos especificados na política e serão tratados de acordo com as leis de proteção de dados aplicáveis',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
