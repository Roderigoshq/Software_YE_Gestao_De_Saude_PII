import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/pressure_model.dart';

class PressureAdd {
  String userId;
  PressureAdd() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPressure(PressureModel pressureModel) async {
    return await _firestore
        .collection('pressures')
        .doc(userId) // Usando userId como o ID do documento
        .collection('userPressures') // Subcoleção dentro do documento userId
        .doc(pressureModel.id) // Usando o ID do modelo de pressão como ID do documento na subcoleção
        .set(pressureModel.toMap());
  }

  Future<void> editPressure(PressureModel updatedPressure) async {
    try {
      await _firestore
          .collection('pressures')
          .doc(userId)
          .collection('userPressures')
          .doc(updatedPressure.id) // Usando o ID da pressão atualizada
          .update(updatedPressure.toMap());
    } catch (error) {
      print("Erro ao editar pressão: $error");
      // Lide com o erro conforme necessário
    }
  }

  Future<void> deletePressure(String id) async {
    try {
      await _firestore
          .collection('pressures')
          .doc(userId)
          .collection('userPressures')
          .doc(id)
          .delete();
    } catch (e) {
      print("Erro ao excluir a pressão: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> screamPressure() {
    return _firestore
        .collection('pressures') // Acessando a coleção 'pressures'
        .doc(userId) // Usando userId como o ID do documento
        .collection('userPressures') // Subcoleção dentro do documento userId
        .snapshots();
  }

  Future<List<PressureModel>> fetchPressureModels() async {
    try {
      final querySnapshot = await _firestore
          .collection('pressures')
          .doc(userId)
          .collection('userPressures')
          .get();
      
      final pressureModels = querySnapshot.docs.map((doc) {
        return PressureModel.fromMap(doc.data());
      }).toList();

      return pressureModels;
    } catch (error) {
      print("Erro ao buscar modelos de pressão: $error");
      return [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> screamPressureByUser(String userId) {
    return _firestore
        .collection('pressures')
        .doc(userId)
        .collection('userPressures')
        .snapshots();
  }
}
