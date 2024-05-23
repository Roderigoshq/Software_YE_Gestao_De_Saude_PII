import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/medication_modal.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({Key? key}) : super(key: key);

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  // final ConsultationService _consultationService = ConsultationService();

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
                alignment: Alignment.centerLeft,  // Alinhamento para sobrepor texto na imagem
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),  // Espaçamento para o texto
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Gerencie suas\n",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: "consultas:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,  // Posicionamento da imagem no lado direito
                    child: Image.asset(
                      'lib/assets/consulta.png',
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