import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/form_screen.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.fromLTRB(40, 35, 40, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Tome sempre seus ",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "medicamentos:",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // Espaçamento entre o texto e a imagem
                Image.asset(
                  'lib/assets/pilula.png',
                  height: 70, // Ajuste a altura conforme necessário
                  width: 70, // Ajuste a largura conforme necessário
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16), // Adicionando um espaçamento na parte inferior
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: false,
              context: context,
              builder: (ctx) => FormScreen(),
            );
          },
          backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          shape: const CircleBorder(), // Deixando o botão redondo
        ),
      ),
    );
  }
}
