import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

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
  }

  Future<void> _captureImage() async {
    try {
      final imageFile = await _controller.takePicture();
      setState(() {
        _imageFile = imageFile;
      });

      // Analisar a imagem quando capturada
      await analyzeImage(File(imageFile.path).readAsBytesSync());
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = pickedFile;
  //     });

  //     // Analisar a imagem quando selecionada da galeria
  //     await analyzeImage(File(pickedFile.path).readAsBytesSync());
  //   }
  // }

  Future<void> analyzeImage(Uint8List imageBytes) async {
    final url = 'URL_DA_SUA_API/analisar_imagem'; // Substitua pela URL da sua API

    try {
      // Codificar a imagem para base64
      String base64Image = base64Encode(imageBytes);

      // Fazer uma solicitação POST para a API com a imagem codificada
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      // Verificar se a solicitação foi bem-sucedida e exibir o resultado
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('Resultado da análise: ${data['result']}');
      } else {
        print('Erro ao analisar a imagem');
      }
    } catch (e) {
      print('Erro ao conectar à API');
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
