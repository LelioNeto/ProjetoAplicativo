import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class TelaPerfilView extends StatefulWidget {
  const TelaPerfilView({super.key});

  @override
  State<TelaPerfilView> createState() => _TelaPerfilViewState();
}

class _TelaPerfilViewState extends State<TelaPerfilView> {
  String? nomeCompleto;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final nome = await AuthService().nomeUsuarioLogado();
    setState(() {
      nomeCompleto = nome ?? 'Usuário';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// --- ÍCONE DO USUÁRIO ---
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            /// --- NOME COMPLETO ABAIXO DO ÍCONE ---
            Text(
              nomeCompleto ?? 'Usuário',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            /// --- SEÇÃO SOBRE O APLICATIVO ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sobre',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Este aplicativo foi desenvolvido para gerenciar receitas, lista de compras e outras funcionalidades de culinária de forma prática e intuitiva.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
