import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sc_ye_gestao_de_saude/pages/about_us.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/login_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/form_screen.dart';
import 'package:sc_ye_gestao_de_saude/pages/politica.dart';
import 'package:sc_ye_gestao_de_saude/pages/register.dart';

class CadastroOptions extends StatelessWidget {
  const CadastroOptions({super.key});

  // GOOGLE

  Future<void> loginWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Sucesso ao fazer login com o Google
        // Você pode prosseguir com o que deseja fazer após o login bem-sucedido
        // Por exemplo, navegar para a próxima tela
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Cancelado pelo usuário
        print('Login com Google cancelado.');
      }
    } catch (error) {
      // Tratar erros de autenticação do Google
      print('Erro ao fazer login com o Google: $error');
    }
  }

  // FACEBOOK

  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      final permissions = ['email', 'public_profile'];
      final LoginResult result =
          await FacebookAuth.instance.login(permissions: permissions);

      if (result.status == LoginStatus.success) {
        // Sucesso ao fazer login com o Facebook
        // Faça o que precisar aqui, como navegar para a próxima tela
      } else {
        // O usuário cancelou o login ou ocorreu um erro
        print('Login com Facebook cancelado ou falhou.');
      }
    } catch (error) {
      // Tratar erros de autenticação do Facebook
      print('Erro ao fazer login com o Facebook: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final double bodyPadding = screenSize.width < 560 ? 25.0 : 100.0;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(bodyPadding, 0, bodyPadding, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
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
                            backgroundColor: Colors.white,
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
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(73, 22, 73, 22),
                            backgroundColor:
                                const Color.fromRGBO(136, 149, 83, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: const Text(
                          "Cadastre-se com seu e-mail",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "ou",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(136, 149, 83, 1),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          loginWithGoogle(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromRGBO(136, 149, 83, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color.fromRGBO(136, 149, 83, 1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: 325,
                          height: 17,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/Google__G__logo 1.png',
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Faça login com ',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'Google',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _loginWithFacebook(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromRGBO(136, 149, 83, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color.fromRGBO(136, 149, 83, 1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: 325,
                          height: 17,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/fb_icon_325x325 (1) 1.png',
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "Faça login com o ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                "Facebook",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromRGBO(136, 149, 83, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color.fromRGBO(136, 149, 83, 1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: 325,
                          height: 17,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/Apple_logo_black 1.png',
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "Faça login com a ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                "Apple ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FormScreen(taskContext: context)),
                          );
                        },
                        child: const Text("medicações")),

                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(),),
                          );
                        },
                        child: const Text("medicações")),
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
                    const SizedBox(
                      height: 5,
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
                            "Política de privacidade",
                            style: TextStyle(
                              color: Color.fromRGBO(136, 149, 83, 1),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              fontSize: 12,
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
      ),
    );
  }
}
