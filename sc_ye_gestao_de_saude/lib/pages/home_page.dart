import 'package:fake_cloud_firestore/src/fake_cloud_firestore_instance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/camera.dart';
import 'package:sc_ye_gestao_de_saude/pages/chat_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/consult_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/data_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/medication_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DadosPage(),
    Consult(),
    DadosPage(),
    MedicationPage(),
    DadosPage(),
    CameraScreen()
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user != null ? user.displayName?.split(' ')[0] ?? '' : '';
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
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
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          child: SizedBox(
            width: 75, // Largura desejada
            height: 75, // Altura desejada
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Color(0xFF8F8F8F), // Cor de fundo do botão
              child: Icon(
                Icons.document_scanner_rounded,
                size: 35, // Tamanho do ícone
                color: Colors.white, // Cor do ícone
              ),
              shape: CircleBorder(),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromRGBO(136, 149, 83, 1),
          unselectedItemColor: Color.fromRGBO(149, 149, 149, 1),
          items: const [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(
                      10, 0, 0, 0), // Define o padding desejado para o ícone
                  child: Icon(Icons.person_outline),
                ),
                label: 'Meus Dados'),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_rounded),
              label: 'Consultas',
            ),
            BottomNavigationBarItem(
              icon: Icon(null),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_rounded),
              label: 'Medicações',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(Icons.monitor_heart_sharp),
              ),
              label: 'Exames ',
            ),
          ],
        ),
      ),
    );
  }
}
