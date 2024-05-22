import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';

class ConsultationService {
  String userId;
  List<ConsultationModel> consultationList = []; // Lista de consultas

  ConsultationService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addConsultation(ConsultationModel consultationModel) async {
    return await _firestore
        .collection('consultations')
        .doc(userId)
        .collection('userConsultations')
        .doc(consultationModel.id)
        .set(consultationModel.toMap());
  }

  Future<void> editConsultation(ConsultationModel updatedConsultation) async {
    try {
      await _firestore
          .collection('consultations')
          .doc(userId)
          .collection('userConsultations')
          .doc(updatedConsultation.id)
          .update(updatedConsultation.toMap());
    } catch (error) {
      print("Erro ao editar consulta: $error");
    }
  }

  Future<void> deleteConsultation(String id) async {
    try {
      await _firestore
          .collection('consultations')
          .doc(userId)
          .collection('userConsultations')
          .doc(id)
          .delete();
    } catch (e) {
      print("Erro ao excluir a consulta: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamConsultations() {
    return _firestore
        .collection('consultations')
        .doc(userId)
        .collection('userConsultations')
        .snapshots();
  }

  Future<List<ConsultationModel>> fetchConsultationModels() async {
    try {
      final querySnapshot = await _firestore
          .collection('consultations')
          .doc(userId)
          .collection('userConsultations')
          .get();

      final consultationModels = querySnapshot.docs.map((doc) {
        return ConsultationModel.fromMap(doc.data());
      }).toList();

      return consultationModels;
    } catch (error) {
      print("Erro ao buscar modelos de consulta: $error");
      return [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamConsultationsByUser(String userId) {
    return _firestore
        .collection('consultations')
        .doc(userId)
        .collection('userConsultations')
        .snapshots();
  }

  Future<ConsultationModel?> getLatestConsultation() async {
    try {
      final querySnapshot = await _firestore
          .collection('consultations')
          .doc(userId)
          .collection('userConsultations')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestConsultation = querySnapshot.docs.first;
        return ConsultationModel.fromMap(latestConsultation.data());
      } else {
        return null;
      }
    } catch (error) {
      print("Erro ao buscar a consulta mais recente: $error");
      return null;
    }
  }
}