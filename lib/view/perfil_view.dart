import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaPerfilView extends StatefulWidget {
  const TelaPerfilView({super.key});

  @override
  State<TelaPerfilView> createState() => _TelaPerfilViewState();
}

class _TelaPerfilViewState extends State<TelaPerfilView> {
  String? nomeCompleto;
  String? email;
  String? telefone;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid)
        .get();

    final data = doc.data();

    setState(() {
      nomeCompleto = data?["nome"] ?? "Usuário";
      email = data?["email"] ?? "Não informado";
      telefone = _formatarTelefone(data?["telefone"]);
    });
  }

  /// Formatação padrão: (XX) XXXXX-XXXX
  String _formatarTelefone(String? raw) {
    if (raw == null || raw.trim().isEmpty) return "Não informado";

    String n = raw.replaceAll(RegExp(r'\D'), '');

    if (n.length == 11) {
      return "(${n.substring(0, 2)}) ${n.substring(2, 7)}-${n.substring(7)}";
    } else if (n.length == 10) {
      return "(${n.substring(0, 2)}) ${n.substring(2, 6)}-${n.substring(6)}";
    }

    return raw;
  }

  /// 🟥 CARD PREMIUM — icone + label + valor
  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 20, 20, 20),
            Color.fromARGB(255, 36, 36, 36),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(180, 0, 0, 0),
            blurRadius: 18,
            spreadRadius: 3,
            offset: const Offset(0, 6),
          ),
        ],

        border: Border.all(
          color: const Color.fromARGB(110, 255, 255, 255),
          width: 1.2,
        ),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        //centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🟡 Avatar Premium com efeito Glow e borda iluminada
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 180, 180, 180),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(150, 0, 0, 0),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFF1A1A1A),
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
            ),

            const SizedBox(height: 18),

            /// Nome
            Text(
              nomeCompleto ?? "Usuário",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 35),

            /// CARDS PREMIUM
            _infoCard(
              icon: Icons.email_outlined,
              label: "E-mail",
              value: email ?? "...",
            ),

            _infoCard(
              icon: Icons.phone_android,
              label: "Telefone",
              value: telefone ?? "...",
            ),
          ],
        ),
      ),
    );
  }
}
