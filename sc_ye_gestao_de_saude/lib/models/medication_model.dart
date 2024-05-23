import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_modal.dart'; // Certifique-se de que o caminho está correto

class MedicationModel {
  String id;
  String name;
  String dosage;
  List<String> dates; // Lista de datas em formato string
  int hour;
  int minute;
  String period; // 'AM' ou 'PM'
  bool reminder;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.dates,
    required this.hour,
    required this.minute,
    required this.period,
    this.reminder = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'dates': dates,
      'hour': hour,
      'minute': minute,
      'period': period,
      'reminder': reminder,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      dates: List<String>.from(map['dates'] as List<dynamic>),
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      period: map['period'] as String,
      reminder: map['reminder'] as bool? ?? false,
    );
  }
}

class ExtensionPanelMedication extends StatefulWidget {
  const ExtensionPanelMedication({Key? key}) : super(key: key);

  @override
  State<ExtensionPanelMedication> createState() => _ExtensionPanelMedicationState();
}

class _ExtensionPanelMedicationState extends State<ExtensionPanelMedication> {
  final MedicationService medicationService = MedicationService();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MedicationModel>>(
        future: medicationService.fetchMedicationModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            );
          } else {
            if (snapshot.hasData) {
              final medicationModels = snapshot.data!;
              if (medicationModels.isEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/nenhumitem.png',
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Não há nenhum item",
                        style: TextStyle(
                          color: Color.fromRGBO(136, 149, 83, 1),
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }
              medicationModels.sort((a, b) {
                final DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.dates[0]);
                final DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.dates[0]);
                return dateB.compareTo(dateA);
              });
              return ListView.builder(
                itemCount: medicationModels.length,
                itemBuilder: (context, index) {
                  final medication = medicationModels[index];
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          _dateFormat.format(DateFormat('yyyy-MM-dd').parse(medication.dates[0])),
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
                              final updatedMedication = await _showEditMedicationDialog(context, medication);

                              if (updatedMedication != null) {
                                await medicationService.editMedication(updatedMedication);
                                setState(() {});
                              }
                            } else if (value == 'delete') {
                              await medicationService.deleteMedication(medication.id);
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
                            Text(
                              '${medication.name} - ${medication.dosage}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            Spacer(),
                            Text(
                              '${medication.hour}:${medication.minute.toString().padLeft(2, '0')} ${medication.period}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "Lembrete: ${medication.reminder ? 'Ativo' : 'Inativo'}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color.fromRGBO(135, 135, 135, 1)),
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

  Future<MedicationModel?> _showEditMedicationDialog(BuildContext context, MedicationModel medication) async {
    final TextEditingController nameController = TextEditingController(text: medication.name);
    final TextEditingController dosageController = TextEditingController(text: medication.dosage);
    final TextEditingController hourController = TextEditingController(text: medication.hour.toString());
    final TextEditingController minuteController = TextEditingController(text: medication.minute.toString());
    String period = medication.period;
    bool reminder = medication.reminder;

    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Editar Medicação',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
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
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosagem',
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
                TextField(
                  controller: hourController,
                  decoration: const InputDecoration(
                    labelText: 'Hora',
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
                TextField(
                  controller: minuteController,
                  decoration: const InputDecoration(
                    labelText: 'Minuto',
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
                    const Text('AM'),
                    Radio<String>(
                      value: 'AM',
                      groupValue: period,
                      onChanged: (value) {
                        setState(() {
                          period = value!;
                        });
                      },
                    ),
                    const Text('PM'),
                    Radio<String>(
                      value: 'PM',
                      groupValue: period,
                      onChanged: (value) {
                        setState(() {
                          period = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ativar Lembrete'),
                  trailing: Switch(
                    value: reminder,
                    onChanged: (bool val) {
                      setState(() {
                        reminder = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      MedicationModel updatedMedication = MedicationModel(
        id: medication.id,
        name: nameController.text,
        dosage: dosageController.text,
        dates: medication.dates,
        hour: int.parse(hourController.text),
        minute: int.parse(minuteController.text),
        period: period,
        reminder: reminder,
      );
      await medicationService.editMedication(updatedMedication);
      setState(() {});
    }
  }
}
