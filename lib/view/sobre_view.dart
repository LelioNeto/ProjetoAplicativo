import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text(
          "Sobre o Aplicativo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Este aplicativo foi desenvolvido com o objetivo de facilitar o "
          "gerenciamento de receitas, listas de compras e conversões de medidas "
          "culinárias, tudo em um só lugar. Com ele, o usuário pode cadastrar "
          "suas receitas favoritas, visualizar ingredientes, marcar favoritos e "
          "organizar seu dia a dia na cozinha de forma prática e intuitiva.",
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
