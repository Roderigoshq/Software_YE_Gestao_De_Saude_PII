import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/success_popup.dart';
import 'package:sc_ye_gestao_de_saude/pages/settings_page.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    void _resetPassword() {
      String email = _emailController.text.trim();
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) async {
        showDialog(
          context: context,
          builder: (context) {
            return SuccessPopup(
              message: 'Email para redefinição de senha enviado!',
            );
          },
        );
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
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
              title: Text('Erro'),
              content: Text(
                  'Não foi possível enviar o email de redefinição de senha. Por favor, verifique o endereço de email e tente novamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
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
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Color.fromARGB(255, 104, 104, 104),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        title: Center(
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
        actions: [
          SizedBox(width: 45),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Altere sua senha:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 104, 104, 104),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
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
            SizedBox(
              height: 5,
            ),
            Text(
              "Através do seu e-mail, você redefinirá sua senha",
              style: TextStyle(
                  color: const Color.fromARGB(255, 146, 146, 146),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(136, 149, 83, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
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
