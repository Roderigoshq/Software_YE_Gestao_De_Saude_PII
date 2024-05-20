import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/models/weight_height_model.dart';

class WeightHeightProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late VoidCallback _listener;

  // Método de inicialização para adicionar o listener
  void initialize() {
    _listener = () {
      // Notifica os ouvintes quando ocorrerem mudanças
      notifyListeners();
    };
    super.addListener(_listener);
  }

  Future<List<WeightHeightModel>> fetchWeightHeightModels() async {
    // Se necessário, você pode chamar initialize() aqui
    try {
      final snapshot = await _firestore
          .collection('weightHeight')
          .doc(userId)
          .collection('userWeightHeight')
          .get();
      return snapshot.docs
          .map((doc) => WeightHeightModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erro ao buscar peso e altura: $e");
      return [];
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
      notifyListeners();
    } catch (e) {
      print("Erro ao excluir peso e altura: $e");
    }
  }

  Future<void> editWeightHeight(WeightHeightModel updatedWeightHeight) async {
    try {
      await _firestore
          .collection('weightHeight')
          .doc(userId)
          .collection('userWeightHeight')
          .doc(updatedWeightHeight.id)
          .update(updatedWeightHeight.toMap());
      notifyListeners();
    } catch (error) {
      print("Erro ao editar peso e altura: $error");
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(_listener);
  }

  void notifyItemDeleted() {
    notifyListeners();
  }
}

