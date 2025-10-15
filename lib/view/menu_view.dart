import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'tela_login_view.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout(); // remove login salvo
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaLoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        // 🔹 Aqui colocamos o botão à esquerda
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Sair",
          onPressed: () => _logout(context),
        ),
      ),
     
    );
  }
}
