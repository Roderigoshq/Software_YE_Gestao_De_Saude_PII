import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/firebase_options.dart';
import 'package:sc_ye_gestao_de_saude/pages/home_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/loading_page.dart';
import 'package:sc_ye_gestao_de_saude/pages/medication_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
