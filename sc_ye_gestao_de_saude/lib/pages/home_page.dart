import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/custom_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
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
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "$userName!",
                            style: const TextStyle(
                              color: Color.fromRGBO(136, 149, 83, 1),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Veja seus dados abaixo",
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
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
                              backgroundColor: Colors.transparent,
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
                      child: Image.asset(
                        'lib/assets/3106921 2.png',
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TabBar(
              indicatorColor: Color.fromRGBO(136, 149, 83, 1),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Color.fromRGBO(136, 149, 83, 1),
              unselectedLabelColor: Color.fromRGBO(149, 149, 149, 1),
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                CustomTab(text: 'Pressão', subText: '150x100'),
                CustomTab(text: 'Glicemia', subText: '85mg/Dl'),
                CustomTab(text: 'Peso & Altura', subText: '90kg; 1,70m'),
                CustomTab(text: 'IMC', subText: '31,4'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Conteúdo da aba Pressão
                  Center(
                    child: Container(
                      color: Color.fromRGBO(248, 248, 248, 1),
                      child: Text('Conteúdo da aba Pressão'),
                    ),
                  ),
                  // Conteúdo da aba Glicemia
                  Center(
                    child: Container(
                      color: Color.fromRGBO(248, 248, 248, 1),
                      child: Text('Conteúdo da aba Glicemia'),
                    ),
                  ),
                  // Conteúdo da aba Peso & Altura
                  Center(
                    child: Container(
                      color: Color.fromRGBO(248, 248, 248, 1),
                      child: Text('Conteúdo da aba Peso & Altura'),
                    ),
                  ),
                  // Conteúdo da aba IMC
                  Center(
                    child: Container(
                      color: Color.fromRGBO(248, 248, 248, 1),
                      child: Text('Conteúdo da aba IMC'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xFF8F8F8F), // Cor de fundo do botão
          child: Icon(
            Icons.document_scanner_rounded,
            color: Colors.white, // Cor do ícone
          ),
          shape: CircleBorder(),
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
              icon: Icon(Icons.person_outline),
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
              icon: Icon(Icons.monitor_heart_sharp),
              label: 'Exames',
            ),
          ],
        ),
      ),
    );
  }
}
