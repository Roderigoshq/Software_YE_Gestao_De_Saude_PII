import 'package:flutter/material.dart';
import 'package:ye_gestao_de_saude/pages/login.dart';
import 'package:ye_gestao_de_saude/pages/loginPage.dart';
import 'package:ye_gestao_de_saude/services/auth_service.dart';
import 'package:ye_gestao_de_saude/comumpath/snackbar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _sobrenomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _repetirSenhaController = TextEditingController();

  AuthService _autenServico = AuthService();
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
        child: Column(
          children: [
            const Text(
              "YE Gestão De Saúde",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 21,
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'lib/assets/Logo_gestao_de_saude.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _sobrenomeController,
                          decoration: const InputDecoration(
                            labelText: 'Sobrenome',
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
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
                      labelText: 'Senha',
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
                          _senhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                  const SizedBox(height: 15),
                  TextField(
                    controller: _repetirSenhaController,
                    decoration: const InputDecoration(
                      labelText: 'Repetir Senha',
                      labelStyle: TextStyle(fontSize: 14),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(196, 196, 196, 1),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(129, 146, 60, 1),
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      String nome = _nomeController.text;
                      String sobrenome = _sobrenomeController.text;
                      String email = _emailController.text;
                      String senha = _senhaController.text;
                      String repetirSenha = _repetirSenhaController.text;

                      // Cadastrar usuário
                      await _autenServico
                          .cadastrarUsuario(
                        nome: nome,
                        sobrenome: sobrenome,
                        email: email,
                        senha: senha,
                        repetirSenha: repetirSenha,
                      )
                          .then((String? erro) {
                        if (erro != null) {
                          showSnackBar(context: context, texto: erro);
                        } else {
                          showSnackBar(
                            context: context,
                            texto: "Cadastro feito com sucesso!",
                            isErro: false,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      });
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
                      "Cadastrar",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Já tem uma conta? ",
                        style: TextStyle(
                          color: Color.fromRGBO(110, 110, 110, 1),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Entrar",
                            style: TextStyle(
                              color: Color.fromRGBO(136, 149, 83, 1),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
