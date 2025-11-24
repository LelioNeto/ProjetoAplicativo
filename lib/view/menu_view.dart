import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'tela_login_view.dart';
import 'lista_de_produtos_view.dart';
import 'receitas_view.dart';
import 'perfil_view.dart';
import 'tela_conversor_medidas_view.dart';
import 'sobre_view.dart';
import 'cronometro_view.dart';

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => tela));
  }

  // 🔥 NOVO: Card com gradiente + brilho suave + sombras premium
  Widget _buildBotaoMenu({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required Widget telaDestino,
  }) {
    return GestureDetector(
      onTap: () => _navegar(context, telaDestino),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        padding: const EdgeInsets.all(20),

        // ⭐ Estética premium aqui
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          // GRADIENTE SUTIL PRETO → CINZA ESCURO
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 20, 20, 20),
              Color.fromARGB(255, 36, 36, 36),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          // 💫 Glow / brilho suave nas bordas
          boxShadow: [
            
            BoxShadow(
  color: const Color.fromARGB(180, 0, 0, 0), // mais intensa
  blurRadius: 18,  // sombra maior e suave
  spreadRadius: 3, // leve expansão
  offset: const Offset(0, 6), // sombra para baixo
),

          ],

          // 🪞 Borda com leve brilho
          border: Border.all(
            color: const Color.fromARGB(110, 255, 255, 255),
            width: 1.2,
          ),
        ),

        // CONTEÚDO DO BOTÃO
        child: Row(
          children: [
            Icon(icone, color: Colors.white, size: 30),
            const SizedBox(width: 20),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 20,
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
        title: const Text("Menu", style: TextStyle(color: Colors.white)),
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
            onPressed: () => _navegar(context, const SobreView()),
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
              telaDestino: const ListaDeProdutosView(),
            ),

            _buildBotaoMenu(
              context: context,
              icone: Icons.restaurant_menu,
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
              icone: Icons.timer,
              titulo: "Cronômetro",
              telaDestino: const CronometroView(),
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
