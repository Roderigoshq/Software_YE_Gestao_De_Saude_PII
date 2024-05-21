import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/medication_modal.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({Key? key}) : super(key: key);

  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final MedicationService _medicationService = MedicationService();

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
                          "Tome sempre seus ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "medicamentos:",
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
                      'lib/assets/pilula.png',
                      height: 130,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ExtensionPanelMedication(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarModelMedication(context);
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
