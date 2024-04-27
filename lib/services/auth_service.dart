import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUsuario({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String repetirSenha,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await userCredential.user!.updateDisplayName('$nome $sobrenome');
      await userCredential.user!.sendEmailVerification();

      return null;
    } on FirebaseAuthException catch (e) {
      if (nome.isEmpty ||
          sobrenome.isEmpty ||
          email.isEmpty ||
          senha.isEmpty ||
          repetirSenha.isEmpty) {
        return "Há campos que não estão preenchidos";
      } else if (e.code == "email-already-in-use") {
        return "O usuário já está cadastrado!";
      }
      return e
          .message; // Retorna a mensagem de erro da exceção FirebaseAuthException
    } catch (e) {
      // Captura exceções não tratadas e exibe uma mensagem genérica
      print("Erro desconhecido: $e");
      return "Erro desconhecido";
    }
  }

  Future<bool> login({required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return true; // Login bem-sucedido
    } catch (e) {
      // Lidar com erros de login
      print('Erro ao fazer login: $e');
      return false; // Login falhou
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
