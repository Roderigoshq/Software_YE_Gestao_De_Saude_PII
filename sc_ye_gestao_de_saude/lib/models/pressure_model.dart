import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/pressure_service.dart';

class PressureModel {
  String id;
  String date;
  int diastolic;
  int sistolic;
  bool isExpanded;

  PressureModel({
    required this.id,
    required this.date,
    required this.diastolic,
    required this.sistolic,
    required this.isExpanded,
  });

  Map<String, dynamic> toMap() {
    final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
    final String formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
    return {
      "id": id,
      "date": formattedDate,
      "diastolic": diastolic,
      "sistolic": sistolic,
    };
  }

  factory PressureModel.fromMap(Map<String, dynamic> map) {
    final DateTime parsedDate = DateFormat('yyyy/MM/dd').parse(map["date"]);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return PressureModel(
      id: map["id"],
      date: formattedDate,
      diastolic: map["diastolic"],
      sistolic: map["sistolic"],
      isExpanded: false,
    );
  }
}

Color getColorForPressure(int sistolic, int diastolic) {
  if ((sistolic <= 90) && (diastolic <= 60)) {
    return const Color.fromRGBO(210, 223, 149, 1);
  } else if ((sistolic > 90) &&
      (sistolic <= 139) &&
      (diastolic > 60) &&
      (diastolic <= 89)) {
    return const Color.fromRGBO(136, 149, 83, 1);
  } else if ((sistolic > 139) &&
      (sistolic <= 159) &&
      (diastolic >= 90) &&
      (diastolic < 100)) {
    return Colors.orange;
  } else if ((sistolic >= 160) &&
      (sistolic <= 179) &&
      (diastolic >= 100) &&
      (diastolic < 110)) {
    return const Color.fromRGBO(244, 94, 94, 1);
  } else {
    return const Color.fromRGBO(253, 64, 64, 1);
  }
}

Text getStatusForPressure(int sistolic, int diastolic) {
  if ((sistolic <= 90) && (diastolic <= 60)) {
    return const Text(
      'Baixa',
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color.fromRGBO(85, 85, 85, 1)),
    );
  } else if ((sistolic > 90) &&
      (sistolic <= 139) &&
      (diastolic > 60) &&
      (diastolic <= 89)) {
    return const Text(
      'Normal',
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color.fromRGBO(85, 85, 85, 1)),
    );
  } else if ((sistolic > 139) &&
      (sistolic <= 159) &&
      (diastolic >= 90) &&
      (diastolic < 100)) {
    return const Text(
      'Elevada',
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color.fromRGBO(85, 85, 85, 1)),
    );
  } else if ((sistolic >= 160) &&
      (sistolic <= 179) &&
      (diastolic >= 100) &&
      (diastolic < 110)) {
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


typedef EditCallback = void Function(PressureModel updatedModel);
typedef DeleteCallback = void Function(PressureModel weightHeight);

class ExtensionPanelPressure extends StatefulWidget {
  final EditCallback editCallback;
  final DeleteCallback deleteCallback;

  const ExtensionPanelPressure(
      {super.key, required this.editCallback, required this.deleteCallback});

  @override
  State<ExtensionPanelPressure> createState() => _ExtensionPanelPressureState();
}

class _ExtensionPanelPressureState extends State<ExtensionPanelPressure> {
  final PressureAdd pressureService = PressureAdd();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PressureModel>>(
        future: pressureService.fetchPressureModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            );
          } else {
            if (snapshot.hasData) {
              final pressureModels = snapshot.data!;
              if (pressureModels.isEmpty) {
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
              pressureModels.sort((a, b) {
                final DateTime dateA = _dateFormat.parse(a.date);
                final DateTime dateB = _dateFormat.parse(b.date);
                return dateB.compareTo(dateA);
              });
              return ListView.builder(
                itemCount: pressureModels.length,
                itemBuilder: (context, index) {
                  final pressure = pressureModels[index];
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          pressure.date,
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
                                  await _showEditPressureDialog(
                                context,
                                pressure,
                              );

                              if (updatedWeightHeight != null) {
                                // Chama a função para editar os dados no serviço
                                await PressureAdd()
                                    .editPressure(updatedWeightHeight);

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
                                          color:
                                              Color.fromARGB(255, 66, 66, 66)),
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
                                await pressureService.deletePressures(pressure);
                                widget.deleteCallback(pressure);

                                setState(() {});
                              }
                            }
                          },
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
                              color: getColorForPressure(
                                  pressure.sistolic, pressure.diastolic),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              '${pressure.sistolic}X${pressure.diastolic} ',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            const Text(
                              'mmHg',
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
                                  'Sua pressão está',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(135, 135, 135, 1)),
                                ),
                                getStatusForPressure(
                                    pressure.sistolic, pressure.diastolic),
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

  Future<PressureModel?> _showEditPressureDialog(
      BuildContext context, PressureModel pressure) async {
    final TextEditingController sistolicController = TextEditingController();
    final TextEditingController diastolicController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    sistolicController.text = pressure.sistolic.toString();
    diastolicController.text = pressure.diastolic.toString();
    dateController.text = pressure.date;

    return showDialog<PressureModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Editar Pressão',
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
                        controller: sistolicController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'Pressão sistólica',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(136, 149, 83, 1)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'X',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 70, 70, 70),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: diastolicController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'Pressão Diastólica',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(136, 149, 83, 1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child: Text(
                    'mmHg',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 88, 88, 88),
                    ),
                  ),
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
                          backgroundColor:
                              const Color.fromARGB(255, 245, 245, 245),
                          foregroundColor:
                              const Color.fromARGB(255, 63, 63, 63),
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
                          final updatedPressure = PressureModel(
                            id: pressure.id,
                            date: dateController.text,
                            sistolic: int.tryParse(sistolicController.text) ??
                                pressure.sistolic,
                            diastolic: int.tryParse(diastolicController.text) ??
                                pressure.diastolic,
                            isExpanded: pressure.isExpanded,
                          );
                          Navigator.of(context).pop(updatedPressure);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(136, 149, 83, 1),
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
}
