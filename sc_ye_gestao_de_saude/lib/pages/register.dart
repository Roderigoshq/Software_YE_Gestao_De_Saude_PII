import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart';
import 'package:sc_ye_gestao_de_saude/pages/login_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/politica.dart';
import 'package:sc_ye_gestao_de_saude/pages/about_us.dart';
import 'package:sc_ye_gestao_de_saude/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _selectedDate = null; // Inicializando _selectedDate com a data atual
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            // Personalize a cor de fundo da seleção aqui
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color.fromRGBO(
                  136, 149, 83, 1), // Cor de fundo da seleção
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 5),
                  const Text(
                    "Sua senha deve conter no mínimo 8 caracteres, um caracter especial, número e letra maiúscula*",
                    style: TextStyle(color: Color.fromRGBO(172, 172, 172, 1)),
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
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
                      // Verifica se os campos obrigatórios estão preenchidos
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

                      // Transforma o primeiro caractere do nome e sobrenome em maiúscula
                      String nome = _nomeController.text;
                      String sobrenome = _sobrenomeController.text;
                      if (nome.isNotEmpty || sobrenome.isNotEmpty) {
                        sobrenome =
                            sobrenome[0].toUpperCase() + sobrenome.substring(1);
                        nome = nome[0].toUpperCase() + nome.substring(1);
                      }

                      // Chama o método cadastrarUsuario do AuthService
                      String? mensagemErro =
                          await AuthService().cadastrarUsuario(
                        nome: nome,
                        sobrenome: sobrenome,
                        email: _emailController.text,
                        senha: _senhaController.text,
                        repetirSenha: _repetirSenhaController.text,
                      );

                      if (mensagemErro == null) {
                        // Cadastro de usuário bem-sucedido, agora salve os dados no banco de dados
                        String dataNascimento = _selectedDate != null
                            ? _dateFormat.format(_selectedDate!)
                            : '';
                        try {
                          await databaseReference.push().set({
                            'nome': nome,
                            'sobrenome': sobrenome,
                            'email': _emailController.text,
                            'senha': _senhaController.text,
                            'dataNascimento': dataNascimento,
                          });

                          showSnackBar(
                            context: context,
                            texto:
                                "Cadastro feito com sucesso! Verifique seu email!",
                            isErro: false,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        } catch (error) {
                          // Ocorreu um erro ao enviar os dados para o Firebase
                          showSnackBar(
                            context: context,
                            texto: "Erro ao cadastrar usuário: $error",
                          );
                        }
                      } else {
                        // Exiba a mensagem de erro do cadastro do usuário
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
                                      builder: (context) => AboutUsPage()),
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
                                      builder: (context) => TermsOfUsePage()),
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
                              onTap: () {
                                // Navegar para a tela de Política de Privacidade
                              },
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
