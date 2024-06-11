import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraReady = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
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

      _showNameDialog(File(imageFile.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao capturar a imagem: $e')),
      );
    }
  }

  void _showNameDialog(File imageFile) {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nome da Foto'),
          content: TextField(
            controller: _nameController,
            decoration:
                const InputDecoration(hintText: 'Digite o nome da foto'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  _uploadImage(imageFile, _nameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(File imageFile, String imageName) async {
    try {
      setState(() {
        _isUploading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado.');
      }

      String filePath =
          'exams/${user.uid}/${imageName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);

      await uploadTask.whenComplete(() => null);
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      await FirebaseFirestore.instance.collection('exams').add({
        'userId': user.uid,
        'imageUrl': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
        'imageName': imageName,
      });

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload realizado com sucesso!')));
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraReady
          ? Stack(
              children: [
                CameraPreview(_controller),
                if (_isUploading)
                  const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 30,
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
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
