import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/exams_service.dart';
import 'package:sc_ye_gestao_de_saude/models/exams_model.dart';
import 'package:uuid/uuid.dart';

void mostrarModelExam(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return const ExamModal();
    },
  );
}

class ExamModal extends StatefulWidget {
  const ExamModal({Key? key}) : super(key: key);

  @override
  State<ExamModal> createState() => _ExamModalState();
}

class _ExamModalState extends State<ExamModal> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  bool isCarregando = false;

  final ExamService _examService = ExamService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.8,
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
                const SizedBox(height: 16),
                _buildDateField(context),
                const SizedBox(height: 20),
                _buildTimeField(context),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nameCtrl,
                  label: 'Nome do Exame:',
                  hintText: 'Digite o nome do exame',
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionCtrl,
                  label: 'Descrição:',
                  hintText: 'Digite a descrição do exame',
                  minLines: 3,
                  maxLines: 5,
                ),
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
          "Exames",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: _adicionarExame,
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
    int? minLines,
    int? maxLines,
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
          minLines: minLines,
          maxLines: maxLines,
        ),
      ],
    );
  }

  void _adicionarExame() async {
    if (_nameCtrl.text.isEmpty || _descriptionCtrl.text.isEmpty) {
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

    final examModel = ExamModel(
      id: const Uuid().v4(),
      name: _nameCtrl.text,
      description: _descriptionCtrl.text,
      time: _selectedTime.format(context),
      date: DateFormat('dd/MM/yyyy').format(_selectedDate),
    );

    await _examService.addExam(examModel);

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
