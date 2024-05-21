// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';

// class MedicationModel {
//   String id;
//   String name;
//   String dosage;
//   String time;
//   String date;

//   MedicationModel({
//     required this.id,
//     required this.name,
//     required this.dosage,
//     required this.time,
//     required this.date,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "name": name,
//       "dosage": dosage,
//       "time": time,
//       "date": date,
//     };
//   }

//   factory MedicationModel.fromMap(Map<String, dynamic> map) {
//     return MedicationModel(
//       id: map["id"],
//       name: map["name"],
//       dosage: map["dosage"],
//       time: map["time"],
//       date: map["date"],
//     );
//   }
// }

// class ExtensionPanelMedication extends StatefulWidget {
//   const ExtensionPanelMedication({Key? key}) : super(key: key);

//   @override
//   State<ExtensionPanelMedication> createState() => _ExtensionPanelMedicationState();
// }

// class _ExtensionPanelMedicationState extends State<ExtensionPanelMedication> {
//   final MedicationService medicationService = MedicationService();
//   final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<MedicationModel>>(
//         future: medicationService.fetchMedicationModels(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Color.fromRGBO(136, 149, 83, 1),
//               ),
//             );
//           } else {
//             if (snapshot.hasData) {
//               final medicationModels = snapshot.data!;
//               if (medicationModels.isEmpty) {
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
//                         "Não há nenhum item",
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
//               medicationModels.sort((a, b) {
//                 final DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
//                 final DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
//                 return dateB.compareTo(dateA);
//               });
//               return ListView.builder(
//                 itemCount: medicationModels.length,
//                 itemBuilder: (context, index) {
//                   final medication = medicationModels[index];
//                   return ExpansionTile(
//                     title: Row(
//                       children: [
//                         Text(
//                           medication.date,
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
//                               final updatedMedication =
//                                   await _showEditMedicationDialog(
//                                       context, medication);

//                               if (updatedMedication != null) {
//                                 await medicationService
//                                     .editMedication(updatedMedication);
//                                 setState(() {});
//                               }
//                             } else if (value == 'delete') {
//                               await medicationService.deleteMedication(medication.id);
//                               setState(() {});
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     trailing: Icon(Icons.expand_more),
//                     children: [
//                       ListTile(
//                         title: Row(
//                           children: [
//                             Text(
//                               '${medication.name} - ${medication.dosage}',
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                   color: Color.fromRGBO(135, 135, 135, 1)),
//                             ),
//                             Spacer(),
//                             Text(
//                               medication.time,
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
//                 child: Text("Não há nenhum item"),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   Future<MedicationModel?> _showEditMedicationDialog(
//       BuildContext context, MedicationModel medication) async {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController dosageController = TextEditingController();
//     final TextEditingController timeController = TextEditingController();
//     final TextEditingController dateController = TextEditingController();

//     nameController.text = medication.name;
//     dosageController.text = medication.dosage;
//     timeController.text = medication.time;
//     dateController.text = medication.date;

//     return showDialog<MedicationModel>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Center(
//             child: Text(
//               'Editar Medicação',
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
//                     labelText: 'Nome',
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
//                   controller: dosageController,
//                   decoration: const InputDecoration(
//                     labelText: 'Dosagem',
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
//                           final updatedMedication = MedicationModel(
//                             id: medication.id,
//                             name: nameController.text,
//                             dosage: dosageController.text,
//                             time: timeController.text,
//                             date: dateController.text,
//                           );
//                           Navigator.of(context).pop(updatedMedication);
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
