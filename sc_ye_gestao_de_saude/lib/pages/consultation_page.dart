import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_modal.dart';
import 'consultation_details.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  ConsultationPageState createState() => ConsultationPageState();
}

class ConsultationPageState extends State<ConsultationPage> {
  final ConsultationService dbService = ConsultationService();

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
                alignment: Alignment.centerLeft,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
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
          Expanded(
            child: StreamBuilder<List<ConsultationModel>>(
              stream: dbService.getConsultations(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var consultas = snapshot.data!;
                var groupedConsultas = _groupConsultasBySpecialty(consultas);

                return ListView.builder(
                  itemCount: groupedConsultas.keys.length,
                  itemBuilder: (context, index) {
                    var specialty = groupedConsultas.keys.elementAt(index);
                    var consultasBySpecialty = groupedConsultas[specialty]!;

                    var nextConsultationDate =
                        _getNextConsultationDate(consultasBySpecialty);

                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              specialty,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(85, 85, 85, 1),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_right,
                              color: Color.fromRGBO(85, 85, 85, 1),
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                      subtitle: nextConsultationDate != null
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                                'Próxima consulta: ${DateFormat('dd/MM/yyyy').format(nextConsultationDate)}'),
                          )
                          : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Não há consulta marcada'),
                          ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultationDetails(
                              specialty: specialty,
                              consultations: consultasBySpecialty,
                            ),
                          ),
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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const ConsultationModal(),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromRGBO(136, 149, 83, 1), width: 8),
              color: const Color.fromRGBO(136, 149, 83, 1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
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

  Map<String, List<ConsultationModel>> _groupConsultasBySpecialty(
      List<ConsultationModel> consultas) {
    Map<String, List<ConsultationModel>> groupedConsultas = {};
    for (var consulta in consultas) {
      if (!groupedConsultas.containsKey(consulta.specialty)) {
        groupedConsultas[consulta.specialty] = [];
      }
      groupedConsultas[consulta.specialty]!.add(consulta);
    }
    return groupedConsultas;
  }

  DateTime? _getNextConsultationDate(List<ConsultationModel> consultas) {
    DateTime now = DateTime.now();
    DateTime? nextDate;

    for (var consulta in consultas) {
      DateTime consultationDate = DateFormat('dd/MM/yyyy').parse(consulta.date);
      if (consultationDate.isAfter(now)) {
        if (nextDate == null || consultationDate.isBefore(nextDate)) {
          nextDate = consultationDate;
        }
      }
    }

    return nextDate;
  }
}
