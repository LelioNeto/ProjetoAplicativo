import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'tela_login_view.dart';
import 'lista_de_produtos_view.dart';
import 'receitas_view.dart';
import 'perfil_view.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaLoginView()),
    );
  }

  void _abrirTela(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  Widget _botaoMenu(BuildContext context, IconData icone, String titulo, Widget tela) {
    return GestureDetector(
      onTap: () => _abrirTela(context, tela),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icone, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Text(
              titulo,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Sair",
          onPressed: () => _logout(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _botaoMenu(context, Icons.list, "Lista de Compras", const TelaListaComprasView()),
          _botaoMenu(context, Icons.fastfood, "Receitas", const TelaReceitasView()),
          _botaoMenu(context, Icons.person, "Perfil", const TelaPerfilView()),
        ],
      ),
    );
  }
}
