import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Consulte seus ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 29,
                            color: Color.fromRGBO(123, 123, 123, 1),
                          ),
                        ),
                        Text(
                          "exames:",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(65, 65, 65, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      'lib/assets/exame.png',
                      height: 110,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: user == null
                ? const Center(child: Text("Usuário não autenticado"))
                : _buildCategoryList(user.uid),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(String userId) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('exams')
        .where('userId', isEqualTo: userId)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return const Center(child: Text("Erro ao carregar exames."));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/nenhumitem.png',
                width: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Não há nenhum item",
                style: TextStyle(
                  color: Color.fromRGBO(136, 149, 83, 1),
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      var exams = snapshot.data!.docs;
      var categories = exams
          .map((e) {
            var data = e.data() as Map<String, dynamic>?; // Anotação de tipo explícita
            return data != null && data.containsKey('category')
                ? data['category']
                : null;
          })
          .where((category) => category != null)
          .toSet()
          .toList();

      Map<String, String> categoryDescriptions = {
        'Clinico geral': 'Consulta e exames de saúde geral.',
        'Cardiologia': 'Exames relacionados ao coração.',
        'Dermatologia': 'Exames de pele e condições dermatológicas.',
        'Endocrinologia': 'Exames hormonais e doenças endócrinas.',
        'Gastroenterologia': 'Exames do sistema digestivo.',
        'Ginecologia': 'Exames de saúde feminina.',
        'Neurologia': 'Exames do sistema nervoso.',
        'Oftalmologia': 'Exames de visão e saúde ocular.',
        'Ortopedia': 'Exames dos ossos e músculos.',
        'Pediatria': 'Exames de saúde infantil.',
        'Psiquiatria': 'Exames de saúde mental.',
      };

      return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          var description = categoryDescriptions[category] ?? '';

          // Filtrando os exames para esta categoria
          var categoryExams = exams.where((exam) {
            var data = exam.data() as Map<String, dynamic>;
            return data['category'] == category;
          }).toList();

          // Encontrando a data mais próxima antes de hoje
          var nearestDate = categoryExams.fold(DateTime(1900), (previousValue, element) {
            var data = element['date'] != null ? (element['date'] as Timestamp).toDate() : DateTime.now();
            return data.isBefore(DateTime.now()) && data.isAfter(previousValue) ? data : previousValue;
          });

          // Formatando a data mais próxima
          var formattedNearestDate = DateFormat('dd/MM/yyyy').format(nearestDate);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    category,
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
                                    color: Color.fromARGB(255, 66, 66, 66)),
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
                                        color:
                                            Color.fromRGBO(136, 149, 83, 1)),
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
                          await _deleteCategoryExams(userId, category);
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
              subtitle: Text(
                'Último exame: $formattedNearestDate',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExamListPage(category: category, userId: userId),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}

  Future<void> _deleteCategoryExams(String userId, String category) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('exams')
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .get();

      for (var doc in snapshot.docs) {
        String imageUrl = doc['imageUrl'];
        Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await imageRef.delete();
        await doc.reference.delete();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar exames: $e')),
      );
    }
  }
}

class ExamListPage extends StatelessWidget {
  final String category;
  final String userId;

  const ExamListPage({required this.category, required this.userId, Key? key})
      : super(key: key);

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
                  '${category} >',
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
          Expanded(
            child: _buildExamList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildExamList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exams')
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar exames."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/nenhumitem.png',
                  width: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "Não há nenhum item",
                  style: TextStyle(
                    color: Color.fromRGBO(136, 149, 83, 1),
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        var exams = snapshot.data!.docs;

        return ListView.builder(
          itemCount: exams.length,
          itemBuilder: (context, index) {
            var exam = exams[index];
            var data = exam.data() as Map<String, dynamic>;
            var title = data['imageName'] ?? 'Título desconhecido';
            var date = data['date'] != null
                ? (data['date'] as Timestamp).toDate()
                : DateTime.now(); // Verificação nula e atribuição de valor padrão
            var formattedDate =
                DateFormat('dd/MM/yyyy').format(date); // Formatando a data
            return ListTile(
  title: Text(
    title,
    style: const TextStyle(
      fontSize: 21,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Color.fromRGBO(85, 85, 85, 1),
    ),
  ),
  subtitle: Text(
    formattedDate,
    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300),
  ), // Exibindo a data formatada
  onTap: () => _showImageDialog(context, data['imageUrl']),
  trailing: Row(
    mainAxisSize: MainAxisSize.min, // Define o tamanho mínimo para a linha
    children: [
      IconButton(
        icon: const Icon(
          Icons.delete,
          color: Color.fromARGB(255, 104, 104, 104),
        ),
        onPressed: () =>  _confirmDelete(context, exam),
      ),
      const SizedBox(width: 8), // Adiciona um espaço entre os ícones
      Icon(
        Icons.arrow_right,
        color: Color.fromRGBO(85, 85, 85, 1),
        size: 35,
      ),
    ],
  ),
);

          },
        );
      },
    );
  }

  Future<void> _deleteExam(
      BuildContext context, QueryDocumentSnapshot exam) async {
    try {
      // Delete the image from Firebase Storage
      String imageUrl = exam['imageUrl'];
      Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await imageRef.delete();

      // Delete the document from Firestore
      await exam.reference.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar exame: $e')),
      );
    }
  }

  void _confirmDelete(BuildContext context, QueryDocumentSnapshot exam) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 66, 66, 66),
          ),
        ),
        content: const Text(
            'Tem certeza de que deseja excluir este exame?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(136, 149, 83, 1),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteExam(context, exam);
              Navigator.pop(context);
            },
            child: const Text('Confirmar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(136, 149, 83, 1),
                )),
          ),
        ],
      );
    },
  );
}

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fechar", style: TextStyle(color: Color.fromRGBO(136, 149, 83, 1)),),
              ),
            ],
          ),
        );
      },
    );
  }
}
