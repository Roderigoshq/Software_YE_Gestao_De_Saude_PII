import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_modal.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({Key? key}) : super(key: key);

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final ConsultationService _consultationService = ConsultationService();

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
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gerencie suas",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "consultas:",
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
                      'lib/assets/consulta.png',
                      height: 130,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: ExtensionPanelConsultation(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarModelConsultation(context);
        },
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
