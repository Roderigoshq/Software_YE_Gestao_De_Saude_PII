import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/form_screen_exams.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  _ExamsPageState createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
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
                        "Consulte seus  ",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "exames realizados:",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'lib/assets/pilula.png',
                  height: 70,
                  width: 70,
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16),
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
              builder: (ctx) => FormScreenExams(),
            );
          },
          backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
