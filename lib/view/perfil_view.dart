import 'package:flutter/material.dart';

class TelaPerfilView extends StatelessWidget {
  const TelaPerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      backgroundColor: const Color(0xFF0F0F0F),
      body: const Center(
        child: Text(
          "Aqui ficará o perfil do usuário",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
