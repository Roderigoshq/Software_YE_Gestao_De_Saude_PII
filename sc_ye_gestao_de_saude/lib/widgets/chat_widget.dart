import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key, required this.message, required this.chatIndex})
      : super(key: key);

  final String message;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: chatIndex == 0
          ? EdgeInsets.only(right: 20.0)
          : EdgeInsets.only(left: 20.0),
      child: Align(
        alignment:
            chatIndex == 0 ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: chatIndex == 0
                  ? Text(
                      'You',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Color.fromRGBO(78, 78, 78, 1)),
                    )
                  : Row(
                      children: [
                        Image.asset(
                          'lib/assets/Logo_gestao_de_saude 2.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          'YE Gestão De Saúde',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Color.fromRGBO(78, 78, 78, 1)),
                        ),
                      ],
                    ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Color.fromRGBO(233, 233, 233, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  message,
                  style: TextStyle(
                      color: Color.fromRGBO(86, 86, 86, 1),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
