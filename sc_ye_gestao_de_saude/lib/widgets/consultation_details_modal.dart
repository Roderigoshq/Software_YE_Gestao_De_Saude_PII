import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:uuid/uuid.dart';

class ConsultationsDetailsModal extends StatefulWidget {
  final String? id;
  final String specialty;
  final String doctorName;
  final String date;
  final String time;
  final String description;
  final bool reminder;

  const ConsultationsDetailsModal({
    super.key,
    this.id,
    required this.specialty,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.description,
    required this.reminder,
  });

  @override
  State<ConsultationsDetailsModal> createState() =>
      _ConsultationsDatailsModalState();
}

class _ConsultationsDatailsModalState extends State<ConsultationsDetailsModal> {
  late TextEditingController _nomeCtrl;
  late TextEditingController _descricaoCtrl;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String? _selectedSpecialty;
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
  void initState() {
    super.initState();

    _nomeCtrl = TextEditingController(text: widget.doctorName);
    _descricaoCtrl = TextEditingController(text: widget.description);
    _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.date);
    _reminder = widget.reminder;
    final timeParts = widget.time.split(":");
    if (timeParts.length == 2) {
      final minutePart = timeParts[1];
      final period = minutePart.contains('AM') ? 'AM' : 'PM';
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute =
          int.tryParse(minutePart.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      int adjustedHour = hour;
      if (period == 'PM' && hour < 12) {
        adjustedHour = hour + 12;
      } else if (period == 'AM' && hour == 12) {
        adjustedHour = 0;
      }

      _selectedTime = TimeOfDay(hour: adjustedHour, minute: minute);
    } else {
      _selectedTime = TimeOfDay.now(); // Valor padrão caso haja falha
    }

    _selectedSpecialty = widget.specialty;
  }

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
          if (isCarregando) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color:
          const Color.fromRGBO(247, 242, 250, 1), // Adicionando o fundo branco
      padding: const EdgeInsets.all(16), // Ajuste o padding conforme necessário
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
            onTap: _editarConsulta,
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

  Widget _buildDropdownField() {
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
        GestureDetector(
          onTap: () {},
          child: AbsorbPointer(
            child: DropdownButtonFormField<String>(
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
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
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

  Column _buildReminderSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lembrete:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          value: _reminder,
          onChanged: (bool value) {
            setState(() {
              _reminder = value;
            });
          },
          title: const Text('Deseja ativar o lembrete?'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime, builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ThemeData.light().colorScheme.copyWith(
                  primary: const Color.fromRGBO(136, 149, 83, 1),
                  secondary: const Color.fromRGBO(136, 149, 83, 1),
                ),
          ),
          child: child!,
        );
      },);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  InputDecoration getAuthenticationInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromRGBO(136, 149, 83, 1)),
      ),
    );
  }

  void _editarConsulta() async {
    setState(() {
      isCarregando = true;
    });

    final String specialty = _selectedSpecialty!;
    final String doctorName = _nomeCtrl.text;
    final String date = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final String time = _selectedTime.format(context);
    final String description = _descricaoCtrl.text;
    final bool reminder = _reminder;

    final consulta = ConsultationModel(
      id: widget.id ?? const Uuid().v4(),
      specialty: specialty,
      doctorName: doctorName,
      date: date,
      time: time,
      description: description,
      reminder: reminder,
    );

    if (widget.id != null) {
      await _consultationService.editConsultation(
        widget.id,
        specialty,
        doctorName,
        date,
        time,
        description,
        reminder,
      );
    } else {
      await _consultationService.addConsultation(consulta);
    }

    setState(() {
      isCarregando = false;
    });

    Navigator.pop(context, consulta);
  }
}
