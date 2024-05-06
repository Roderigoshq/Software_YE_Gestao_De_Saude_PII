import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  const SuccessPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 60, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'Cadastro realizado com sucesso!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
