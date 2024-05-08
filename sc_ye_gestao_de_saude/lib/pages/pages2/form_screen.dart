import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/initial_screen.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Exit'),
              ),
            ),
          ],
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


// class FormScreen extends StatefulWidget {
//   const FormScreen({Key? key, required this.taskContext});

//   final BuildContext taskContext;

//   @override
//   State<FormScreen> createState() => _FormScreenState();
// }

// class _FormScreenState extends State<FormScreen> {
//   late DateTime selectedDateTime = DateTime.now(); // Data selecionada inicialmente

//   TextEditingController nameController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   bool valueValidator(String? value) {
//     if (value != null && value.isEmpty) {
//       return true;
//     }
//     return false;
//   }

//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? pickedDateTime = await showDatePicker(
//       context: context,
//       initialDate: selectedDateTime,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDateTime != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(selectedDateTime),
//       );

//       if (pickedTime != null) {
//         setState(() {
//           selectedDateTime = DateTime(
//             pickedDateTime.year,
//             pickedDateTime.month,
//             pickedDateTime.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF889553),
//           title: Row(
//             children: [
//               Spacer(),
//               IconButton(
//                 icon: const Icon(Icons.info, color: Color(0xFFC6D687)),
//                 iconSize: 30,
//                 onPressed: () {
//                   // Ação ao clicar no ícone de informação
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings, color: Color(0xFFC6D687)),
//                 iconSize: 30,
//                 onPressed: () {
//                   // Ação ao clicar no ícone de configuração
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               width: 350,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 3,
//                     blurRadius: 7,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Adicionar Medicamento',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   InkWell(
//                     onTap: () => _selectDateTime(context),
//                     child: InputDecorator(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Data e Hora',
//                         prefixIcon: Icon(Icons.calendar_today),
//                       ),
//                       child: Text(
//                         "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute}",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: nameController,
//                     validator: (value) {
//                       if (valueValidator(value)) {
//                         return 'Insira o nome do medicamento';
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Nome do Medicamento',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // ElevatedButton(
//                   //   onPressed: () {
//                   //     if (_formKey.currentState!.validate()) {
//                   //       TaskInherited.of(widget.taskContext).newTask(
//                   //         selectedDateTime.toString(),
//                   //         '',
//                   //         0,
//                   //       );
//                   //       ScaffoldMessenger.of(context).showSnackBar(
//                   //         const SnackBar(
//                   //           content: Text('Criando uma nova medicação'),
//                   //         ),
//                   //       );
//                   //       Navigator.pop(context);
//                   //     }
//                   //   },
//                   //   child: const Text('Salvar'),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }