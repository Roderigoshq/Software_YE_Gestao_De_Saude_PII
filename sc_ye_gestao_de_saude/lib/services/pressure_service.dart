import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/pressure_model.dart';

class PressureAdd {
  String userId;
  List<PressureModel> pressureList = []; // Lista de pressões

  PressureAdd() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPressure(PressureModel pressureModel) async {
    return await _firestore
        .collection('pressures')
        .doc(userId)
        .collection('userPressures')
        .doc(pressureModel.id)
        .set(pressureModel.toMap());
  }

  Future<void> editPressure(PressureModel updatedPressure) async {
    try {
      await _firestore
          .collection('pressures')
          .doc(userId)
          .collection('userPressures')
          .doc(updatedPressure.id)
          .update(updatedPressure.toMap());
    } catch (error) {
      print("Erro ao editar pressão: $error");
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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamPressure() {
    return _firestore
        .collection('pressures')
        .doc(userId)
        .collection('userPressures')
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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamPressureByUser(String userId) {
    return _firestore
        .collection('pressures')
        .doc(userId)
        .collection('userPressures')
        .snapshots();
  }

  Future<PressureModel?> getLatestPressure() async {
    try {
      final querySnapshot = await _firestore
          .collection('pressures')
          .doc(userId)
          .collection('userPressures')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
      final latestPressureDoc = querySnapshot.docs.first;
      final latestPressure = PressureModel.fromMap(latestPressureDoc.data());
      return latestPressure;
    } else {
        return null;
      }
    } catch (error) {
      print("Erro ao buscar a pressão mais recente: $error");
      return null;
    }
  }
}
