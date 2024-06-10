import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_modal.dart';

import 'consultation_details.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  ConsultationPageState createState() => ConsultationPageState();
}

class ConsultationPageState extends State<ConsultationPage> {
  final ConsultationService dbService = ConsultationService();
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
                            text: "Gerencie suas\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 29,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          ),
                          TextSpan(
                            text: "consultas:",
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
                      'lib/assets/consulta.png',
                      height: 130,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 241, 241, 241),
                      hintText: 'Busque uma especialidade',
                      hintStyle: TextStyle(color: Color.fromARGB(255, 175, 175, 175)),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide
                            .none, // Remove the border by setting it to none
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide
                            .none, // Remove the border by setting it to none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide
                            .none, // Remove the border by setting it to none
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value.toLowerCase();
                      });
                    },
                  ),
                ),
                if (_isSearching)
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                      setState(() {
                        _searchTerm = '';
                        _isSearching = false;
                      });
                    },
                    child: const Text('Cancelar', style: TextStyle(color: Color.fromRGBO(
                                                    136, 149, 83, 1)),),
                  ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ConsultationModel>>(
              stream: dbService.getConsultations(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/nenhumitem.png',
                          width: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                var consultas = snapshot.data!;
                var groupedConsultas = _groupAndSortConsultas(consultas);

                // Filtrar consultas por termo de busca
                var filteredConsultas =
                    groupedConsultas.keys.where((specialty) {
                  return specialty.toLowerCase().contains(_searchTerm);
                }).toList();

                return ListView.builder(
                  itemCount: filteredConsultas.length,
                  itemBuilder: (context, index) {
                    var specialty = filteredConsultas[index];
                    var consultasBySpecialty = groupedConsultas[specialty]!;

                    var nextConsultationDate =
                        _getNextConsultationDate(consultasBySpecialty);

                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              specialty,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(85, 85, 85, 1),
                              ),
                            ),
                            const Spacer(),
                            PopupMenuButton<String>(
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
                                              color: Color.fromARGB(
                                                  255, 66, 66, 66)),
                                        ),
                                        content: const Text(
                                            'Tem certeza de que deseja excluir todas as consultas desta especialidade?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Color.fromRGBO(
                                                      136, 149, 83, 1)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Confirmar',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Color.fromRGBO(
                                                        136, 149, 83, 1))),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmDelete == true) {
                                    await dbService
                                        .deleteConsultationsBySpecialty(
                                            specialty);
                                    setState(() {});
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
                            const Icon(
                              Icons.arrow_right,
                              color: Color.fromRGBO(85, 85, 85, 1),
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                      subtitle: nextConsultationDate != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Próxima consulta: ${DateFormat('dd/MM/yyyy').format(nextConsultationDate)}',
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Não há consulta marcada'),
                            ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultationDetails(
                              specialty: specialty,
                              consultations: consultasBySpecialty,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 40),
        child: GestureDetector(
          onTap: () async {
            bool? result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const ConsultationModal(),
            );

            if (result == true) {
              // Atualizar a lista de consultas
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromRGBO(136, 149, 83, 1), width: 8),
              color: const Color.fromRGBO(136, 149, 83, 1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Map<String, List<ConsultationModel>> _groupAndSortConsultas(
      List<ConsultationModel> consultas) {
    // Agrupar consultas por especialidade
    Map<String, List<ConsultationModel>> groupedConsultas = {};
    for (var consulta in consultas) {
      if (!groupedConsultas.containsKey(consulta.specialty)) {
        groupedConsultas[consulta.specialty] = [];
      }
      groupedConsultas[consulta.specialty]!.add(consulta);
    }

    // Ordenar as especialidades em ordem alfabética
    var sortedKeys = groupedConsultas.keys.toList()..sort();

    // Ordenar as consultas dentro de cada especialidade pela data em ordem decrescente
    for (var specialty in sortedKeys) {
      groupedConsultas[specialty]!.sort((a, b) {
        final dateA = DateFormat('dd/MM/yyyy').parse(a.date);
        final dateB = DateFormat('dd/MM/yyyy').parse(b.date);
        return dateB.compareTo(dateA); // Ordem decrescente
      });
    }

    // Criar um novo mapa com as especialidades ordenadas
    Map<String, List<ConsultationModel>> sortedGroupedConsultas = {
      for (var specialty in sortedKeys) specialty: groupedConsultas[specialty]!
    };

    return sortedGroupedConsultas;
  }

  DateTime? _getNextConsultationDate(List<ConsultationModel> consultas) {
    DateTime now = DateTime.now();
    DateTime? nextDate;

    for (var consulta in consultas) {
      DateTime consultationDate = DateFormat('dd/MM/yyyy').parse(consulta.date);
      if (consultationDate.isAfter(now)) {
        if (nextDate == null || consultationDate.isBefore(nextDate)) {
          nextDate = consultationDate;
        }
      }
    }

    return nextDate;
  }
}
