import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraReady = false;
  late XFile _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Obtém a lista de câmeras disponíveis no dispositivo
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // Inicializa o controlador da câmera
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _controller.initialize();

    if (!mounted) return;

    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> _captureImage() async {
    try {
      // Captura a imagem
      final imageFile = await _controller.takePicture();
      setState(() {
        _imageFile = imageFile;
      });

      // Faz upload da imagem para o Firebase Storage
      await uploadImage(File(imageFile.path));
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage(File imageFile) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    String filePath = 'exams/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);

    await uploadTask.whenComplete(() => null);
    String downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();

    await FirebaseFirestore.instance.collection('exams').add({
      'userId': user.uid,
      'imageUrl': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Erro ao fazer upload da imagem: $e');
  }
}

  @override
  void dispose() {
    // Libera o controlador da câmera quando o widget for descartado
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: _isCameraReady
          ? CameraPreview(_controller)
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureImage,
        child: Icon(Icons.camera),
      ),
    );
  }
}
