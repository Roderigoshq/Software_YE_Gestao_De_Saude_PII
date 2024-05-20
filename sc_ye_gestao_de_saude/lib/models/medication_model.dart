// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class FormScreen extends StatelessWidget {
//   const FormScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<PressureModel>>(
//         future: pressureService.fetchPressureModels(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Color.fromRGBO(136, 149, 83, 1),
//               ),
//             );
//           } else {
//             if (snapshot.hasData) {
//               final pressureModels = snapshot.data!;
//               return ListView.builder(
//                 itemCount: pressureModels.length,
//                 itemBuilder: (context, index) {
//                   final pressure = pressureModels[index];
//                   return ExpansionTile(
//                     title: Row(
//                       children: [
//                         Text(
//                           pressure.date,
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
//                                       'Editar',
//                                       style: TextStyle(
//                                           color: Color.fromRGBO(85, 85, 85, 1),
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15),
//                                     )),
//                                 value: 'edit',
//                               ),
//                               PopupMenuItem(
//                                 child: Center(
//                                     child: Text(
//                                       'Deletar',
//                                       style: TextStyle(
//                                           color: Color.fromRGBO(85, 85, 85, 1),
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15),
//                                     )),
//                                 value: 'delete',
//                               ),
//                             ];
//                           },
//                           onSelected: (value) async {
//                             if (value == 'edit') {
//                               final updatedPressure =
//                               await _showEditPressureDialog(
//                                   context, pressure);

//                               if (updatedPressure != null) {
//                                 await pressureService
//                                     .editPressure(updatedPressure);
//                                 setState(() {});
//                               }
//                             } else if (value == 'delete') {
//                                 await pressureService.deletePressure(pressure.id);
//                                 setState(() {});
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
//                             Container(
//                               height: 21,
//                               width: 4,
//                               color: getColorForPressure(
//                                   pressure.sistolic, pressure.diastolic),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               '${pressure.sistolic}X${pressure.diastolic} ',
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                   color: Color.fromRGBO(135, 135, 135, 1)),
//                             ),
//                             Text(
//                               'mmHg',
//                               style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 15,
//                                   color: Color.fromRGBO(135, 135, 135, 1)),
//                             ),
//                             Spacer(),
//                             Column(
//                               children: [
//                                 Text(
//                                   'Sua pressão está',
//                                   style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w400,
//                                       color: Color.fromRGBO(135, 135, 135, 1)),
//                                 ),
//                                 getStatusForPressure(
//                                     pressure.sistolic, pressure.diastolic),
//                               ],
//                             )
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

//   Future<PressureModel?> _showEditPressureDialog(
//       BuildContext context, PressureModel pressure) async {
//     final TextEditingController sistolicController = TextEditingController();
//     final TextEditingController diastolicController = TextEditingController();
//     final TextEditingController dateController = TextEditingController();

//     sistolicController.text = pressure.sistolic.toString();
//     diastolicController.text = pressure.diastolic.toString();
//     dateController.text = pressure.date;

//     return showDialog<PressureModel>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Center(
//             child: Text(
//               'Editar Pressão',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisSize: MainAxisSize.min,
//               children: [
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
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: sistolicController,
//                         onChanged: (value) {},
//                         decoration: const InputDecoration(
//                           hintText: 'Pressão sistólica',
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color.fromRGBO(136, 149, 83, 1)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     const Text(
//                       'X',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 70, 70, 70),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: diastolicController,
//                         onChanged: (value) {},
//                         decoration: const InputDecoration(
//                           hintText: 'Pressão Diastólica',
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Color.fromRGBO(136, 149, 83, 1)),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 const Center(
//                   child: Text(
//                     'mmHg',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w600,
//                       color: Color.fromARGB(255, 88, 88, 88),
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
//                           final updatedPressure = PressureModel(
//                             id: pressure.id,
//                             date: dateController.text,
//                             sistolic: int.tryParse(sistolicController.text) ??
//                                 pressure.sistolic,
//                             diastolic:
//                             int.tryParse(diastolicController.text) ??
//                                 pressure.diastolic,
//                             isExpanded: pressure.isExpanded,
//                           );
//                           Navigator.of(context).pop(updatedPressure);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                           Color.fromRGBO(136, 149, 83, 1),
//                           foregroundColor:
//                           Colors.white,
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
//               primary: const Color.fromRGBO(136, 149, 83, 1),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (pickedDate != null) {
//       dateController.text = _dateFormat.format(pickedDate);
//     }
//   }

//   Text getStatusForPressure(int sistolic, int diastolic) {
//     if (sistolic < 90 && diastolic < 60) {
//       return Text(
//         'Baixa',
//         style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//             color: Color.fromRGBO(85, 85, 85, 1)),
//       );
//     } else if (sistolic < 120 && diastolic < 80) {
//       return Text(
//         'Normal',
//         style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//             color: Color.fromRGBO(85, 85, 85, 1)),
//       );
//     } else if ((sistolic >= 120 && sistolic < 140) ||
//         (diastolic >= 80 && diastolic < 90)) {
//       return Text(
//         'Elevada',
//         style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//             color: Color.fromRGBO(85, 85, 85, 1)),
//       );
//     } else if ((sistolic >= 140 && sistolic < 160) ||
//         (diastolic >= 90 && diastolic < 100)) {
//       return Text(
//         'Alta',
//         style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//             color: Color.fromRGBO(85, 85, 85, 1)),
//       );
//     } else {
//       return Text(
//         'Muito alta',
//         style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//             color: Color.fromRGBO(85, 85, 85, 1)),
//       );
//     }
//   }
// }

// Color getColorForPressure(int sistolic, int diastolic) {
//   if (sistolic < 90 && diastolic < 60) {
//     return const Color.fromRGBO(210, 223, 149, 1);
//   } else if (sistolic < 120 && diastolic < 80) {
//     return Color.fromRGBO(136, 149, 83, 1);
//   } else if ((sistolic >= 120 && sistolic < 140) ||
//       (diastolic >= 80 && diastolic < 90)) {
//     return Colors.orange;
//   } else if ((sistolic >= 140 && sistolic < 160) ||
//       (diastolic >= 90 && diastolic < 100)) {
//     return Color.fromRGBO(244, 94, 94, 1);
//   } else {
//     return Color.fromRGBO(253, 64, 64, 1);
//   }
// }

// class PressureModel {
//   String id;
//   String date;
//   int diastolic;
//   int sistolic;
//   bool isExpanded;

//   PressureModel({
//     required this.id,
//     required this.date,
//     required this.diastolic,
//     required this.sistolic,
//     required this.isExpanded,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "date": date,
//       "diastolic": diastolic,
//       "sistolic": sistolic,
//     };
//   }

//   factory PressureModel.fromMap(Map<String, dynamic> map) {
//     return PressureModel(
//       id: map["id"],
//       date: map["date"],
//       diastolic: map["diastolic"],
//       sistolic: map["sistolic"],
//       isExpanded: false,
//     );
//   }
// }