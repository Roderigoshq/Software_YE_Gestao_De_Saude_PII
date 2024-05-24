import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';

class ConsultationDetails extends StatelessWidget {
  final ConsultationModel consultationModel;

  ConsultationDetails({required this.consultationModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${consultationModel.doctorName} - ${consultationModel.specialty}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Médico: ${consultationModel.doctorName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Especialidade: ${consultationModel.specialty}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Horário: ${consultationModel.time}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Data: ${consultationModel.date}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Descrição: ${consultationModel.description}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}