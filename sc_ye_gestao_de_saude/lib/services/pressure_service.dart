import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:sc_ye_gestao_de_saude/models/pressure_model.dart";

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

  Stream<QuerySnapshot<Map<String, dynamic>>> screamPressure() {
   return _firestore
       .collection('pressures') // Acessando a coleção 'pressures'
       .doc(userId) // Usando userId como o ID do documento
       .collection('userPressures') // Subcoleção dentro do documento userId
       .snapshots();
  }
}
