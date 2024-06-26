import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationModel {
   String id;
   String doctorName;
   String specialty;
   String time;
   String date;
   String description;
   bool reminder;

  ConsultationModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.date,
    required this.description,
    required this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialty': specialty,
      'time': time,
      'date': date,
      'description': description,
      'reminder': reminder, // Adicionando o campo reminder
    };
  }

  factory ConsultationModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ConsultationModel(
      id: doc.id,
      doctorName: data['doctorName'] ?? '',
      specialty: data['specialty'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
      description: data['description'] ?? '',
      reminder: data['reminder'] ?? false, // Adicionando o campo reminder
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'doctorName': doctorName,
      'specialty': specialty,
      'time': time,
      'date': date,
      'description': description,
      'reminder': reminder, // Adicionando o campo reminder
    };
  }
}

// class ExtensionPanelConsultation extends StatefulWidget {
//   const ExtensionPanelConsultation({Key? key}) : super(key: key);

//   @override
//   State<ExtensionPanelConsultation> createState() => _ExtensionPanelConsultationState();
// }

// class _ExtensionPanelConsultationState extends State<ExtensionPanelConsultation> {
//   final ConsultationService consultationService = ConsultationService();
//   final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<ConsultationModel>>(
//         future: consultationService.fetchConsultationModels(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Color.fromRGBO(136, 149, 83, 1),
//               ),
//             );
//           } else {
//             if (snapshot.hasData) {
//               final consultationModels = snapshot.data!;
//               if (consultationModels.isEmpty) {
//                 return Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'lib/assets/nenhumitem.png',
//                         width: 100,
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Não há nenhuma consulta",
//                         style: TextStyle(
//                             color: Color.fromRGBO(136, 149, 83, 1),
//                             fontFamily: 'Poppins',
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               consultationModels.sort((a, b) {
//                 final DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
//                 final DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
//                 return dateB.compareTo(dateA);
//               });
//               return ListView.builder(
//                 itemCount: consultationModels.length,
//                 itemBuilder: (context, index) {
//                   final consultation = consultationModels[index];
//                   return ExpansionTile(
//                     title: Row(
//                       children: [
//                         Text(
//                           consultation.date,
//                           style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                               color: Color.fromRGBO(85, 85, 85, 1)),
//                         ),
//                         Spacer(),
//                         PopupMenuButton(
//                           itemBuilder: (BuildContext context) {
//                             return <PopupMenuEntry>[
//                               PopupMenuItem(
//                                 child: Center(
//                                     child: Text(
//                                   'Editar',
//                                   style: TextStyle(
//                                       color: Color.fromRGBO(85, 85, 85, 1),
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 15),
//                                 )),
//                                 value: 'edit',
//                               ),
//                               PopupMenuItem(
//                                 child: Center(
//                                     child: Text(
//                                   'Deletar',
//                                   style: TextStyle(
//                                       color: Color.fromRGBO(85, 85, 85, 1),
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 15),
//                                 )),
//                                 value: 'delete',
//                               ),
//                             ];
//                           },
//                           onSelected: (value) async {
//                             if (value == 'edit') {
//                               final updatedConsultation =
//                                   await _showEditConsultationDialog(
//                                       context, consultation);

//                               if (updatedConsultation != null) {
//                                 await consultationService
//                                     .editConsultation(updatedConsultation);
//                                 setState(() {});
//                               }
//                             } else if (value == 'delete') {
//                               await consultationService.deleteConsultation(consultation.id);
//                               setState(() {});
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     trailing: Icon(Icons.expand_more),
//                     children: [
//                       ListTile(
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${consultation.doctorName} - ${consultation.specialty}',
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                   color: Color.fromRGBO(135, 135, 135, 1)),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               consultation.time,
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 15,
//                                   color: Color.fromRGBO(135, 135, 135, 1)),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               consultation.description,
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 15,
//                                   color: Color.fromRGBO(135, 135, 135, 1)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             } else {
//               return Center(
//                 child: Text("Não há nenhuma consulta"),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   Future<ConsultationModel?> _showEditConsultationDialog(
//       BuildContext context, ConsultationModel consultation) async {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController specialtyController = TextEditingController();
//     final TextEditingController timeController = TextEditingController();
//     final TextEditingController dateController = TextEditingController();
//     final TextEditingController descriptionController = TextEditingController();

//     nameController.text = consultation.doctorName;
//     specialtyController.text = consultation.specialty;
//     timeController.text = consultation.time;
//     dateController.text = consultation.date;
//     descriptionController.text = consultation.description;

//     return showDialog<ConsultationModel>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Center(
//             child: Text(
//               'Editar Consulta',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nome do Médico',
//                     labelStyle: TextStyle(fontSize: 14),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(196, 196, 196, 1),
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(136, 149, 83, 1),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: specialtyController,
//                   decoration: const InputDecoration(
//                     labelText: 'Especialidade',
//                     labelStyle: TextStyle(fontSize: 14),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(196, 196, 196, 1),
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(136, 149, 83, 1),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: timeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Horário',
//                     labelStyle: TextStyle(fontSize: 14),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(196, 196, 196, 1),
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(136, 149, 83, 1),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   readOnly: true,
//                   onTap: () => _selectDate(context, dateController),
//                   controller: dateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Data',
//                     labelStyle: TextStyle(fontSize: 14),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(196, 196, 196, 1),
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(136, 149, 83, 1),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: descriptionController,
//                   maxLines: 5,
//                   decoration: const InputDecoration(
//                     labelText: 'Descrição',
//                     labelStyle: TextStyle(fontSize: 14),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(196, 196, 196, 1),
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Color.fromRGBO(136, 149, 83, 1),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 17,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 245, 245, 245),
//                           foregroundColor: Color.fromARGB(255, 63, 63, 63),
//                         ),
//                         child: const Text(
//                           'Cancelar',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           final updatedConsultation = ConsultationModel(
//                             id: consultation.id,
//                             doctorName: nameController.text,
//                             specialty: specialtyController.text,
//                             time: timeController.text,
//                             date: dateController.text,
//                             description: descriptionController.text,
//                           );
//                           Navigator.of(context).pop(updatedConsultation);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromRGBO(136, 149, 83, 1),
//                           foregroundColor: Colors.white,
//                         ),
//                         child: const Text(
//                           'Atualizar',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _selectDate(
//       BuildContext context, TextEditingController dateController) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ThemeData.light().colorScheme.copyWith(
//                   primary: const Color.fromRGBO(136, 149, 83, 1),
//                 ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (pickedDate != null) {
//       dateController.text = _dateFormat.format(pickedDate);
//     }
//   }
// }
