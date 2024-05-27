import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/pages/camera_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/consultation_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/data_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/exams_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/medication_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/settings_page.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_details_modal.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_modal.dart';

class ConsultationDetails extends StatefulWidget {
  final String specialty;
  final List<ConsultationModel> consultations;

  ConsultationDetails({required this.specialty, required this.consultations});

  @override
  _ConsultationDetailsState createState() => _ConsultationDetailsState();
}

class _ConsultationDetailsState extends State<ConsultationDetails> {
    int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    DadosPage(),
    ConsultationPage(),
    CameraScreen(),
    MedicationPage(),
    ExamPage(),
  ];

  
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
              Spacer(),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded),
                ),
                SizedBox(width: 20),
                Text(
                  '${widget.specialty} >',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.consultations.length,
              itemBuilder: (context, index) {
                var consultation = widget.consultations[index];
                return ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ConsultationsDetailsModal(
                        specialty: consultation.specialty,
                        doctorName: consultation.doctorName,
                        date: consultation.date,
                        time: consultation.time,
                        description: consultation.description,
                        reminder: consultation.reminder,
                      ),
                    );
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '${consultation.date}',
                      style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(85, 85, 85, 1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          child: SizedBox(
            width: 75,
            height: 75,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraScreen()),
                  );
              },
              backgroundColor: Color(0xFF8F8F8F),
              child: Icon(
                Icons.document_scanner_rounded,
                size: 35,
                color: Colors.white,
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
                      10, 0, 0, 0),
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
    );
  }
}
