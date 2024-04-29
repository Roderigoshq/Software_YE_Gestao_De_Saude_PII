import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YE Gestão de Saúde'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Ação para a seção de exames
                Navigator.pushNamed(context, '/exames');
              },
              child: Text('Exames'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação para a seção de consultas
                Navigator.pushNamed(context, '/consultas');
              },
              child: Text('Consultas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação para a seção de medicação
                Navigator.pushNamed(context, '/medicacao');
              },
              child: Text('Medicação'),
            ),
          ],
        ),
      ),
    );
  }
}
