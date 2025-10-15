import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'tela_login_view.dart';
import 'lista_de_produtos_view.dart';
import 'receitas_view.dart';
import 'perfil_view.dart';
import 'tela_conversor_medidas_view.dart';
import 'sobre_view.dart'; // import da nova tela "Sobre"

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaLoginView()),
    );
  }

  void _navegar(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  Widget _buildBotaoMenu({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required Widget telaDestino,
  }) {
    return GestureDetector(
      onTap: () => _navegar(context, telaDestino),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icone, color: Colors.white, size: 28),
            const SizedBox(width: 20),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
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
        actions: [
          IconButton(
            tooltip: "Sobre",
            onPressed: () {
              _navegar(context, const SobreView());
            },
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.question_mark, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            _buildBotaoMenu(
              context: context,
              icone: Icons.list,
              titulo: "Lista de Compras",
              telaDestino: const TelaListaComprasView(),
            ),
            _buildBotaoMenu(
              context: context,
              icone: Icons.fastfood,
              titulo: "Receitas",
              telaDestino: const TelaReceitasView(),
            ),
            _buildBotaoMenu(
              context: context,
              icone: Icons.straighten,
              titulo: "Conversor de Medidas",
              telaDestino: const TelaConversorMedidasView(),
            ),
            _buildBotaoMenu(
              context: context,
              icone: Icons.person,
              titulo: "Perfil",
              telaDestino: const TelaPerfilView(),
            ),
          ],
        ),
      ),
    );
  }
}
