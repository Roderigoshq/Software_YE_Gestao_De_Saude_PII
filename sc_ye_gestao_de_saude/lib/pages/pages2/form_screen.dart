 import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/data/task_inherited.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/initial_screen.dart';


class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.taskContext});

  final BuildContext taskContext;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late DateTime selectedDateTime = DateTime.now(); // Data selecionada inicialmente

  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF889553),
          title: Row(
            children: [
              Spacer(),
              IconButton(
                icon: const Icon(Icons.info, color: Color(0xFFC6D687)),
                iconSize: 30,
                onPressed: () {
                  // Ação ao clicar no ícone de informação
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFFC6D687)),
                iconSize: 30,
                onPressed: () {
                  // Ação ao clicar no ícone de configuração
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Adicionar Medicamento',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => _selectDateTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Data e Hora',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (valueValidator(value)) {
                        return 'Insira o nome do medicamento';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nome do Medicamento',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       TaskInherited.of(widget.taskContext).newTask(
                  //         selectedDateTime.toString(),
                  //         '',
                  //         0,
                  //       );
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content: Text('Criando uma nova medicação'),
                  //         ),
                  //       );
                  //       Navigator.pop(context);
                  //     }
                  //   },
                  //   child: const Text('Salvar'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}