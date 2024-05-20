import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/login_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/register_options.dart';

class InitialBanner extends StatelessWidget {
  const InitialBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/FirstPage (1).png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned text
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Escaneie seus",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(44, 45, 36, 1),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "próprios ",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(44, 45, 36, 1),
                        ),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      Text(
                        "exames",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(44, 45, 36, 1),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Positioned buttons
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterOptions(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          foregroundColor: Color.fromRGBO(96, 105, 60, 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Criar conta',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(96, 105, 60, 1),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5), // Add a SizedBox for spacing
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromRGBO(96, 105, 60, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
