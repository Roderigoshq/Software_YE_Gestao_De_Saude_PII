import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isTyping = true;
  late TextEditingController chatTextField = TextEditingController();

  @override
  void initState() {
    chatTextField = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    chatTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromARGB(255, 153, 153, 153),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/Logo_gestao_de_saude 2.png',
              width: 35,
              height: 35,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              'FAC - YE Gestão De Saúde',
              style: TextStyle(
                  color: Color.fromRGBO(136, 149, 83, 1),
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const Text(
                    'Hello',
                    style: TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Color.fromARGB(255, 143, 143, 143),
                size: 18,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: TextField(
                              style: const TextStyle(
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  fontSize: 20),
                              controller: chatTextField,
                              onSubmitted: (value) {},
                              decoration: InputDecoration(
                                hintText: 'Digite sua duvida...',
                                hintStyle: TextStyle(
                                    color:
                                        const Color.fromRGBO(155, 155, 155, 1),
                                    fontSize: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                      color: Colors.black), // Cor da borda
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
