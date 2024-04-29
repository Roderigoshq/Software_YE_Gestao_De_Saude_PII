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
      if (senha == repetirSenha) {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: senha,
        );

        await userCredential.user!.updateDisplayName('$nome $sobrenome');
        // await userCredential.user!.sendEmailVerification();
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
      } else if (senha.length < 7) {
        return "A senha deve ter no mínimo 8 caracteres";
      }
      return e
          .message; // Retorna a mensagem de erro da exceção FirebaseAuthException
    } catch (e) {
      // Captura exceções não tratadas e exibe uma mensagem genérica
      print("Erro ao cadastrar usuário: $e");
      return "Erro ao cadastrar usuário. Por favor, tente novamente mais tarde.";
    }
  }

  Future<String?> login({required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return null; // Login bem-sucedido
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o e-mail digitado.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        default:
          return e.message; // Retornar mensagem padrão para outros erros
      }
    } catch (e) {
      print("Erro ao fazer login: $e");
      return "Erro ao fazer login. Por favor, tente novamente mais tarde.";
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
