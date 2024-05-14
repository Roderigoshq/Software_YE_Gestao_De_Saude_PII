import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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

  Future<void> deleteWeightHeight(String id) async {
    try {
      await _firestore
          .collection('weightHeight')
          .doc(userId)
          .collection('userWeightHeight')
          .doc(id)
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
    final currentTime = DateTime.now();
    final querySnapshot = await _firestore
        .collection('weightHeight')
        .doc(userId)
        .collection('userWeightHeight')
        .orderBy('date', descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      WeightHeightModel? closestWeight;
      int minDifference = double.maxFinite.toInt();

      for (var doc in querySnapshot.docs) {
        final weightHeight = WeightHeightModel.fromMap(doc.data());
        final weightHeightDate = DateTime.parse(weightHeight.date); // Converte a data de String para DateTime

        // Calcula a diferença de tempo em milissegundos
        final difference = weightHeightDate.millisecondsSinceEpoch - currentTime.millisecondsSinceEpoch;

        // Calcula o valor absoluto da diferença
        final absoluteDifference = difference.abs();

        if (absoluteDifference < minDifference) {
          minDifference = absoluteDifference;
          closestWeight = weightHeight;
        }
      }

      return closestWeight;
    } else {
      return null;
    }
  } catch (error) {
    print("Erro ao buscar o peso e altura mais próximos da data atual: $error");
    return null;
  }
}




}
