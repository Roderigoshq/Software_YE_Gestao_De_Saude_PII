import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      await _uploadImageToFirebase(File(imageFile.path));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      // Cria uma referência para o Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('exams/${imageFile.uri.pathSegments.last}');
      // Faz upload da imagem
      final uploadTask = storageRef.putFile(imageFile);
      // Espera o upload ser concluído
      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();
      print('Imagem salva com sucesso no Firebase: $downloadUrl');
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
