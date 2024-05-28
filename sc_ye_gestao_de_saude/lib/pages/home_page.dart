import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/exams_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/camera_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/consultation_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/data_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/medication_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  static final List<Widget> _pages = <Widget>[
    const DadosPage(),
    const ConsultationPage(),
    const CameraScreen(),
    const MedicationPage(),
    const ExamPage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

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
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color(0xFFC6D687),
              ),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: _pages.asMap().map((index, page) {
          return MapEntry(
            index,
            Offstage(
              offstage: _selectedIndex != index,
              child: Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => page,
                  );
                },
              ),
            ),
          );
        }).values.toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 75,
        height: 75,
        child: FloatingActionButton(
          onPressed: () {
            _navigatorKeys[_selectedIndex].currentState!.push(
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            );
          },
          backgroundColor: const Color(0xFF8F8F8F),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.document_scanner_rounded,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(136, 149, 83, 1),
        unselectedItemColor: const Color.fromRGBO(149, 149, 149, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Icon(Icons.person_outline),
            ),
            label: 'Meus Dados',
          ),
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
    );
  }
}
