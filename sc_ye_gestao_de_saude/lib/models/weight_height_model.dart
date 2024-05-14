import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/weight_height_service.dart';

class WeightHeightModel {
  String id;
  String date;
  int weight;
  int height;
  bool isExpanded;

  WeightHeightModel({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    required this.isExpanded,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "weight": weight,
      "height": height,
    };
  }

  factory WeightHeightModel.fromMap(Map<String, dynamic> map) {
    return WeightHeightModel(
      id: map["id"],
      date: map["date"],
      weight: map["weight"],
      height: map["height"],
      isExpanded: false,
    );
  }
}

class ExtensionPanelWeightHeight extends StatefulWidget {
  const ExtensionPanelWeightHeight({Key? key}) : super(key: key);

  @override
  State<ExtensionPanelWeightHeight> createState() =>
      _ExtensionPanelWeightHeightState();
}

class _ExtensionPanelWeightHeightState
    extends State<ExtensionPanelWeightHeight> {

  final WeightHeightAdd weightHeightService = WeightHeightAdd();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WeightHeightModel>>(
        future: weightHeightService.fetchWeightHeightModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            );
          } else {
            if (snapshot.hasData) {
              final weightHeightModels = snapshot.data!;
              weightHeightModels.sort((a, b) {
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
                itemCount: weightHeightModels.length,
                itemBuilder: (context, index) {
                  final weightHeight = weightHeightModels[index];
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          weightHeight.date,
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
                              final updatedWeightHeight =
                                  await _showEditWeightHeightDialog(
                                      context, weightHeight);

                              if (updatedWeightHeight != null) {
                                await weightHeightService
                                    .editWeightHeight(updatedWeightHeight);
                                setState(() {});
                              }
                            } else if (value == 'delete') {
                              await weightHeightService
                                  .deleteWeightHeight(weightHeight.id);
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
                              'Peso: ${weightHeight.weight}kg    Altura: ${weightHeight.height}m',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
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

  Future<WeightHeightModel?> _showEditWeightHeightDialog(
      BuildContext context, WeightHeightModel weightHeight) async {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController heightController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    weightController.text = weightHeight.weight.toString();
    heightController.text = weightHeight.height.toString();
    dateController.text = weightHeight.date;

    return showDialog<WeightHeightModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Editar Peso & Altura',
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
                        controller: weightController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'Peso',
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
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'Altura',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(136, 149, 83, 1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                          final updatedWeightHeight = WeightHeightModel(
                            id: weightHeight.id,
                            date: dateController.text,
                            weight: int.tryParse(weightController.text) ??
                                weightHeight.weight,
                            height: int.tryParse(heightController.text) ??
                                weightHeight.height,
                            isExpanded: weightHeight.isExpanded,
                          );
                          Navigator.of(context).pop(updatedWeightHeight);
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
}
