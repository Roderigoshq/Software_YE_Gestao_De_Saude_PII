import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/form_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF889553),
        title: Row(
          children: [
            Image.asset(
              'lib/assets/logo.png',
              width: 150,
              height: 150,
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.info, color: Color(0xFFC6D687)),
              iconSize: 30,
              onPressed: () {
                // Ação ao clicar no ícone de informação
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFFC6D687)),
              iconSize: 30,
              onPressed: () {
                // Ação ao clicar no ícone de configuração
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Image.asset(
          'lib/assets/medicamento.png',
          width: 150,
          height: 150,
        ),
      ),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: false,
              context: context,
              builder: (ctx) => FormScreen(),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color(0xFFC6D687),
        ),
      ),
    );
  }
}
