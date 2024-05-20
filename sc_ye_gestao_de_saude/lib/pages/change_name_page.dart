import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/success_popup.dart';
import 'package:sc_ye_gestao_de_saude/pages/settings_page.dart';

class ChangeNamePage extends StatelessWidget {
  const ChangeNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    User? user = FirebaseAuth.instance.currentUser;
    String userName = user != null ? user.displayName?.split(' ')[0] ?? '' : '';

    void _updateName() {
      String name = _nameController.text.trim();
      String newName = name[0].toUpperCase() + name.substring(1);

      User? user = FirebaseAuth.instance.currentUser;
      user!.updateDisplayName('$newName');
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance
            .reference()
            .child('usuarios')
            .child(user.uid);
        userRef.update({'nome': newName}).then((_) {
          showDialog(
            context: context,
            builder: (context) {
              return SuccessPopup(
                message: 'Nome atualizado!',
              );
            },
          );
        }).catchError((error) {
          print('Erro ao atualizar o nome no Realtime Database: $error');
        });
      }
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
            "Mudar seu nome",
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
            Row(
              children: [
                Text(
                  'Nome atual: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 104, 104, 104),
                      fontSize: 25),
                ),
                Text(
                  '$userName',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: const Color.fromARGB(255, 104, 104, 104),
                      fontSize: 25),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Novo nome',
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: _updateName,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(136, 149, 83, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  'Redefinir Nome',
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
