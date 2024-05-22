import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/services/exams_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/exams_modal.dart';

class ExamModel {
  final String id;
  final String name;
  final String description;
  final String time;
  final String date;

  ExamModel({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'time': time,
      'date': date,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      time: map['time'],
      date: map['date'],
    );
  }
}


class ExtensionPanelExam extends StatefulWidget {
  const ExtensionPanelExam({Key? key}) : super(key: key);

  @override
  State<ExtensionPanelExam> createState() => _ExtensionPanelExamState();
}

class _ExtensionPanelExamState extends State<ExtensionPanelExam> {
  final ExamService examService = ExamService();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ExamModel>>(
        future: examService.fetchExamModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            );
          } else {
            if (snapshot.hasData) {
              final examModels = snapshot.data!;
              if (examModels.isEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/nenhumitem.png',
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Não há nenhum exame",
                        style: TextStyle(
                            color: Color.fromRGBO(136, 149, 83, 1),
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }
              examModels.sort((a, b) {
                final DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
                final DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
                return dateB.compareTo(dateA);
              });
              return ListView.builder(
                itemCount: examModels.length,
                itemBuilder: (context, index) {
                  final exam = examModels[index];
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          exam.date,
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
                              final updatedExam =
                                  await _showEditExamDialog(
                                      context, exam);

                              if (updatedExam != null) {
                                await examService
                                    .editExam(updatedExam);
                                setState(() {});
                              }
                            } else if (value == 'delete') {
                              await examService.deleteExam(exam.id);
                              setState(() {});
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
                              '${exam.name} - ${exam.description}',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromRGBO(135, 135, 135, 1)),
                            ),
                            Spacer(),
                            Text(
                              exam.time,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
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
                child: Text("Não há nenhum exame"),
              );
            }
          }
        },
      ),
    );
  }

  Future<ExamModel?> _showEditExamDialog(
      BuildContext context, ExamModel exam) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    nameController.text = exam.name;
    descriptionController.text = exam.description;
    timeController.text = exam.time;
    dateController.text = exam.date;

    return showDialog<ExamModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Editar Exame',
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Exame',
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
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
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
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Horário',
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
                          final updatedExam = ExamModel(
                            id: exam.id,
                            name: nameController.text,
                            description: descriptionController.text,
                            time: timeController.text,
                            date: dateController.text,
                          );
                          Navigator.of(context).pop(updatedExam);
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
