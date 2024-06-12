import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:uuid/uuid.dart';

class MedicationDetailsModal extends StatefulWidget {
  final MedicationModel medication;

  const MedicationDetailsModal({super.key, required this.medication});

  @override
  State<MedicationDetailsModal> createState() => _MedicationDetailsModalState();
}

class _MedicationDetailsModalState extends State<MedicationDetailsModal> {
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late bool _reminder;
  late List<DateTime> _dates;
  late TimeOfDay _time;
  bool isCarregando = false;
  final MedicationService _medicationService = MedicationService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medication.name);
    _dosageController = TextEditingController(text: widget.medication.dosage);
    _reminder = widget.medication.reminder;
    _dates = widget.medication.dates.map((date) => DateFormat('yyyy-MM-dd').parse(date)).toList();
    _time = TimeOfDay(hour: widget.medication.hour, minute: widget.medication.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Medicamento'),
        backgroundColor: Color.fromRGBO(136, 149, 83, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_nameController, 'Nome do Medicamento:', 'Digite o nome do medicamento'),
              SizedBox(height: 20),
              _buildTextField(_dosageController, 'Dosagem:', 'Digite a dosagem'),
              SizedBox(height: 20),
              _buildDateField(),
              SizedBox(height: 20),
              _buildTimeField(),
              SizedBox(height: 20),
              _buildReminderSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: hintText),
          readOnly: true, // Configurado para ser somente leitura
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dias de uso:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Wrap(
          children: _dates.map((date) => Chip(
            label: Text(DateFormat('dd/MM/yyyy').format(date)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Horário:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text('${_time.format(context)}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildReminderSwitch() {
    return SwitchListTile(
      title: Text('Lembrete ativado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      value: _reminder,
      onChanged: null, // Configurado para ser somente leitura
    );
  }
}
