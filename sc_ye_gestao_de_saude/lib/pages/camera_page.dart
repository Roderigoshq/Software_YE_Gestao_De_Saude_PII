import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sc_ye_gestao_de_saude/components/snackbar.dart'; // Adicionado para formatação de data e hora

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  bool _isCameraReady = false;
  bool _isUploading = false;

  final List<String> categories = [
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
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      await _controller.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      setState(() {
        _isCameraReady = false;
      });
    }
  }

  Future<void> _captureImage() async {
    try {
      if (!_controller.value.isInitialized) {
        return;
      }

      final imageFile = await _controller.takePicture();
      setState(() {});

      _showNameAndCategoryDialog(File(imageFile.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao capturar a imagem: $e')),
      );
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ThemeData.light().colorScheme.copyWith(
                  primary: const Color.fromRGBO(136, 149, 83, 1),
                  secondary: const Color.fromRGBO(136, 149, 83, 1),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _showNameAndCategoryDialog(File imageFile) {
    final _nameController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Registrar consulta',
            style: TextStyle(
                color: Color.fromARGB(255, 66, 66, 66),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration:
                    const InputDecoration(hintText: 'Digite o nome da foto'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                onTap: () => _selectDate(context),
                readOnly: true,
                decoration: const InputDecoration(hintText: 'Data do exame'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: const Text('Selecione a categoria'),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedCategory = newValue;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                    color: Color.fromRGBO(136, 149, 83, 1),
                    fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    selectedCategory != null &&
                    _selectedDate != null) {
                  _uploadImage(imageFile, _nameController.text,
                      selectedCategory!, _selectedDate!);
                  Navigator.of(context).pop();
                } else {
                  showSnackBar(
                      context: context,
                      texto: 'Por favor, preencha todos os campos',
                      isErro: true);
                }
              },
              child: const Text(
                'Salvar',
                style: TextStyle(
                    color: Color.fromRGBO(136, 149, 83, 1),
                    fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(
      File imageFile, String imageName, String category, DateTime date) async {
    try {
      setState(() {
        _isUploading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      String formattedDate = DateFormat('dd/MM/yyyy')
          .format(DateTime.now()); // Formatação da data e hora
      String filePath =
          'exams/${user.uid}/${category}/${imageName}_$formattedDate.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);

      await uploadTask.whenComplete(() => null);
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      await FirebaseFirestore.instance.collection('exams').add({
        'userId': user.uid,
        'imageUrl': downloadURL,
        'date': date,
        'imageName': imageName,
        'category': category,
      });

      setState(() {
        _isUploading = false;
      });

      showSnackBar(
          context: context,
          texto: 'Exame registrado com sucesso!',
          isErro: false);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer upload da imagem: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraReady
          ? Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: CameraPreview(_controller),
                    );
                  },
                ),
                if (_isUploading)
                  const Center(
                      child: CircularProgressIndicator(
                    color: Color.fromRGBO(136, 149, 83, 1),
                  )),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: _captureImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white,
                              width: 4), // Anel branco ao redor do botão
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.3),
                            ],
                            stops: [0.7, 1.0],
                            radius: 0.7,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(136, 149, 83, 1),
            )),
    );
  }
}
