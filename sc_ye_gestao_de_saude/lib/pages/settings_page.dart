import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_date_birth_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_name_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_password_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_surname_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<SettingsPage> {
  String nome = '';
  String sobrenome = '';
  String email = '';
  String dataNascimento = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('usuarios').child(user.uid);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          setState(() {
            nome = snapshot.child('nome').value?.toString() ?? 'N/A';
            sobrenome = snapshot.child('sobrenome').value?.toString() ?? 'N/A';
            email = snapshot.child('email').value?.toString() ?? 'N/A';
            dataNascimento =
                snapshot.child('dataNascimento').value?.toString() ?? 'N/A';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Color.fromARGB(255, 104, 104, 104),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: Center(
          child: Text(
            "Account Settings",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Color.fromARGB(255, 252, 252, 252),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNamePage(),
                          )),
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Nome",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(85, 85, 85, 1),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            nome,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeSurnamePage(),
                        ),
                      ),
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Sobrenome",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(85, 85, 85, 1),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            sobrenome,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => {},
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Email",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(85, 85, 85, 1),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            email,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(85, 85, 85, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(),
                          )),
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Senha",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(85, 85, 85, 1),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Mudar senha',
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeBirthdatePage(),
                          )),
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Data de nascimento",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(85, 85, 85, 1),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            dataNascimento,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
