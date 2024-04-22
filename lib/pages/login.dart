import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key}); // Corrigindo o construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                "YE Gestão De Saúde", 
                style: TextStyle(fontFamily: 'Poppins',
                fontSize: 21)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
