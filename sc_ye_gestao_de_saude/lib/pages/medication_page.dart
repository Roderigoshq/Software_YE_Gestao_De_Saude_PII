import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/widgets/medication_modal.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(40, 35, 0, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'lib/assets/pilula.png',
                    height: 90,
                    width: 90,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          mostrarModelMedication(context);
        },
        ),


        
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       showModalBottomSheet(
      //         isScrollControlled: false,
      //         context: context,
      //         builder: (ctx) => FormScreenMedication(),
      //       );
      //     },
      //     backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
      //     child: const Icon(
      //       Icons.add,
      //       size: 30,
      //       color: Colors.white,
      //     ),
      //     shape: const CircleBorder(),
      //   ),
      // ),
    );
  }
}
