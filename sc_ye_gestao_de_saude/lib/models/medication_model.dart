import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationModel {
  String id;
  String name;
  String dosage;
  List<String> dates; // Lista de datas em formato string
  int hour;
  int minute;
  bool reminder;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.dates,
    required this.hour,
    required this.minute,
    this.reminder = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'dates': dates,
      'hour': hour,
      'minute': minute,
      'reminder': reminder,
    };
  }

  factory MedicationModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MedicationModel(
      id: doc.id,
      name: data['name'] ?? '',
      dosage: data['dosage'] ?? '',
      dates: List<String>.from(data['dates'] ?? []), // Ajuste aqui para lista
      hour: data['hour'] ?? 0,
      minute: data['minute'] ?? 0,
      reminder: data['reminder'] ?? false, // Adicionando o campo reminder
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'dosage': dosage,
      'dates': dates,
      'hour': hour,
      'minute': minute,
      'reminder': reminder // Adicionando o campo reminder
    };
  }
}
