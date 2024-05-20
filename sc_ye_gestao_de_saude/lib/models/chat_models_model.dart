class ChatModelsModel {
  final String id;
  final int created;
  final String ownedBy;

  ChatModelsModel({
    required this.id,
    required this.created,
    required this.ownedBy,
  });

  factory ChatModelsModel.fromJson(Map<String, dynamic> json) {
    // Verifica se os campos obrigatórios estão presentes e têm o tipo esperado
    if (json['id'] == null || json['created'] == null || json['owned_by'] == null) {
      throw FormatException("Dados inválidos para criar ChatModelsModel");
    }

    return ChatModelsModel(
      id: json['id'],
      created: json['created'],
      ownedBy: json['owned_by'],
    );
  }

  static List<ChatModelsModel> modelsFromSnapshot(List<dynamic> modelSnapshot) {
    // Mapeia os dados do snapshot para uma lista de ChatModelsModel
    return modelSnapshot
        .map((data) => ChatModelsModel.fromJson(data))
        .toList();
  }
}