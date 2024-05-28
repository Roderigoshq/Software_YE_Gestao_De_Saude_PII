import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart';
import 'package:sc_ye_gestao_de_saude/components/success_popup.dart';
import 'package:sc_ye_gestao_de_saude/pages/settings_page.dart';

class ChangeSurnamePage extends StatefulWidget {
  const ChangeSurnamePage({super.key});

  @override
  ChangeSurnamePageState createState() => ChangeSurnamePageState();
}

class ChangeSurnamePageState extends State<ChangeSurnamePage> {
  final TextEditingController _surnameController = TextEditingController();
  String sobrenome = '';

  @override
  void initState() {
    super.initState();
    _fetchUserSurname();
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _fetchUserSurname() async {
    try {
      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('usuarios').child(user!.uid);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          setState(() {
            sobrenome = snapshot.child('sobrenome').value?.toString() ?? 'N/A';
          });
        } else {
          print('No data available for the user.');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('An error occurred while fetching user data: $e');
    }
  }

  _updateSurname() {
    String surname = _surnameController.text.trim();
    if (surname.isEmpty) {
      return showSnackBar(
        context: context,
        texto: "O campo não está preenchido",
      );
    } else {
      String newSurname = surname
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');

      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('usuarios').child(user!.uid);
        userRef.update({'sobrenome': newSurname}).then((_) async {
          setState(() {
            sobrenome = newSurname;
          });
          showDialog(
            context: context,
            builder: (context) {
              return const SuccessPopup(
                message: 'Sobrenome atualizado!',
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
        }).catchError((error) {
          print('Erro ao atualizar o sobrenome no Realtime Database: $error');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "Mudar seu sobrenome",
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
            Row(
              children: [
                const Text(
                  'Sobrenome atual: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 104, 104, 104),
                      fontSize: 15),
                ),
                Text(
                  sobrenome,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 104, 104, 104),
                      fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(
                labelText: 'Novo sobrenome',
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
            const SizedBox(height: 5),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                onPressed: _updateSurname,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  'Redefinir Sobrenome',
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
