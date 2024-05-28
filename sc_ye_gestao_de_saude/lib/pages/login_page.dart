import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart';
import 'package:sc_ye_gestao_de_saude/pages/forgot_password.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';
import 'package:sc_ye_gestao_de_saude/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _senhaVisivel = false;
  bool _manterConectado = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _manterConectado = prefs.getBool('manterConectado') ?? false;
      if (_manterConectado) {
        _emailController.text = prefs.getString('email') ?? '';
        _senhaController.text = prefs.getString('senha') ?? '';
      }
    });
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('manterConectado', _manterConectado);
    if (_manterConectado) {
      prefs.setString('email', _emailController.text);
      prefs.setString('senha', _senhaController.text);
    } else {
      prefs.remove('email');
      prefs.remove('senha');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color.fromARGB(255, 104, 104, 104),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
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
            padding: const EdgeInsets.fromLTRB(45, 0, 45, 20),
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
                  obscureText: !_senhaVisivel,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _manterConectado,
                      onChanged: (value) {
                        setState(() {
                          _manterConectado = value!;
                        });
                      },
                      activeColor: const Color.fromRGBO(136, 149, 83, 1),
                    ),
                    const Text(
                      'Mantenha-me conectado',
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                      color: Color.fromRGBO(136, 149, 83, 1),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String senha = _senhaController.text;

                    String? errorMessage = await _authService.login(
                      email: email,
                      senha: senha,
                    );

                    if (errorMessage == null) {
                      _savePreferences();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } else {
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
