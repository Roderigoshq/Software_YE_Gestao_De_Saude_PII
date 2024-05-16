import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/components/custom_tab.dart';
import 'package:sc_ye_gestao_de_saude/models/glucose_model.dart';
import 'package:sc_ye_gestao_de_saude/models/pressure_model.dart';
import 'package:sc_ye_gestao_de_saude/models/weight_height_model.dart';
import 'package:sc_ye_gestao_de_saude/services/glucose_service.dart';
import 'package:sc_ye_gestao_de_saude/services/pressure_service.dart';
import 'package:sc_ye_gestao_de_saude/services/weight_height_service.dart';
import 'package:uuid/uuid.dart';

class DadosPage extends StatefulWidget {
  const DadosPage({super.key});

  @override
  _DadosPageState createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage>
    with SingleTickerProviderStateMixin {
  WeightHeightModel? latestWeightHeight;

  Future<void> _loadLatestWeight() async {
    final latestWeight = await WeightHeightAdd().getLatestWeight();
    setState(() {
      latestWeightHeight = latestWeight;
    });
  }

  String calculateIMC(int? weight, int? height) {
    if (weight != null && height != null && height != 0) {
      double heightInMeters = height / 100;
      double bmi = weight / (heightInMeters * heightInMeters);
      return bmi.toStringAsFixed(1);
    } else {
      return '-';
    }
  }

  late TabController _tabController;
  late DateTime? _selectedDate;
  late TextEditingController _selectedDateController;
  final TextEditingController _sistolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDate = null;
    _tabController = TabController(length: 4, vsync: this);
    _selectedDateController = TextEditingController();
    _selectedDateController.text =
        _selectedDate != null ? _dateFormat.format(_selectedDate!) : '';
    _loadLatestWeight();
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color.fromRGBO(136, 149, 83, 1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedDateController.text =
            _selectedDate != null ? _dateFormat.format(_selectedDate!) : '';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedDateController.dispose();
    super.dispose();
  }

  final PressureAdd _pressureAdd = PressureAdd();

  addPressure() {
    String date = _dateFormat.format(_selectedDate!);
    String sistolicString = _sistolicController.text;
    int sistolic = int.tryParse(sistolicString) ?? 0;
    String diastolicString = _diastolicController.text;
    int diastolic = int.tryParse(diastolicString) ?? 0;
    bool isExpanded = false;

    PressureModel pressure = PressureModel(
        id: const Uuid().v1(),
        date: date,
        diastolic: diastolic,
        sistolic: sistolic,
        isExpanded: isExpanded);

    Navigator.pop(context);

    _sistolicController.clear();
    _diastolicController.clear();
    _selectedDateController.clear();

    _pressureAdd.addPressure(pressure);
  }

  final WeightHeightAdd _weightHeightAdd = WeightHeightAdd();

  addWeightHeight() {
    String date = _dateFormat.format(_selectedDate!);
    String weightString = _weightController.text;
    int weight = int.tryParse(weightString) ?? 0;
    String heightString = _heightController.text;
    int height = int.tryParse(heightString) ?? 0;
    bool isExpanded = false;

    WeightHeightModel weightHeights = WeightHeightModel(
        id: const Uuid().v1(),
        date: date,
        weight: weight,
        height: height,
        isExpanded: isExpanded);

    Navigator.pop(context);

    _weightController.clear();
    _heightController.clear();
    _selectedDateController.clear();

    _weightHeightAdd.addWeightHeight(weightHeights);
    _loadLatestWeight();
  }

  final GlucoseAdd _glucoseAdd = GlucoseAdd();

  addGlucose() {
    String date = _dateFormat.format(_selectedDate!);
    String glucoseString = _glucoseController.text;
    int glucose = int.tryParse(glucoseString) ?? 0;
    bool isExpanded = false;

    GlucoseModel glucoses = GlucoseModel(
        id: const Uuid().v1(),
        date: date,
        glucose: glucose,
        isExpanded: isExpanded);

    Navigator.pop(context);

    _glucoseController.clear();
    _selectedDateController.clear();

    _glucoseAdd.addGlucose(glucoses);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user != null ? user.displayName?.split(' ')[0] ?? '' : '';
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  padding: const EdgeInsets.fromLTRB(40, 35, 40, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Olá, ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                "$userName!",
                                style: const TextStyle(
                                  color: Color.fromRGBO(136, 149, 83, 1),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Veja seus dados abaixo:",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: InteractiveViewer(
                                        child: Image.asset(
                                          'lib/assets/3106921 2.png',
                                          height: 300,
                                          width: 300,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                'lib/assets/3106921 2.png',
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color.fromRGBO(136, 149, 83, 1),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: const Color.fromRGBO(136, 149, 83, 1),
                  unselectedLabelColor: const Color.fromRGBO(149, 149, 149, 1),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    CustomTab(text: 'Pressão', subText: '1x1'),
                    CustomTab(
                      text: 'Glicemia',
                      subText: '1mg/Dl',
                    ),
                    CustomTab(
                      text: 'Peso & Altura',
                      subText: latestWeightHeight != null
                          ? '${latestWeightHeight!.weight} kg, ${latestWeightHeight!.height} m'
                          : 'Não há dados disponíveis',
                    ),
                    CustomTab(text: 'IMC', subText: '1'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ExtensionPanelPressure(),
                      // Conteúdo da aba Glicemia
                      ExtensionPanelGlucose(),
                      // Conteúdo da aba Peso & Altura
                      ExtensionPanelWeightHeight(),
                      // Conteúdo da aba IMC
                      Center(
                        child: Container(
                          color: const Color.fromRGBO(248, 248, 248, 1),
                          child: const Text('Conteúdo da aba IMC'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 60,
              right: 20,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(136, 149, 83, 1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: PopupMenuButton(
                  child: const Icon(
                    Icons.add,
                    size: 36,
                    color: Colors.white,
                  ),
                  onSelected: (value) {
                    if (value == "pressure") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                'Adicionar Pressão',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    controller: _selectedDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Data',
                                      labelStyle: TextStyle(fontSize: 14),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(196, 196, 196, 1),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(136, 149, 83, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _sistolicController,
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            hintText: 'Pressão sistólica',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      136, 149, 83, 1)),
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
                                          color:
                                              Color.fromARGB(255, 70, 70, 70),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _diastolicController,
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            hintText: 'Pressão Diastólica',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      136, 149, 83, 1)),
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
                                            backgroundColor: Color.fromARGB(
                                                255, 245, 245, 245),
                                            foregroundColor:
                                                Color.fromARGB(255, 63, 63, 63),
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
                                            addPressure();
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromRGBO(136, 149, 83, 1),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'Adicionar',
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
                    } else if (value == "glucose") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                'Adicionar Glicemia',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    controller: _selectedDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Data',
                                      labelStyle: TextStyle(fontSize: 14),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(196, 196, 196, 1),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(136, 149, 83, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _glucoseController,
                                          onChanged: (value) {
                                            // Lógica para o primeiro TextField
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Glicemia',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      136, 149, 83, 1)),
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
                                          color:
                                              Color.fromARGB(255, 88, 88, 88),
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
                                            backgroundColor: Color.fromARGB(
                                                255, 245, 245, 245),
                                            foregroundColor:
                                                Color.fromARGB(255, 63, 63, 63),
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
                                            addGlucose();
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromRGBO(136, 149, 83, 1),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'Adicionar',
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
                    } else if (value == "weight_height") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                'Adicionar Peso & Altura',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    controller: _selectedDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Data',
                                      labelStyle: TextStyle(fontSize: 14),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(196, 196, 196, 1),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(136, 149, 83, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _weightController,
                                          onChanged: (value) {
                                            // Lógica para o primeiro TextField
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Peso',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      136, 149, 83, 1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _heightController,
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            hintText: 'Altura',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      136, 149, 83, 1)),
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
                                            backgroundColor: Color.fromARGB(
                                                255, 245, 245, 245),
                                            foregroundColor:
                                                Color.fromARGB(255, 63, 63, 63),
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
                                            addWeightHeight();
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromRGBO(136, 149, 83, 1),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'Adicionar',
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
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: "pressure",
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.add),
                          ),
                          Text(
                            'Adicionar Pressão',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: "glucose",
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.add),
                          ),
                          Text(
                            'Adicionar Glicemia',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: "weight_height",
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.add),
                          ),
                          Text(
                            'Adicionar Peso & Altura',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
