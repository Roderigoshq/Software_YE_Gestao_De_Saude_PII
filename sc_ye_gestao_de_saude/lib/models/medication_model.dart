class MedicationModel {
  String id;
  String name;
  String dosage;
  String time;
  String date;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "dosage": dosage,
      "time": time,
      "date": date,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map["id"],
      name: map["name"],
      dosage: map["dosage"],
      time: map["time"],
      date: map["date"],
    );
  }
}
