import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/glucose_service.dart';

class GlucoseModel {
  String id;
  String date;
  int glucose;
  bool isExpanded;

  GlucoseModel({
    required this.id,
    required this.date,
    required this.glucose,
    required this.isExpanded,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "glucose": glucose,
    };
  }

  factory GlucoseModel.fromMap(Map<String, dynamic> map) {
    return GlucoseModel(
      id: map["id"],
      date: map["date"],
      glucose: map["glucose"],
      isExpanded: false,
    );
  }
}

Color getColorForGlucose(int glucose) {
  if (glucose < 70) {
    return const Color.fromRGBO(210, 223, 149, 1);
  } else if (glucose >= 70 && glucose < 100) {
    return Color.fromRGBO(136, 149, 83, 1);
  } else if ((glucose >= 100 && glucose < 120)) {
    return Color.fromRGBO(244, 94, 94, 1);
  } else {
    return Color.fromRGBO(253, 64, 64, 1);
  }
}

class ExtensionPanelGlucose extends StatefulWidget {
  const ExtensionPanelGlucose({Key? key}) : super(key: key);

  @override
  State<ExtensionPanelGlucose> createState() => _ExtensionPanelGlucoseState();
}

class _ExtensionPanelGlucoseState extends State<ExtensionPanelGlucose> {
  final GlucoseAdd glucoseService = GlucoseAdd();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GlucoseModel>>(
        future: glucoseService.fetchGlucoseModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            );
          } else {
            if (snapshot.hasData) {
              final glucoseModels = snapshot.data!;
              glucoseModels.sort((a, b) {
                final RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                if (dateRegExp.hasMatch(a.date) &&
                    dateRegExp.hasMatch(b.date)) {
                  final DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
                  final DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
                  return dateB.compareTo(dateA);
                } else {
                  return 0;
                }
              });
              return ListView.builder(
                itemCount: glucoseModels.length,
                itemBuilder: (context, index) {
                  final glucose = glucoseModels[index];
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          glucose.date,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color.fromRGBO(85, 85, 85, 1)),
                        ),
                        Spacer(),
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry>[
                              PopupMenuItem(
                                child: Center(
                                    child: Text(
                                  'Editar',
                                  style: TextStyle(
                                      color: Color.fromRGBO(85, 85, 85, 1),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                )),
                                value: 'edit',
                              ),
                              PopupMenuItem(
                                child: Center(
                                    child: Text(
                                  'Deletar',
                                  style: TextStyle(
                                      color: Color.fromRGBO(85, 85, 85, 1),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                )),
                                value: 'delete',
                              ),
                            ];
                          },
                          onSelected: (value) async {
                            if (value == 'edit') {
                              final updatedGlucose =
                                  await _showEditGlucoseDialog(
                                      context, glucose);

                              if (updatedGlucose != null) {
                                await glucoseService
                                    .editGlucose(updatedGlucose);
                                setState(() {});
                              }
                            } else if (value == 'delete') {
                              await glucoseService.deleteGlucose(glucose.id);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.expand_more),
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Container(
                              height: 21,
                              width: 4,
                              color: getColorForGlucose(glucose.glucose),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              '${glucose.glucose} ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            Text(
                              'mg/Dl',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  'Sua glicemia está',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(135, 135, 135, 1)),
                                ),
                                getStatusForGlucose(glucose.glucose),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: Text("Não há nenhum item"),
              );
            }
          }
        },
      ),
    );
  }

  Future<GlucoseModel?> _showEditGlucoseDialog(
      BuildContext context, GlucoseModel glucose) async {
    final TextEditingController glucoseController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    glucoseController.text = glucose.glucose.toString();
    dateController.text = glucose.date;

    return showDialog<GlucoseModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Editar Glicemia',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  readOnly: true,
                  onTap: () => _selectDate(context, dateController),
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(196, 196, 196, 1),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(136, 149, 83, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: glucoseController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'Glicemia',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(136, 149, 83, 1)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                  'mg/Dl',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 245, 245, 245),
                          foregroundColor: Color.fromARGB(255, 63, 63, 63),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final updatedGlucose = GlucoseModel(
                            id: glucose.id,
                            date: dateController.text,
                            glucose: int.tryParse(glucoseController.text) ??
                                glucose.glucose,
                            isExpanded: glucose.isExpanded,
                          );
                          Navigator.of(context).pop(updatedGlucose);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(136, 149, 83, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Atualizar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectDate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ThemeData.light().colorScheme.copyWith(
                  primary: const Color.fromRGBO(136, 149, 83, 1),
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dateController.text = _dateFormat.format(pickedDate);
    }
  }

  Text getStatusForGlucose(int glucose) {
    if (glucose < 70) {
      return Text(
        'Baixa',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    } else if (glucose >= 70 && glucose < 100) {
      return Text(
        'Normal',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    } else if ((glucose >= 100 && glucose < 120) ||
        (glucose >= 80 && glucose < 90)) {
      return Text(
        'Alta',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    } else {
      return Text(
        'Muito alta',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    }
  }
}
