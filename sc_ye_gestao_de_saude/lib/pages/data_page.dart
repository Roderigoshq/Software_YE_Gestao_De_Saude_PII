import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  DadosPageState createState() => DadosPageState();
}

class DadosPageState extends State<DadosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime? _selectedDate;
  late TextEditingController _selectedDateController;
  final TextEditingController _sistolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  WeightHeightModel? latestWeightHeight;
  PressureModel? latestPressure;
  GlucoseModel? latestGlucose;
  String nome = '';

  Future<void> _loadLatestWeight() async {
    final latestWeightHeightAux = await WeightHeightAdd().getLatestWeight();
    setState(() {
      latestWeightHeight = latestWeightHeightAux;
    });
  }

  Future<void> _loadLatestPressure() async {
    final latestPressureAux = await PressureAdd().getLatestPressure();
    setState(() {
      latestPressure = latestPressureAux;
    });
  }

  Future<void> _loadLatestGlucose() async {
    final latestGlucoseAux = await GlucoseAdd().getLatestGlucose();
    setState(() {
      latestGlucose = latestGlucoseAux;
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

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _fetchUserName() async {
    try {
      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('usuarios').child(user!.uid);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          setState(() {
            nome = snapshot.child('nome').value?.toString() ?? 'N/A';
          });
        } else {
          print('No data available for the user.');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('An error occurred while fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = null;
    _tabController = TabController(length: 3, vsync: this);
    _selectedDateController = TextEditingController();
    _selectedDateController.text =
        _selectedDate != null ? _dateFormat.format(_selectedDate!) : '';
    _loadLatestWeight();
    _loadLatestGlucose();
    _loadLatestPressure();
    _fetchUserName();
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

  addPressure(BuildContext context) {

    if (_selectedDate == null) return;
    
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

    if (mounted) {
    Navigator.of(context).pop();
  }

    _sistolicController.clear();
    _diastolicController.clear();
    _selectedDateController.clear();

    _pressureAdd.addPressure(pressure);
    _loadLatestPressure();
  }

  final WeightHeightAdd _weightHeightAdd = WeightHeightAdd();

  addWeightHeight(BuildContext context) {

    if (_selectedDate == null) return;

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

    if (mounted) {
    Navigator.of(context).pop();
  }

    _weightController.clear();
    _heightController.clear();
    _selectedDateController.clear();

    _weightHeightAdd.addWeightHeight(weightHeights);
    _loadLatestWeight();
  }

  final GlucoseAdd _glucoseAdd = GlucoseAdd();

  void addGlucose(BuildContext context) {
    if (_selectedDate == null || _glucoseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Há campos não preenchidos'),
        backgroundColor: Colors.red,
      ),
    );
      return;
    }

    String date = _dateFormat.format(_selectedDate!);
    String glucoseString = _glucoseController.text;
    int glucose = int.tryParse(glucoseString) ?? 0;
    bool isExpanded = false;

    GlucoseModel glucoses = GlucoseModel(
      id: const Uuid().v1(),
      date: date,
      glucose: glucose,
      isExpanded: isExpanded,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }

    _glucoseController.clear();
    _selectedDateController.clear();

    _glucoseAdd.addGlucose(glucoses);
    _loadLatestGlucose();
  }

  String? _glucoseErrorText;
  String? _dateErrorText;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                                "$nome!",
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
                    CustomTab(
                      text: 'Pressão',
                      subText: latestPressure != null
                          ? '${latestPressure!.sistolic}x${latestPressure!.diastolic}mmHg'
                          : '-mmHg',
                    ),
                    CustomTab(
                      text: 'Glicemia',
                      subText: latestGlucose != null
                          ? '${latestGlucose!.glucose}mg/Dl'
                          : '-mg/Dl',
                    ),
                    CustomTab(
                      text: 'Peso & Altura',
                      subText: latestWeightHeight != null
                          ? '${latestWeightHeight!.weight} kg, ${latestWeightHeight!.height} m, ${calculateIMC(latestWeightHeight!.weight, latestWeightHeight!.height)}kg/m²'
                          : '-kg, -m, -kg/m²',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ExtensionPanelPressure(
                        editCallback: (PressureModel updatedModel) {
                          setState(() {
                            latestPressure = updatedModel;
                          });
                        },
                        deleteCallback: (PressureModel pressure) async {
                          final latestPressureAux =
                              await PressureAdd().getLatestPressure();
                          setState(() {
                            latestPressure = latestPressureAux;
                          });
                        },
                      ),
                      // Conteúdo da aba Glicemia
                      ExtensionPanelGlucose(
                        editCallback: (GlucoseModel updatedModel) {
                          setState(() {
                            latestGlucose = updatedModel;
                          });
                        },
                        deleteCallback: (GlucoseModel glucose) async {
                          final latestGlucoseAux =
                              await GlucoseAdd().getLatestGlucose();
                          setState(() {
                            latestGlucose = latestGlucoseAux;
                          });
                        },
                      ),
                      // Conteúdo da aba Peso & Altura
                      ExtensionPanelWeightHeight(
                        editCallback: (WeightHeightModel updatedModel) {
                          setState(() {
                            latestWeightHeight = updatedModel;
                          });
                        },
                        deleteCallback: (WeightHeightModel weightHeight) async {
                          final latestWeightHeightAux =
                              await WeightHeightAdd().getLatestWeight();
                          setState(() {
                            latestWeightHeight = latestWeightHeightAux;
                          });
                        },
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
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 245, 245),
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    255, 63, 63, 63),
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
                                            addPressure(context);
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    136, 149, 83, 1),
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: _selectedDateController,
              decoration: InputDecoration(
                labelText: 'Data',
                labelStyle: const TextStyle(fontSize: 14),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(136, 149, 83, 1),
                  ),
                ),
                errorText: _dateErrorText,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _glucoseController,
                    onChanged: (value) {
                      setState(() {
                        _glucoseErrorText =
                            value.isEmpty ? 'Campo obrigatório' : null;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Glicemia',
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(136, 149, 83, 1)),
                      ),
                      errorText: _glucoseErrorText,
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
                      if (_glucoseController.text.isEmpty ||
                          _selectedDate == null) {
                        setState(() {
                          _glucoseErrorText =
                              _glucoseController.text.isEmpty
                                  ? 'Campo obrigatório'
                                  : null;
                          _dateErrorText = _selectedDate == null
                              ? 'Campo obrigatório'
                              : null;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _glucoseErrorText = null;
                            _dateErrorText = null;
                          });
                        });
                      } else {
                        addGlucose(context);
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(136, 149, 83, 1),
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
                                      const SizedBox(
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
                                  const SizedBox(
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
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 245, 245),
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    255, 63, 63, 63),
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
                                            addWeightHeight(context);
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    136, 149, 83, 1),
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
