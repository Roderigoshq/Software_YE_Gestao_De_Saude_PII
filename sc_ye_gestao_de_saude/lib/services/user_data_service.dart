import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sc_ye_gestao_de_saude/pages/login_page.dart';

class UserDataService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(GoogleSignInAccount user) async {
    // Extraindo as informações necessárias do usuário
    String? userId = user.id;
    String? userEmail = user.email;
    String? userName = user.displayName;

    // Salvando os dados do usuário no Firestore
    await usersCollection.doc(userId).set({
      'email': userEmail,
      'name': userName,
      // Outros campos que você queira salvar
    });
  }

}
