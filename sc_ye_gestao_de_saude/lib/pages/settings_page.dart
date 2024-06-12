import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_date_birth_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_name_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_password_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/change_surname_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/initial_banner_page.dart';
import 'package:sc_ye_gestao_de_saude/services/auth_service.dart';
import 'package:sc_ye_gestao_de_saude/services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<SettingsPage> {
  String nome = '';
  String sobrenome = '';
  String email = '';
  String dataNascimento = '';
  Uint8List? pickedImage;
  StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    getProfilePicture();
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String uid = user.uid;
    final String fileName = 'profilephotos/$uid/profilephoto.png';

    await storage.uploadFile(fileName, image);

    final imageBytes = await image.readAsBytes();
    setState(() => pickedImage = imageBytes);
  }

  Future<void> getProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String uid = user.uid;
    final String fileName = 'profilephotos/$uid/profilephoto.png';

    final imageBytes = await storage.getFile(fileName);
    if (imageBytes != null) {
      setState(() => pickedImage = imageBytes);
    }
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

  AuthService authService = AuthService();

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
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Center(
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
          const SizedBox(width: 45),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 252, 252, 252),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Stack(
                    children: [
                      GestureDetector(
  onTap: onProfileTapped,
  child: Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 209, 209, 209),
      shape: BoxShape.circle,
    ),
    child: ClipOval(
      child: pickedImage != null
          ? Image.memory(
              pickedImage!,
              fit: BoxFit.cover, // Garantir que a imagem preencha todo o círculo
              width: 100,
              height: 100,
            )
          : const Center(
              child: Icon(
                Icons.person_rounded,
                size: 80, // Tamanho do ícone
                color: Colors.white, // Cor do ícone
              ),
            ),
    ),
  ),
),
                      Positioned(
                        bottom: -10,
                        left: 60,
                        child: IconButton(
                          onPressed: onProfileTapped,
                          icon: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                9), 
                            child: Icon(
                              Icons.edit,
                              color: const Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeNamePage(),
                          )),
                    },
                    title: Row(
                      children: [
                        const Expanded(
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
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        const Icon(
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
                        const Expanded(
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
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        const Expanded(
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
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            email,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(
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
                            builder: (context) => const ChangePasswordPage(),
                          )),
                    },
                    title: const Row(
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
                            builder: (context) => const ChangeBirthdatePage(),
                          )),
                    },
                    title: Row(
                      children: [
                        const Expanded(
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
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            dataNascimento,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF889553),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.logOut();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InitialBanner()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      foregroundColor: const Color.fromARGB(255, 241, 65, 65),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Define a largura máxima
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 241, 65, 65),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirmar',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 66, 66, 66)),
                            ),
                            content: const Text(
                                'Tem certeza de que deseja deletar sua conta?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(85, 85, 85, 1)),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Deletar',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color.fromRGBO(255, 41, 41, 1),
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        await authService.deleteAccount();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InitialBanner()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 241, 65, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Define a largura máxima
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      'Deletar minha conta',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
