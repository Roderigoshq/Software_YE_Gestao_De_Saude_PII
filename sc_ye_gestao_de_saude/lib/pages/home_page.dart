import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Index Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: IndexScreen(),
    );
  }
}

class IndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Aumentando o tamanho da AppBar
        child: AppBar(
          backgroundColor: Color(0xFF889553), // Cor de fundo da AppBar
          actions: [
            Spacer(), // Adiciona um espaçamento flexível entre os ícones e o texto
            IconButton(
              icon: Icon(
                Icons.info,
                color: Color(0xFFC6D687), // Cor do ícone
              ),
              onPressed: () {
                // Ação ao clicar no ícone de informação
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Color(0xFFC6D687), // Cor do ícone
              ),
              onPressed: () {
                // Ação ao clicar no ícone de configuração
              },
            ),
          ],
          title: Text(
            'YE Gestão de Saúde',
            style: TextStyle(
              color: Color(0xFFC6D687), // Cor do texto
              fontSize: 24, // Tamanho do texto aumentado
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20), // Adicionando o padding
        child: Container(
          color: Colors.white, // Fundo em branco
          child: Column(
            children: [
              // Adiciona a parte inferior da tela
              BottomContent(
                clienteNome: 'Usuário',
                imagePath: 'assets/user_image.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomContent extends StatelessWidget {
  final String clienteNome;
  final String imagePath;

  const BottomContent({
    required this.clienteNome,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: const Color(0xFFFFFFFF), // Cor de fundo
      child: Row(
        children: [
          // Texto à esquerda
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Olá, ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                        fontSize: 20, // Tamanho do texto aumentado
                      ),
                    ),
                    Text(
                      clienteNome,
                      style: TextStyle(
                        color: Color(0xFF889553), // Cor do texto
                        fontSize: 20, // Tamanho do texto aumentado
                        fontWeight: FontWeight.bold, // Deixando o texto em negrito
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5), // Espaçamento entre os textos
                // Texto adicional
                Text(
                  'Veja seus dados abaixo',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), // Cor do texto
                    fontSize: 16, // Tamanho do texto aumentado
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10), // Espaçamento entre o texto e a imagem
          // Imagem à direita
          CircleAvatar(
            radius: 30, // Aumenta o tamanho da imagem
            backgroundImage: AssetImage(imagePath),
          ),
        ],
      ),
    );
  }
}