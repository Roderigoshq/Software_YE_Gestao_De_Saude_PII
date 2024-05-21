// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sc_ye_gestao_de_saude/models/exam_model.dart';

// class ExamService {
//   String userId;
//   List<ExamModel> examList = []; // Lista de exames

//   ExamService() : userId = FirebaseAuth.instance.currentUser!.uid;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addExam(ExamModel examModel) async {
//     return await _firestore
//         .collection('exams')
//         .doc(userId)
//         .collection('userExams')
//         .doc(examModel.id)
//         .set(examModel.toMap());
//   }

//   Future<void> editExam(ExamModel updatedExam) async {
//     try {
//       await _firestore
//           .collection('exams')
//           .doc(userId)
//           .collection('userExams')
//           .doc(updatedExam.id)
//           .update(updatedExam.toMap());
//     } catch (error) {
//       print("Erro ao editar exame: $error");
//     }
//   }

//   Future<void> deleteExam(String id) async {
//     try {
//       await _firestore
//           .collection('exams')
//           .doc(userId)
//           .collection('userExams')
//           .doc(id)
//           .delete();
//     } catch (e) {
//       print("Erro ao excluir o exame: $e");
//     }
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> streamExams() {
//     return _firestore
//         .collection('exams')
//         .doc(userId)
//         .collection('userExams')
//         .snapshots();
//   }

//   Future<List<ExamModel>> fetchExamModels() async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('exams')
//           .doc(userId)
//           .collection('userExams')
//           .get();

//       final examModels = querySnapshot.docs.map((doc) {
//         return ExamModel.fromMap(doc.data());
//       }).toList();

//       return examModels;
//     } catch (error) {
//       print("Erro ao buscar modelos de exame: $error");
//       return [];
//     }
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> streamExamsByUser(String userId) {
//     return _firestore
//         .collection('exams')
//         .doc(userId)
//         .collection('userExams')
//         .snapshots();
//   }

//   Future<ExamModel?> getLatestExam() async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('exams')
//           .doc(userId)
//           .collection('userExams')
//           .orderBy('date', descending: true)
//           .limit(1)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         final latestExam = querySnapshot.docs.first;
//         return ExamModel.fromMap(latestExam.data());
//       } else {
//         return null;
//       }
//     } catch (error) {
//       print("Erro ao buscar o exame mais recente: $error");
//       return null;
//     }
//   }
// }
