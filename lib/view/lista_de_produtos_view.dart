import 'package:flutter/material.dart';

class TelaListaComprasView extends StatelessWidget {
  const TelaListaComprasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Compras",
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
          "Aqui ficará a lista de compras",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
