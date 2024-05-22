import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/widgets/exams_modal.dart';
import 'package:sc_ye_gestao_de_saude/models/exams_model.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Consulte seus ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "exames realizados:",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      'lib/assets/exame.png',
                      height: 130,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ExtensionPanelExam(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarModelExam(context);
        },
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(136, 149, 83, 1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
