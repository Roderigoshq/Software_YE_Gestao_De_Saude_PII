import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDataService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(GoogleSignInAccount user) async {
    String? userId = user.id;
    String? userEmail = user.email;
    String? userName = user.displayName;

    // Salvando os dados do usuário no Firestore
    await usersCollection.doc(userId).set({
      'email': userEmail,
      'name': userName,
    });
  }

}
