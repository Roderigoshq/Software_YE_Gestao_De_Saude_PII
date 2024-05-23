import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:uuid/uuid.dart';

void mostrarModelConsultation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return const ConsultationModal();
    },
  );
}

class ConsultationModal extends StatefulWidget {
  const ConsultationModal({Key? key}) : super(key: key);

  @override
  State<ConsultationModal> createState() => _ConsultationModalState();
}

class _ConsultationModalState extends State<ConsultationModal> {
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _descricaoCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedSpecialty;
  bool _reminder = false;
  bool isCarregando = false;
  final ConsultationService _consultationService = ConsultationService();

  final List<String> specialties = [
    'Clinico geral',
    'Cardiologia',
    'Dermatologia',
    'Endocrinologia',
    'Gastroenterologia',
    'Ginecologia',
    'Neurologia',
    'Oftalmologia',
    'Ortopedia',
    'Pediatria',
    'Psiquiatria',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const Divider(),
                const SizedBox(height: 20),
                _buildDropdownField(),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nomeCtrl,
                  label: 'Nome do Médico:',
                  hintText: 'Digite o nome do médico',
                ),
                const SizedBox(height: 16),
                _buildDateField(context),
                const SizedBox(height: 20),
                _buildTimeField(context),
                const SizedBox(height: 20),
                _buildLargeTextField(
                  controller: _descricaoCtrl,
                  label: 'Descrição:',
                  hintText: 'Digite a descrição',
                ),
                const SizedBox(height: 20),
                _buildReminderSwitch(),
              ],
            ),
            if (isCarregando) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancelar",
            style: TextStyle(
              color: Color.fromRGBO(136, 149, 83, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text(
          "Consultas",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: _adicionarConsulta,
          child: Text(
            "Salvar",
            style: TextStyle(
              color: Color.fromRGBO(136, 149, 83, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Especialidade:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedSpecialty,
          items: specialties.map((String specialty) {
            return DropdownMenuItem<String>(
              value: specialty,
              child: Text(specialty),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedSpecialty = newValue;
            });
          },
          decoration: getAuthenticationInputDecoration(
            hintText: 'Selecione a especialidade',
          ),
        ),
      ],
    );
  }

  GestureDetector _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
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
        ],
      ),
    );
  }

  GestureDetector _buildTimeField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horário:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
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
        ],
      ),
    );
  }

  Column _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: getAuthenticationInputDecoration(hintText: hintText),
        ),
      ],
    );
  }

  Column _buildLargeTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: getAuthenticationInputDecoration(hintText: hintText),
        ),
      ],
    );
  }

  Widget _buildReminderSwitch() {
    return SwitchListTile(
      title: const Text(
        'Ativar lembrete',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      value: _reminder,
      onChanged: (bool value) {
        setState(() {
          _reminder = value;
        });
      },
      activeColor: const Color.fromRGBO(136, 149, 83, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  void _adicionarConsulta() async {
    if (_nomeCtrl.text.isEmpty || _selectedSpecialty == null) {
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

    final consultationModel = ConsultationModel(
      id: const Uuid().v4(),
      doctorName: _nomeCtrl.text,
      specialty: _selectedSpecialty!,
      time: _selectedTime.format(context),
      date: DateFormat('dd/MM/yyyy').format(_selectedDate),
      description: _descricaoCtrl.text,
    );

    await _consultationService.addConsultation(consultationModel);

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
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
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
