import 'package:flutter/material.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(40, 35, 0, 0),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                     Text(
                      "Gerencie suas  ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "consultas:",
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'lib/assets/consulta.png',
                  height: 120,
                  width: 120,
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16),
        ],
      ),
      
      );
  }
}
