import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/models/medication_model.dart';
import 'package:sc_ye_gestao_de_saude/services/medication_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/medication_modal.dart';

class MedicationPage extends StatefulWidget {
  const MedicationPage({super.key});

  @override
  MedicationPageState createState() => MedicationPageState();
}

class MedicationPageState extends State<MedicationPage> {
  final MedicationService dbService = MedicationService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchTerm = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Gerencie seus\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 29,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          ),
                          TextSpan(
                            text: "medicamentos:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Color.fromRGBO(65, 65, 65, 1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      'lib/assets/pilula.png',
                      height: 130,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MedicationModel>>(
              stream: dbService.getMedications(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('lib/assets/nenhumitem.png', width: 100),
                        const SizedBox(height: 20),
                        const Text(
                          "Não há nenhum item",
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
                var medications = snapshot.data!;
                return ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    var medication = medications[index];
                    return ListTile(
                      title: Text(
                        '${medication.hour}:${medication.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 24, // Tamanho da fonte maior
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        medication.name,
                        style: const TextStyle(
                          fontSize: 18, // Tamanho da fonte maior
                        ),
                      ),
                      onTap: () async {
                        bool? result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => MedicationModal(medication: medication),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'delete') {
                            bool? confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Confirmar Exclusão',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 66, 66, 66)),
                                  ),
                                  content: const Text('Tem certeza de que deseja excluir essa medicação?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color.fromRGBO(136, 149, 83, 1)
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text(
                                        'Confirmar',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color.fromRGBO(136, 149, 83, 1)
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              await dbService.deleteMedication(medication.id);
                              setState(() {
                                medications.removeAt(index);
                              });
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Excluir'),
                            ),
                          ];
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const MedicationModal(),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add, size: 36, color: Colors.white),
        backgroundColor: const Color.fromRGBO(136, 149, 83, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
