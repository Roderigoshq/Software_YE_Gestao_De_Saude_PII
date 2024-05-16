// import 'dart:typed_data';
// import 'package:image/image.dart' as img;

// Future<img.Image?> preprocessImage(Uint8List imageBytes) async {
//   try {
//     // Decodificar a imagem
//     img.Image? image = img.decodeImage(imageBytes);

//     if (image != null) {
//       // Redimensionar a imagem para um tamanho adequado
//       image = img.copyResize(image, width: 300);

//       // Aplicar filtro para remover ruídos (opcional)
//       // image = img.gaussianBlur(image, 5);

//       return image;
//     } else {
//       print('Erro ao decodificar a imagem');
//       return null;
//     }
//   } catch (e) {
//     print('Erro ao pré-processar a imagem: $e');
//     return null;
//   }
// }
