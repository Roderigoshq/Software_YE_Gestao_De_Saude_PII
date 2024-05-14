import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/glucose_model.dart';

class GlucoseAdd {
  String userId;

  GlucoseAdd() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addGlucose(GlucoseModel glucoseModel) async {
    return await _firestore
        .collection('glucose')
        .doc(userId)
        .collection('userGlucose')
        .doc(glucoseModel.id)
        .set(glucoseModel.toMap());
  }

  Future<void> editGlucose(GlucoseModel updatedGlucose) async {
    try {
      await _firestore
          .collection('glucose')
          .doc(userId)
          .collection('userGlucose')
          .doc(updatedGlucose.id)
          .update(updatedGlucose.toMap());
    } catch (error) {
      print("Erro ao editar glicemia: $error");
    }
  }

  Future<void> deleteGlucose(String id) async {
    try {
      await _firestore
          .collection('glucose')
          .doc(userId)
          .collection('userGlucose')
          .doc(id)
          .delete();
    } catch (e) {
      print("Erro ao excluir a glicemia: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamGlucose() {
    return _firestore
        .collection('glucose')
        .doc(userId)
        .collection('userGlucose')
        .snapshots();
  }

  Future<List<GlucoseModel>> fetchGlucoseModels() async {
    try {
      final querySnapshot = await _firestore
          .collection('glucose')
          .doc(userId)
          .collection('userGlucose')
          .get();

      final glucoseModels = querySnapshot.docs.map((doc) {
        return GlucoseModel.fromMap(doc.data());
      }).toList();

      return glucoseModels;
    } catch (error) {
      print("Erro ao buscar modelos de glicemia: $error");
      return [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamGlucoseByUser(String userId) {
    return _firestore
        .collection('glucose')
        .doc(userId)
        .collection('userGlucose')
        .snapshots();
  }

  // Método para obter a glicemia mais recente
  Future<GlucoseModel?> getLatestGlucose() async {
    try {
      // Busque as glicemias mais recentes
      final querySnapshot = await _firestore
          .collection('glucose')
          .doc(userId)
          .collection('userGlucose')
          .orderBy('date', descending: true) // Ordene pela data em ordem decrescente
          .limit(1) // Limite para obter apenas uma glicemia
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se houver documentos na consulta
        final latestGlucose = querySnapshot.docs.first;
        return GlucoseModel.fromMap(latestGlucose.data());
      } else {
        return null; // Retorna null se não houver glicemias
      }
    } catch (error) {
      print("Erro ao buscar a glicemia mais recente: $error");
      return null;
    }
  }
}
