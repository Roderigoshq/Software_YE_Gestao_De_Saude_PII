 import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/form_screen.dart';


class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<InitialScreen> {
  void _openIconButtonPressed() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => FormScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('App Bar'),
        actions: [
          IconButton(
            onPressed: _openIconButtonPressed,
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home screen',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}


// class InitialScreen extends StatefulWidget {
//   const InitialScreen({Key? key}) : super(key: key);

//   @override
//   State<InitialScreen> createState() => _InitialScreenState();
// }

// class _InitialScreenState extends State<InitialScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFF889553),
//         title: Row(
//           children: [
//             Image.asset(
//               'lib/assets/logo.png',
//               width: 150,
//               height: 150,
//             ),
//             Spacer(),
//             IconButton(
//               icon: const Icon(Icons.info, color: Color(0xFFC6D687)),
//               iconSize: 30,
//               onPressed: () {
//                 // Ação ao clicar no ícone de informação
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.settings, color: Color(0xFFC6D687)),
//               iconSize: 30,
//               onPressed: () {
//                 // Ação ao clicar no ícone de configuração
//               },
//             ),
//           ],
//         ),
//       ),
//       body: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(40.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Tome sempre seus ',
//                   style: TextStyle(fontSize: 22),
//                 ),
//                 Text(
//                   'medicamentos:',
//                   style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
//                 ),
//                 // Aqui você pode adicionar widgets adicionais para exibir a lista de
//                 // medicamentos ou outras informações relevantes.
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: ClipOval(
//   child: FloatingActionButton(
//     onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (contextNew) => FormScreen(taskContext: context),
//         ),
//       );
//     },
//     child: const Icon(Icons.add, color: Colors.white),
//     backgroundColor: const Color(0xFFC6D687), // Alteração da cor de fundo
//   ),
// ),
//     );
//   }
// }