import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/pages/consultation_details.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_modal.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({Key? key}) : super(key: key);

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final ConsultationService dbService = ConsultationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment
                    .centerLeft, // Alinhamento para sobrepor texto na imagem
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30), // Espaçamento para o texto
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
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 29,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          ),
                          TextSpan(
                            text: "consultas:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Color.fromRGBO(65, 65, 65, 1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0, // Posicionamento da imagem no lado direito
                    child: Image.asset(
                      'lib/assets/consulta.png',
                      height: 130,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: dbService.consultationsCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var consultas = snapshot.data!.docs
                    .map((doc) => ConsultationModel.fromFirestore(doc))
                    .toList();
                return ListView.builder(
                  itemCount: consultas.length,
                  itemBuilder: (context, index) {
                    var consulta = consultas[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            consulta.specialty,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(85, 85, 85, 1)),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_right,
                            color: Color.fromRGBO(85, 85, 85, 1),
                          )
                        ],
                      ),
                      subtitle: Text(consulta.date),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConsultationDetails(
                                  consultationModel: consulta)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 40),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConsultationModal(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromRGBO(136, 149, 83, 1), width: 8),
              color: Color.fromRGBO(136, 149, 83, 1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
