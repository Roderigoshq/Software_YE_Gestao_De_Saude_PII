import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';

class MedicationService {
  String userId;
  List<MedicationModel> medicationList = []; // Lista de medicações

  MedicationService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference medicationsCollection = FirebaseFirestore.instance.collection('medications');

  Future<void> addMedication(MedicationModel medicationModel) async {
    DocumentReference userDoc = medicationsCollection
        .doc(userId)
        .collection('userMedications')
        .doc(medicationModel.id);
    await userDoc.set(medicationModel.toMap());
  }

  Future<void> adicionarConsulta(MedicationModel medicationModel) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = medicationsCollection
          .doc(user.uid)
          .collection('userMedications')
          .doc();
      await userDoc.set(medicationModel.toFirestore());
    }
  }

  Stream<List<MedicationModel>> getMedications() {
    User? user = _auth.currentUser;
    if (user != null) {
      return medicationsCollection
          .doc(user.uid)
          .collection('userMedications')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MedicationModel.fromFirestore(doc))
              .toList());
    } else {
      return const Stream.empty();
    }
  }

  Future<void> editMedication(
    String? id,
    String name,
    String dosage,
    String dates,
    String hour,
    String minute,
    bool reminder,
  ) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference medicationDoc = medicationsCollection
          .doc(user.uid)
          .collection('userMedications')
          .doc(id);

      await medicationDoc.update({
        'name': name,
        'dosage': dosage,
        'dates': dates.split(', '), // Divida as datas para formato de lista
        'hour': int.parse(hour),
        'minute': int.parse(minute),
        'reminder': reminder
      });
    }
  }

  Future<void> deleteMedication(String? id) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference medicationDoc = medicationsCollection
          .doc(user.uid)
          .collection('userMedications')
          .doc(id);

      await medicationDoc.delete();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMedications() {
    return _firestore
        .collection('medications')
        .doc(userId)
        .collection('userMedications')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMedicationsByUser(String userId) {
    return _firestore
        .collection('medications')
        .doc(userId)
        .collection('userMedications')
        .snapshots();
  }
}
