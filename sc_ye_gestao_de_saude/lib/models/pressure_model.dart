class PressureModel {
  String id;
  String date;
  int diastolic;
  int sistolic;
  bool isExpanded = false;

  PressureModel({
    required this.id,
    required this.date,
    required this.diastolic,
    required this.sistolic,
    required this.isExpanded,
  });

  PressureModel.fromMap(Map<String, dynamic> map, {bool isExpanded = false})
      : id = map["id"],
        date = map["date"],
        diastolic = map["diastolic"],
        sistolic = map["sistolic"],
        isExpanded = isExpanded; // Usando o valor passado ou false por padrão

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "diastolic": diastolic,
      "sistolic": sistolic,
    };
  }
}