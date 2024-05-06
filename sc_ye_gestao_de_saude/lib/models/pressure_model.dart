class PressureModel {
  String id;
  String date;
  int diastolic;
  int sistolic;
  bool isExpanded; // Adicionando a propriedade isExpanded

  PressureModel({
    required this.id,
    required this.date,
    required this.diastolic,
    required this.sistolic,
    this.isExpanded = false, // Valor padrão de false para isExpanded
  });

  PressureModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        date = map["date"],
        diastolic = map["diastolic"],
        sistolic = map["sistolic"],
        isExpanded = map["isExpanded"] ?? false;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "diastolic": diastolic,
      "sistolic": sistolic,
      "isExpanded": isExpanded,
    };
  }

  void toggleExpanded() {
    isExpanded = !isExpanded;
// Alternando entre true e false
  }
}
