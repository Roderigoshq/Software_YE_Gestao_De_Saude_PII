import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/weight_height_model.dart';

class WeightHeightAdd {
  String userId;

  WeightHeightAdd() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWeightHeight(WeightHeightModel weightHeightModel) async {
    return await _firestore
        .collection('weightHeight')
        .doc(userId)
        .collection('userWeightHeight')
        .doc(weightHeightModel.id)
        .set(weightHeightModel.toMap());
  }

  Future<void> editWeightHeight(WeightHeightModel updatedWeightHeight) async {
    try {
      await _firestore
          .collection('weightHeight')
          .doc(userId)
          .collection('userWeightHeight')
          .doc(updatedWeightHeight.id)
          .update(updatedWeightHeight.toMap());
    } catch (error) {
      print("Erro ao editar peso e altura: $error");
    }
  }

  Future<void> deleteWeightHeight(WeightHeightModel weightHeight) async {
  try {
    await _firestore
        .collection('weightHeight')
        .doc(userId)
        .collection('userWeightHeight')
        .doc(weightHeight.id) // Use o ID do objeto WeightHeightModel fornecido
        .delete();
  } catch (e) {
    print("Erro ao excluir peso e altura: $e");
  }
}


  Stream<QuerySnapshot<Map<String, dynamic>>> streamWeightHeight() {
    return _firestore
        .collection('weightHeight')
        .doc(userId)
        .collection('userWeightHeight')
        .snapshots();
  }

  Future<List<WeightHeightModel>> fetchWeightHeightModels() async {
    try {
      final querySnapshot = await _firestore
          .collection('weightHeight')
          .doc(userId)
          .collection('userWeightHeight')
          .get();

      final weightHeightModels = querySnapshot.docs.map((doc) {
        return WeightHeightModel.fromMap(doc.data());
      }).toList();

      return weightHeightModels;
    } catch (error) {
      print("Erro ao buscar modelos de peso e altura: $error");
      return [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamWeightHeightByUser(
      String userId) {
    return _firestore
        .collection('weightHeight')
        .doc(userId)
        .collection('userWeightHeight')
        .snapshots();
  }

  Future<WeightHeightModel?> getLatestWeight() async {
    try {
      final querySnapshot = await _firestore
          .collection('weightHeight')
          .doc(userId)
          .collection('userWeightHeight')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestWeightDoc = querySnapshot.docs.first;
        final latestWeightHeight =
            WeightHeightModel.fromMap(latestWeightDoc.data());
        return latestWeightHeight;
      } else {
        return null;
      }
    } catch (error) {
      print("Erro ao buscar o peso e altura mais recentes: $error");
      return null;
    }
  }
}
