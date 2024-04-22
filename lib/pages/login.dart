import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 25),
            color: Colors.white,
            child: const Center(
              child: Text(
                "YE Gestão De Saúde",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 21,
                  color: Color.fromRGBO(136, 149, 83, 1),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 45),
            color: Colors.white,
            child: Center(
              child: Image.asset(
                'lib/assets/Logo_gestao_de_saude.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
