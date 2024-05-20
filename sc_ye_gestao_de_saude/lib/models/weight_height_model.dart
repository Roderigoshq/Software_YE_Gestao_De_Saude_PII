import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sc_ye_gestao_de_saude/providers/weight_height_provider.dart';
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
    // Convert 'dd/MM/yyyy' to 'yyyy/MM/dd' before saving
    final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
    final String formattedDate = DateFormat('yyyy/MM/dd').format(parsedDate);
    return {
      "id": id,
      "date": formattedDate,
      "weight": weight,
      "height": height,
    };
  }

  factory WeightHeightModel.fromMap(Map<String, dynamic> map) {
    // Convert 'yyyy/MM/dd' to 'dd/MM/yyyy' after fetching
    final DateTime parsedDate = DateFormat('yyyy/MM/dd').parse(map["date"]);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return WeightHeightModel(
      id: map["id"],
      date: formattedDate,
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
  WeightHeightModel? latestWeightHeight;

  @override
void initState() {
  super.initState();
  Provider.of<WeightHeightProvider>(context, listen: false).addListener(() {
    if (mounted) {
      setState(() {});
    }
  });
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: FutureBuilder<List<WeightHeightModel>>(
      future: Provider.of<WeightHeightProvider>(context, listen: false)
          .fetchWeightHeightModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(136, 149, 83, 1),
            ),
          );
        } else if (snapshot.hasData) {
          final weightHeightModels = snapshot.data!;
          if (weightHeightModels.isEmpty) {
            return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/nenhumitem.png', width: 100,),
                SizedBox(height: 20,),
                Text("Não há nenhum item", style: TextStyle(color: Color.fromRGBO(136, 149, 83, 1), fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500),),
              ],
            ),
          );
          }
          weightHeightModels.sort((a, b) {
            final DateTime dateA = _dateFormat.parse(a.date);
            final DateTime dateB = _dateFormat.parse(b.date);
            return dateB.compareTo(dateA);
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
                            await Provider.of<WeightHeightProvider>(context,
                                    listen: false)
                                .editWeightHeight(updatedWeightHeight);
                            setState(() {});
                          }
                        } else if (value == 'delete') {
                          await Provider.of<WeightHeightProvider>(context,
                                  listen: false)
                              .deleteWeightHeight(weightHeight.id);
                          Provider.of<WeightHeightProvider>(context,
                                  listen: false)
                              .notifyItemDeleted();
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
            child: Column(
              children: [
                Image.asset('lib/assets/nenhumitem.png'),
                Text("Não há nenhum item"),
              ],
            ),
          );
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
