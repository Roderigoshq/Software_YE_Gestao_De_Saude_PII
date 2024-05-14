import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sc_ye_gestao_de_saude/pages/chat_page.dart';

void main() {
  testWidgets('ChatPage renderizado corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatPage()));

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

    expect(find.text('FAC - YE Gestão De Saúde'), findsOneWidget);

    expect(find.byType(ListView), findsOneWidget);

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}



// Verificou se o ícone de voltar está presente na barra de aplicativos.
// Verificou se o título do aplicativo ("FAC - YE Gestão De Saúde") está presente na barra de aplicativos.
// Verificou se a lista de mensagens está presente na página.
// Verificou se o widget de entrada de texto (campo de texto) e o botão de envio de mensagem estão presentes na interface do usuário.
