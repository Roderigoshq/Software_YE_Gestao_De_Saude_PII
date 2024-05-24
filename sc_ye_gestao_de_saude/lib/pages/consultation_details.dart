import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';

class ConsultationDetails extends StatelessWidget {
  final String specialty;
  final List<ConsultationModel> consultations;

  ConsultationDetails({required this.specialty, required this.consultations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultas - $specialty')),
      body: ListView.builder(
        itemCount: consultations.length,
        itemBuilder: (context, index) {
          var consultation = consultations[index];
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome do Médico: ${consultation.doctorName}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Especialidade: ${consultation.specialty}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Horário: ${consultation.time}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Data: ${consultation.date}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('Descrição: ${consultation.description}', style: TextStyle(fontSize: 18)),
                Divider(thickness: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
