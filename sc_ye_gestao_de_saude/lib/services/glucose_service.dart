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

  Future<void> deleteGlucose(GlucoseModel glucose) async {
    try {
      await _firestore
          .collection('glucose')
          .doc(userId)
          .collection('userGlucose')
          .doc(glucose.id)
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

  Future<GlucoseModel?> getLatestGlucose() async {
    try {
      // Busque as glicemias mais recentes
      final querySnapshot = await _firestore
          .collection('glucose')
          .doc(userId)
          .collection('userGlucose')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
      final latestGlucoseDoc = querySnapshot.docs.first;
      final latestGlucose = GlucoseModel.fromMap(latestGlucoseDoc.data());
      return latestGlucose;
    } else {
        return null;
      }
    } catch (error) {
      print("Erro ao buscar a glicemia mais recente: $error");
      return null;
    }
  }
}
