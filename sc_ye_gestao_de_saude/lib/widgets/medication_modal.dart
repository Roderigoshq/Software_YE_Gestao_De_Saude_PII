import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:uuid/uuid.dart';

void mostrarModelMedication(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return const MedicationModal();
    },
  );
}

class MedicationModal extends StatefulWidget {
  const MedicationModal({super.key});

  @override
  State<MedicationModal> createState() => _MedicationModalState();
}

class _MedicationModalState extends State<MedicationModal> {
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _dosagemCtrl = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedUnit = 'mg';

  bool isCarregando = false;

  final MedicationService _medicationService = MedicationService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color.fromRGBO(136, 149, 83, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "medicamentos",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: _adicionarMedicacao,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Color.fromRGBO(136, 149, 83, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Data:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Horário:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Medicamento:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nomeCtrl,
                  decoration: getAuthenticationInputDecoration(
                    hintText: 'Digite o nome do medicamento',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dosagem:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dosagemCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Digite a dosagem',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(136, 149, 83, 1),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<String>(
                      value: _selectedUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                        });
                      },
                      items: <String>['mg', 'ml', 'g', 'mcg']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            if (isCarregando) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void _adicionarMedicacao() async {
    if (_nomeCtrl.text.isEmpty || _dosagemCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
        ),
      );
      return;
    }

    setState(() {
      isCarregando = true;
    });

    final medicationModel = MedicationModel(
      id: const Uuid().v4(),
      name: _nomeCtrl.text,
      dosage: '${_dosagemCtrl.text} $_selectedUnit',
      time: _selectedTime.format(context),
      date: DateFormat('dd/MM/yyyy').format(_selectedDate),
    );

    await _medicationService.addMedication(medicationModel);

    setState(() {
      isCarregando = false;
    });

    Navigator.pop(context);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  InputDecoration getAuthenticationInputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }
}