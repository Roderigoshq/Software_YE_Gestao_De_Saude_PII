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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference consultationsCollection =
      FirebaseFirestore.instance.collection('consultations');

  Future<void> adicionarConsulta(ConsultationModel consultationModel) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = consultationsCollection
          .doc(user.uid)
          .collection('consultationsUsuario')
          .doc();
      await userDoc.set(consultationModel.toFirestore());
    }
  }

  Stream<List<ConsultationModel>> getConsultations() {
    User? user = _auth.currentUser;
    if (user != null) {
      return consultationsCollection
          .doc(user.uid)
          .collection('consultationsUsuario')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ConsultationModel.fromFirestore(doc))
              .toList());
    } else {
      return const Stream.empty();
    }
  }

  Future<void> editConsultation(
    String? id,
    String specialty,
    String doctorName,
    String date,
    String time,
    String description,
    bool remember,
  ) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference consultaDoc = consultationsCollection
          .doc(user.uid)
          .collection('consultationsUsuario')
          .doc(id);

      await consultaDoc.update({
        'date': date,
        'description': description,
        'doctorName': doctorName,
        'especialidade': specialty,
        'time': time,
        'remember': remember,
      });
    }
  }

  // Future<void> editConsultation(String id) async {
  //   try {
  //     await _firestore
  //         .collection('consultas')
  //         .doc(userId)
  //         .collection('Consultas do Usuário')
  //         .doc(id)
  //         .delete();
  //   } catch (e) {
  //     print("Erro ao excluir a medicação: $e");
  //   }
  // }

  Future<void> deleteConsultation(String? id) async {
  User? user = _auth.currentUser;
  if (user != null) {
    DocumentReference consultaDoc = consultationsCollection
        .doc(user.uid)
        .collection('consultationsUsuario')
        .doc(id);

    await consultaDoc.delete();
  }
}

Future<void> deleteConsultationsBySpecialty(String specialty) async {
  User? user = _auth.currentUser;
  if (user != null) {
    QuerySnapshot snapshot = await consultationsCollection
        .doc(user.uid)
        .collection('consultationsUsuario')
        .where('specialty', isEqualTo: specialty)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}



  Stream<QuerySnapshot<Map<String, dynamic>>> streamConsultations() {
    return _firestore
        .collection('consultations')
        .doc(userId)
        .collection('userConsultations')
        .snapshots();
  }

  // Future<List<ConsultationModel>> fetchConsultationModels() async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('consultations')
  //         .doc(userId)
  //         .collection('userConsultations')
  //         .get();

  //     final consultationModels = querySnapshot.docs.map((doc) {
  //       return ConsultationModel.fromMap(doc.data());
  //     }).toList();

  //     return consultationModels;
  //   } catch (error) {
  //     print("Erro ao buscar modelos de consulta: $error");
  //     return [];
  //   }
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamConsultationsByUser(
      String userId) {
    return _firestore
        .collection('consultations')
        .doc(userId)
        .collection('userConsultations')
        .snapshots();
  }

  // Future<ConsultationModel?> getLatestConsultation() async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('consultations')
  //         .doc(userId)
  //         .collection('userConsultations')
  //         .orderBy('date', descending: true)
  //         .limit(1)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       final latestConsultation = querySnapshot.docs.first;
  //       return ConsultationModel.fromMap(latestConsultation.data());
  //     } else {
  //       return null;
  //     }
  //   } catch (error) {
  //     print("Erro ao buscar a consulta mais recente: $error");
  //     return null;
  //   }
  // }
}
