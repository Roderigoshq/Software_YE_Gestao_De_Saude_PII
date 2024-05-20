import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUsuario({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String repetirSenha,
    required BuildContext context,
  }) async {
    try {
      if (senha == repetirSenha) {
        if (senha.length < 8) {
          return "A senha deve ter no mínimo 8 caracteres";
        } else if (!senha.contains(RegExp(r'[0-9]'))) {
          return "A senha deve conter pelo menos um número. (Exemplo: 1, 2, 3)";
        } else if (!senha.contains(RegExp(r'[A-Z]'))) {
          return "A senha deve conter pelo menos uma letra maiúscula. (Exemplo: A, B, C)";
        } else if (!senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          return "A senha deve conter pelo menos um caractere especial.  (Exemplo: @, #, %)";
        }

        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nome)) {
          return "Por favor, insira um nome válido";
        }
        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(sobrenome)) {
          return "Por favor, insira um sobrenome válido";
        }

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: senha,
        );

        await userCredential.user!.updateDisplayName('$nome $sobrenome');
        await userCredential.user!.sendEmailVerification();

        return null;
      } else {
        return "As senhas não estão iguais!";
      }
    } on FirebaseAuthException catch (e) {
      if (nome.isEmpty ||
          sobrenome.isEmpty ||
          email.isEmpty ||
          senha.isEmpty ||
          repetirSenha.isEmpty) {
        return "Há campos que não estão preenchidos";
      } else if (e.code == "email-already-in-use") {
        return "O usuário já está cadastrado!";
      } else if (!email.contains('@')) {
        return "Por favor, insira um endereço de e-mail válido.";
      }
      return e.message;
    } catch (e) {
      return "Erro ao cadastrar usuário. Por favor, tente novamente mais tarde.";
    }
  }

  Future<String?> login({required String email, required String senha}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!userCredential.user!.emailVerified) {
        return 'Email não verificado. Por favor, verifique seu e-mail ou caixa de Spam e tente novamente.';
      }

      return null; // Login bem-sucedido
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o e-mail digitado.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        default:
          return e.message;
      }
    } catch (e) {
      return "Erro ao fazer login. Por favor, tente novamente mais tarde.";
    }
  }

  String? getCurrentUserUid() {
    User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
