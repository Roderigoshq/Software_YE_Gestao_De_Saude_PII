import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart';
import 'package:sc_ye_gestao_de_saude/components/success_popup.dart';
import 'package:sc_ye_gestao_de_saude/pages/about_us_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/login_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/politica.dart';
import 'package:sc_ye_gestao_de_saude/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _repetirSenhaController = TextEditingController();

  final databaseReference =
      FirebaseDatabase.instance.reference().child('usuarios');

  final AuthService _autenServico = AuthService();
  bool _senhaVisivel = false;
  bool _repetirSenhaVisivel = false;
  late DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedDate = null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color.fromRGBO(136, 149, 83, 1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String nome = _nomeController.text;
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
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome*',
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
                  TextField(
                    controller: _sobrenomeController,
                    decoration: const InputDecoration(
                      labelText: 'Sobrenome*',
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
                  const SizedBox(height: 5),
                  const Text(
                    "Insira um email válido.",
                    style: TextStyle(color: Color.fromRGBO(172, 172, 172, 1)),
                  ),
                  const SizedBox(height: 5),
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
                    obscureText: !_senhaVisivel,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Sua senha deve conter no mínimo 8 caracteres, um caracter especial, número e letra maiúscula*",
                    style: TextStyle(color: Color.fromRGBO(172, 172, 172, 1)),
                  ),
                  TextField(
                    controller: _repetirSenhaController,
                    decoration: InputDecoration(
                      labelText: 'Repetir Senha*',
                      labelStyle: const TextStyle(fontSize: 14),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(196, 196, 196, 1),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(129, 146, 60, 1),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _repetirSenhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _repetirSenhaVisivel = !_repetirSenhaVisivel;
                          });
                        },
                      ),
                    ),
                    obscureText: !_repetirSenhaVisivel,
                  ),
                  TextField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? _dateFormat.format(_selectedDate!)
                          : '',
                    ),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.blue),
                      labelText: 'Data de nascimento*',
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      // Verifique se todos os campos estão preenchidos
                      if (_nomeController.text.isEmpty ||
                          _sobrenomeController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _senhaController.text.isEmpty ||
                          _repetirSenhaController.text.isEmpty) {
                        showSnackBar(
                          context: context,
                          texto: "Há campos não preenchidos",
                        );
                        return;
                      }

                      String nome = _nomeController.text;
                      String sobrenome = _sobrenomeController.text;
                      if (nome.isNotEmpty || sobrenome.isNotEmpty) {
                        sobrenome =
                            sobrenome[0].toUpperCase() + sobrenome.substring(1);
                        nome = nome[0].toUpperCase() + nome.substring(1);
                      }

                      String? mensagemErro =
                          await _autenServico.cadastrarUsuario(
                        nome: nome,
                        sobrenome: sobrenome,
                        email: _emailController.text,
                        senha: _senhaController.text,
                        repetirSenha: _repetirSenhaController.text,
                        context: context,
                      );

                      if (mensagemErro == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SuccessPopup(
                              message: 'Cadastro feito com sucesso!',
                            );
                          },
                        );

                        // Aguarde 2 segundos antes de fechar o popup
                        await Future.delayed(Duration(seconds: 2));

                        // Feche o popup
                        Navigator.pop(context);

                        // Obtém o ID único gerado pelo Firebase Authentication
                        String? userId = _autenServico.getCurrentUserUid();

                        // Verifica se o ID do usuário é válido
                        if (userId != null) {
                          // Salva os dados do usuário no Realtime Database usando o ID gerado pelo Firebase Authentication como chave
                          try {
                            await databaseReference.child(userId).set({
                              'nome': nome,
                              'sobrenome': sobrenome,
                              'email': _emailController.text,
                              'dataNascimento': _selectedDate != null
                                  ? _dateFormat.format(_selectedDate!)
                                  : '',
                            });

                            // Exibe uma mensagem de sucesso
                            showSnackBar(
                              context: context,
                              texto: "Para fazer login, verifique seu email!",
                              isErro: false,
                            );

                            // Navegue de volta para a tela de login
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          } catch (error) {
                            // Se ocorrer um erro ao salvar os dados do usuário, exiba uma mensagem de erro
                            showSnackBar(
                              context: context,
                              texto: "Erro ao cadastrar usuário: $error",
                            );
                          }
                        } else {
                          // Se o ID do usuário for inválido, exiba uma mensagem de erro
                          showSnackBar(
                            context: context,
                            texto: "ID do usuário inválido",
                          );
                        }
                      } else {
                        // Se houver uma mensagem de erro, exiba a mensagem de erro
                        showSnackBar(context: context, texto: mensagemErro);
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
                                builder: (context) => LoginPage(),
                              ),
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 80, 0, 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Veja mais ",
                              style: TextStyle(
                                color: Color.fromRGBO(110, 110, 110, 1),
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUsPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "sobre nós",
                                style: TextStyle(
                                  color: Color.fromRGBO(136, 149, 83, 1),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsOfUsePage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Termos e condições",
                                style: TextStyle(
                                  color: Color.fromRGBO(136, 149, 83, 1),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                            const Text(
                              "      ",
                              style: TextStyle(fontSize: 8),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                "política de privacidade",
                                style: TextStyle(
                                  color: Color.fromRGBO(136, 149, 83, 1),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  fontSize: 8,
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
          ],
        ),
      ),
    );
  }
}
