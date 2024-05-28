import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/success_popup.dart';
import 'package:sc_ye_gestao_de_saude/pages/settings_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    void resetPassword() {
      String email = emailController.text.trim();
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) async {
        showDialog(
          context: context,
          builder: (context) {
            return const SuccessPopup(
              message: 'Email para redefinição de senha enviado!',
            );
          },
        );
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pop(context);

        Navigator.of(context).pop();
        
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DatabaseReference userRef = FirebaseDatabase.instance
              .reference()
              .child('usuarios')
              .child(user.uid);
          userRef.update({'senha': 'nova_senha'}).then((_) {
            print('Senha atualizada no Realtime Database.');
          }).catchError((error) {
            print('Erro ao atualizar a senha no Realtime Database: $error');
          });
        }
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: const Text(
                  'Não foi possível enviar o email de redefinição de senha. Por favor, verifique o endereço de email e tente novamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color.fromARGB(255, 104, 104, 104),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        title: const Center(
          child: Text(
            "Mudar sua senha",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Color.fromARGB(255, 104, 104, 104),
            ),
          ),
        ),
        actions: const [
          SizedBox(width: 45),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Altere sua senha:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 104, 104, 104),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(136, 149, 83, 1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Através do seu e-mail, você redefinirá sua senha",
              style: TextStyle(
                  color: Color.fromARGB(255, 146, 146, 146),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  'Redefinir Senha',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
