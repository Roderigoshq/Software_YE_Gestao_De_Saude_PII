import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
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
  const ConsultationModal({super.key});

  @override
  State<ConsultationModal> createState() => _ConsultationModalState();
}

class _ConsultationModalState extends State<ConsultationModal> {
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _descricaoCtrl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
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
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
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
            ),
          ),
          _buildHeader(context),
          if (isCarregando) const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(247, 242, 250, 1),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
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
            child: const Text(
              "Salvar",
              style: TextStyle(
                color: Color.fromRGBO(136, 149, 83, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
              color: Color.fromRGBO(81, 81, 81, 1)),
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
                color: Color.fromRGBO(81, 81, 81, 1)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'Escolha uma data',
                  style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 94, 94, 94)),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horário:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromRGBO(81, 81, 81, 1)),
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal:
10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'Escolha um horário',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 94, 94, 94)
                  ),
                ),
                const Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
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
              color: Color.fromRGBO(81, 81, 81, 1)),
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
              color: Color.fromRGBO(81, 81, 81, 1)),
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

  void _adicionarConsulta() {
    if (_formIsValid()) {
      final consultationModel = ConsultationModel(
        id: const Uuid().v4(),
        doctorName: _nomeCtrl.text,
        specialty: _selectedSpecialty!,
        time: _selectedTime != null ? _selectedTime!.format(context) : '',
        date: _selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
            : '',
        description: _descricaoCtrl.text,
        reminder: _reminder,
      );

      _consultationService.adicionarConsulta(consultationModel);
      Navigator.of(context).pop();
    } else {
      showSnackBar(
        context: context,
        texto: 'Há campos não preenchidos',
        isErro: true,
      );
    }
  }

  bool _formIsValid() {
    return _nomeCtrl.text.isNotEmpty &&
        _selectedSpecialty != null &&
        _selectedTime != null &&
        _selectedDate != null &&
        _descricaoCtrl.text.isNotEmpty;
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
