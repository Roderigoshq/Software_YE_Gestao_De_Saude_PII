import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';

class MedicationService {
  String userId;
  List<MedicationModel> medicationList = []; // Lista de medicações

  MedicationService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMedication(MedicationModel medicationModel) async {
    return await _firestore
        .collection('medications')
        .doc(userId)
        .collection('userMedications')
        .doc(medicationModel.id)
        .set(medicationModel.toMap());
  }

  Future<void> editMedication(MedicationModel updatedMedication) async {
    try {
      await _firestore
          .collection('medications')
          .doc(userId)
          .collection('userMedications')
          .doc(updatedMedication.id)
          .update(updatedMedication.toMap());
    } catch (error) {
      print("Erro ao editar medicação: $error");
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _firestore
          .collection('medications')
          .doc(userId)
          .collection('userMedications')
          .doc(id)
          .delete();
    } catch (e) {
      print("Erro ao excluir a medicação: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMedication() {
    return _firestore
        .collection('medications')
        .doc(userId)
        .collection('userMedications')
        .snapshots();
  }

  Future<List<MedicationModel>> fetchMedicationModels() async {
    try {
      final querySnapshot = await _firestore
          .collection('medications')
          .doc(userId)
          .collection('userMedications')
          .get();

      final medicationModels = querySnapshot.docs.map((doc) {
        return MedicationModel.fromMap(doc.data());
      }).toList();

      return medicationModels;
    } catch (error) {
      print("Erro ao buscar modelos de medicação: $error");
      return [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMedicationByUser(String userId) {
    return _firestore
        .collection('medications')
        .doc(userId)
        .collection('userMedications')
        .snapshots();
  }

  Future<MedicationModel?> getLatestMedication() async {
    try {
      final querySnapshot = await _firestore
          .collection('medications')
          .doc(userId)
          .collection('userMedications')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestMedication = querySnapshot.docs.first;
        return MedicationModel.fromMap(latestMedication.data());
      } else {
        return null;
      }
    } catch (error) {
      print("Erro ao buscar a medicação mais recente: $error");
      return null;
    }
  }
}
