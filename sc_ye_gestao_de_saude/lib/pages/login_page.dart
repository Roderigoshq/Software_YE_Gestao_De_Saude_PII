import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/register_options.dart';
import 'package:sc_ye_gestao_de_saude/services/auth_service.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/Task.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/TaskInherited.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/FormScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _repetirSenhaController = TextEditingController();

  final databaseReference =
      FirebaseDatabase.instance.reference().child('usuarios');

  final AuthService _autenServico = AuthService();
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
          Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 20),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email*',
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(196, 196, 196, 1),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 149, 83, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha*',
                    labelStyle: const TextStyle(fontSize: 14),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(196, 196, 196, 1),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 149, 83, 1),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _senhaVisivel = !_senhaVisivel;
                        });
                      },
                    ),
                  ),
                  obscureText:
                      !_senhaVisivel, // Altera a visibilidade da senha com base no estado
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String senha = _senhaController.text;

                    // Aguarde o resultado do método de login
                    String? errorMessage =
                        await _autenServico.login(email: email, senha: senha);

                    // Verifique se o login foi bem-sucedido (sem mensagem de erro)
                    if (errorMessage == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    } else {
                      // Exiba a mensagem de erro ao usuário
                      showSnackBar(
                        context: context,
                        texto: errorMessage,
                        isErro: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(73, 22, 73, 22),
                    backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
