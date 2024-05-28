import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Adicione esta linha
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_details_modal.dart';

class ConsultationDetails extends StatelessWidget {
  final String specialty;
  final List<ConsultationModel> consultations;

  const ConsultationDetails({super.key, required this.specialty, required this.consultations});

  @override
  Widget build(BuildContext context) {
    // Defina o formato da data de acordo com o formato usado em suas strings de data
    final dateFormat = DateFormat('dd/MM/yyyy'); 

    // Ordene a lista de consultas pela data em ordem decrescente
    consultations.sort((a, b) {
      final dateA = dateFormat.parse(a.date);
      final dateB = dateFormat.parse(b.date);
      return dateB.compareTo(dateA); // Ordem decrescente
    });

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color.fromRGBO(123, 123, 123, 1)),
                ),
                const SizedBox(width: 20),
                Text(
                  '$specialty >',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Color.fromRGBO(123, 123, 123, 1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                var consultation = consultations[index];
                return ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ConsultationsDetailsModal(
                        specialty: consultation.specialty,
                        doctorName: consultation.doctorName,
                        date: consultation.date,
                        time: consultation.time,
                        description: consultation.description,
                        reminder: consultation.reminder,
                      ),
                    );
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      consultation.date,
                      style: const TextStyle(
                        fontSize: 21,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(85, 85, 85, 1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
