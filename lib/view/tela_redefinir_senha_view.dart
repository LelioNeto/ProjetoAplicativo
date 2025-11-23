import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'tela_login_view.dart';

class TelaRedefinirSenhaView extends StatefulWidget {
  const TelaRedefinirSenhaView({super.key});

  @override
  State<TelaRedefinirSenhaView> createState() => _TelaRedefinirSenhaViewState();
}

class _TelaRedefinirSenhaViewState extends State<TelaRedefinirSenhaView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool carregando = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDeco({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38),
      ),
    );
  }

  // ============================================================
  // ENVIA O E-MAIL DE RECUPERAÇÃO
  // ============================================================
  void _redefinirSenha() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o e-mail.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => carregando = true);

    final auth = AuthService();
    final erro = await auth.redefinirSenha(email);

    setState(() => carregando = false);

    if (erro == null) {
      // SUCESSO → Email enviado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'E-mail de recuperação enviado! Verifique sua caixa de entrada.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaLoginView()),
      );
    } else {
      // FALHA → Mostra erro traduzido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Redefinir Senha'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'image/LogoChefList.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Digite o e-mail para receber um link de redefinição de senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDeco(
                            hint: 'E-mail',
                            icon: Icons.mail_outline,
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Informe seu e-mail'
                                  : null,
                        ),
                        const SizedBox(height: 24),

                        // Botão redefinir
                        SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            onPressed: carregando
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _redefinirSenha();
                                    }
                                  },
                            child: carregando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Enviar e-mail de redefinição',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .2,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Link voltar ao login
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Voltar ao Login',
                              style: TextStyle(color: Color(0xFFE74C3C)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
