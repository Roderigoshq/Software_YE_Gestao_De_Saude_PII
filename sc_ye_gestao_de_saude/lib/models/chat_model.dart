class ChatModel {
  final String message;
  final int chatIndex;

  ChatModel({required this.message, required this.chatIndex});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // Verifica se os campos obrigatórios estão presentes e têm o tipo esperado
    if (json['id'] == null || json['created'] == null || json['owned_by'] == null) {
      throw FormatException("Dados inválidos para criar ChatModelsModel");
    }

    return ChatModel(
      message: json['message'],
      chatIndex: json['chatIndex'],
    );
  }
}
