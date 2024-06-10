import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/models/consultation_model.dart';
import 'package:sc_ye_gestao_de_saude/services/consultation_service.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_details_add_modal.dart';
import 'package:sc_ye_gestao_de_saude/widgets/consultation_details_modal.dart';

class ConsultationDetails extends StatefulWidget {
  final String specialty;
  final List<ConsultationModel> consultations;

  const ConsultationDetails(
      {super.key, required this.specialty, required this.consultations});

  @override
  _ConsultationDetailsState createState() => _ConsultationDetailsState();
}

class _ConsultationDetailsState extends State<ConsultationDetails> {
  late List<ConsultationModel> consultations;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchTerm = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    consultations = List.from(widget.consultations);
    _sortConsultations();

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });
  }

  void _sortConsultations() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    consultations.sort((a, b) {
      final dateA = dateFormat.parse(a.date);
      final dateB = dateFormat.parse(b.date);
      return dateB.compareTo(dateA);
    });
  }

  Future<void> _editConsultation(int index) async {
    var editedConsultation = await showModalBottomSheet<ConsultationModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ConsultationsDetailsModal(
        id: consultations[index].id,
        specialty: consultations[index].specialty,
        doctorName: consultations[index].doctorName,
        date: consultations[index].date,
        time: consultations[index].time,
        description: consultations[index].description,
        reminder: consultations[index].reminder,
      ),
    );

    if (editedConsultation != null) {
      setState(() {
        consultations[index] = editedConsultation;
        _sortConsultations();
      });
    }
  }

  ConsultationService dbService = ConsultationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 20, color: Color.fromRGBO(123, 123, 123, 1)),
                ),
                const SizedBox(width: 20),
                Text(
                  '${widget.specialty} >',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Color.fromRGBO(123, 123, 123, 1),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 241, 241, 241),
                      hintText: 'Busque uma data, horario, descrição',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 175, 175, 175)),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
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
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Color.fromRGBO(136, 149, 83, 1)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                var consultation = consultations[index];

                // Filter consultations based on the search term
                if (!_searchTerm.isEmpty &&
                    !consultation.date.toLowerCase().contains(_searchTerm) &&
                    !consultation.doctorName
                        .toLowerCase()
                        .contains(_searchTerm) &&
                    !consultation.description
                        .toLowerCase()
                        .contains(_searchTerm) &&
                    !consultation.time.toLowerCase().contains(_searchTerm)) {
                  return Container(); // Return an empty container if the consultation does not match the search term
                }

                return ListTile(
                  onTap: () => _editConsultation(index),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          consultation.date,
                          style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(85, 85, 85, 1),
                          ),
                        ),
                        Spacer(),
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
                                          color:
                                              Color.fromARGB(255, 66, 66, 66)),
                                    ),
                                    content: const Text(
                                        'Tem certeza de que deseja excluir este registro?'),
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
                                    .deleteConsultation(consultation.id);
                                setState(() {
                                  consultations.removeAt(index);
                                });
                              }
                            } else if (value == 'edit') {
                              _editConsultation(index);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Excluir'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Editar'),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
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
            ConsultationModel? newConsultation =
                await showModalBottomSheet<ConsultationModel>(
              context: context,
              isScrollControlled: true,
              builder: (context) => ConsultationDetailsAddModal(
                specialty: widget.specialty,
              ),
            );

            if (newConsultation != null) {
              setState(() {
                consultations.add(newConsultation);
                _sortConsultations();
              });
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
}
