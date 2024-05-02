import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user != null ? user.displayName?.split(' ')[0] ?? '' : '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF889553),
        title: Row(
          children: [
            Image.asset(
              'lib/assets/logo.png',
              width: 150,
              height: 150,
            ),
            Spacer(),
            IconButton(
              icon: const Icon(
                Icons.info,
                color: Color(0xFFC6D687),
              ),
              iconSize: 30,
              onPressed: () {
                // Ação ao clicar no ícone de informação
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color(0xFFC6D687),
              ),
              iconSize: 30,
              onPressed: () {
                // Ação ao clicar no ícone de configuração
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: 80,
        padding: const EdgeInsets.fromLTRB(40, 35, 40, 0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Olá, ",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 22),
                    ),
                    Text(
                      "$userName!",
                      style: const TextStyle(
                          color: Color.fromRGBO(136, 149, 83, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  ],
                ),
                const Text(
                  "Veja seus dados abaixo",
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Spacer(),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors
                            .transparent, // Define o fundo como transparente
                        child: InteractiveViewer(
                          child: Image.asset(
                            'lib/assets/3106921 2.png',
                            height: 300,
                            width: 300,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset('lib/assets/3106921 2.png',
                    height: 60, width: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
