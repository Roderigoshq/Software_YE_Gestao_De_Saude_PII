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
    final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
    final String formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
    return {
      "id": id,
      "date": formattedDate,
      "glucose": glucose,
    };
  }

  factory GlucoseModel.fromMap(Map<String, dynamic> map) {
    final DateTime parsedDate = DateFormat('yyyy/MM/dd').parse(map["date"]);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return GlucoseModel(
      id: map["id"],
      date: formattedDate,
      glucose: map["glucose"],
      isExpanded: false,
    );
  }
}

Color getColorForGlucose(int glucose) {
  if (glucose < 70) {
    return const Color.fromRGBO(210, 223, 149, 1);
  } else if (glucose >= 70 && glucose < 100) {
    return const Color.fromRGBO(136, 149, 83, 1);
  } else if ((glucose >= 100 && glucose < 120)) {
    return const Color.fromRGBO(244, 94, 94, 1);
  } else {
    return const Color.fromRGBO(253, 64, 64, 1);
  }
}

typedef EditCallback = void Function(GlucoseModel updatedModel);
typedef DeleteCallback = void Function(GlucoseModel weightHeight);

class ExtensionPanelGlucose extends StatefulWidget {
      final EditCallback editCallback;
  final DeleteCallback deleteCallback;
  const ExtensionPanelGlucose({super.key, required this.editCallback, required this.deleteCallback});

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
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            );
          } else {
            if (snapshot.hasData) {
              final glucoseModels = snapshot.data!;
              if (glucoseModels.isEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/nenhumitem.png',
                        width: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
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
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color.fromRGBO(85, 85, 85, 1)),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: 'edit',
                                child: Center(
                                    child: Text(
                                  'Editar',
                                  style: TextStyle(
                                      color: Color.fromRGBO(85, 85, 85, 1),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                )),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Center(
                                    child: Text(
                                  'Deletar',
                                  style: TextStyle(
                                      color: Color.fromRGBO(85, 85, 85, 1),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                )),
                              ),
                            ];
                          },
                          onSelected: (value) async {
                            if (value == 'edit') {
                              final updatedWeightHeight =
                                await _showEditGlucoseDialog(
                              context,
                              glucose,
                            );

                            if (updatedWeightHeight != null) {
                              // Chama a função para editar os dados no serviço
                              await GlucoseAdd()
                                  .editGlucose(updatedWeightHeight);

                              // Em seguida, chama a função de retorno de chamada para atualizar a interface do usuário
                              widget.editCallback(updatedWeightHeight);
                            }
                            setState(() {});
                            } else if (value == 'delete') {
                              final confirmed = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Confirmar Exclusão',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(
                                            255, 66, 66, 66)),
                                  ),
                                  content: const Text(
                                      'Tem certeza de que deseja excluir este registro?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Color.fromRGBO(
                                                136, 149, 83, 1)),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Confirmar',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Color.fromRGBO(
                                                  136, 149, 83, 1))),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed == true) {
                              await glucoseService
                                  .deleteGlucose(glucose);
                              widget.deleteCallback(glucose);

                              setState(() {});
                            }
                            }
                            }
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.expand_more),
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Container(
                              height: 21,
                              width: 4,
                              color: getColorForGlucose(glucose.glucose),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              '${glucose.glucose} ',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            const Text(
                              'mg/Dl',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                const Text(
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
              return const Center(
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
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
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
                          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                          foregroundColor: const Color.fromARGB(255, 63, 63, 63),
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
                          backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
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
      return const Text(
        'Baixa',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    } else if (glucose >= 70 && glucose < 100) {
      return const Text(
        'Normal',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    } else if ((glucose >= 100 && glucose < 120) ||
        (glucose >= 80 && glucose < 90)) {
      return const Text(
        'Alta',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromRGBO(85, 85, 85, 1)),
      );
    } else {
      return const Text(
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
