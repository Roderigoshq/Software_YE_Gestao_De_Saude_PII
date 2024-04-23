import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';

class CadastroOptions extends StatelessWidget {
  const CadastroOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final double bodyPadding = screenSize.width < 560 ? 20.0 : 100.0;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(bodyPadding, 60, bodyPadding, 0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center, // Use se necessário
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
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(73, 22, 73, 22),
                    backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromRGBO(136, 149, 83, 1),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromRGBO(136, 149, 83, 1),
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
                  foregroundColor: const Color.fromRGBO(136, 149, 83, 1),
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
                        MaterialPageRoute(builder: (context) => const Login()),
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
              margin: const EdgeInsets.fromLTRB(0, 55, 0, 7),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Veja mais ",
                    style: TextStyle(
                        color: Color.fromRGBO(110, 110, 110, 1),
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "sobre nós",
                    style: TextStyle(
                      color: Color.fromRGBO(136, 149, 83, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Termos e condições      ",
                  style: TextStyle(
                    color: Color.fromRGBO(136, 149, 83, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    fontSize: 8,
                  ),
                ),
                Text(
                  "política de privacidade",
                  style: TextStyle(
                    color: Color.fromRGBO(136, 149, 83, 1),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    fontSize: 8,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
