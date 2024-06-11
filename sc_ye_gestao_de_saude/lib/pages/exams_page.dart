import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Consulte seus ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "exames realizados:",
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      'lib/assets/exame.png',
                      height: 130,
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
      stream: FirebaseFirestore.instance.collection('exams').where('userId', isEqualTo: userId).snapshots(),
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
                const SizedBox(
                  height: 20,
                ),
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
        var categories = exams.map((e) => e['category']).toSet().toList();

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

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                title: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamListPage(category: category, userId: userId),
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
}

class ExamListPage extends StatelessWidget {
  final String category;
  final String userId;

  const ExamListPage({required this.category, required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exames - $category'),
      ),
      body: _buildExamList(context),
    );
  }

  Widget _buildExamList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('exams').where('userId', isEqualTo: userId).where('category', isEqualTo: category).snapshots(),
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
                const SizedBox(
                  height: 20,
                ),
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
            return Card(
              child: ListTile(
                leading: Image.network(exam['imageUrl']),
                title: Text(exam['imageName']),
                subtitle: Text('Data: ${exam['timestamp'].toDate().toString()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _deleteExam(context, exam);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exame deletado com sucesso!')),
                    );
                  },
                ),
                onTap: () => _showImageDialog(context, exam['imageUrl']),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteExam(BuildContext context, QueryDocumentSnapshot exam) async {
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
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
      },
    );
  }
}
