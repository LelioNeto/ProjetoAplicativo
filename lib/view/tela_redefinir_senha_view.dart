import 'package:flutter/material.dart';

class TelaRedefinirSenhaView extends StatefulWidget {
  const TelaRedefinirSenhaView({super.key});

  @override
  State<TelaRedefinirSenhaView> createState() => _TelaRedefinirSenhaViewState();
}

class _TelaRedefinirSenhaViewState extends State<TelaRedefinirSenhaView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

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
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white38),
      ),
    );
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
                  // Logo no mesmo estilo do login
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
                    'Informe o e-mail para o qual deseja redefinir a sua senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDeco(
                            hint: 'Email',
                            icon: Icons.mail_outline,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Informe seu e-mail'
                              : null,
                        ),
                        const SizedBox(height: 24),

                        // Botão "pílula" branco como na tela de login
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
                            onPressed: () {
                              // Somente UI / feedback visual
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Front-end pronto (sem integração).',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Redefinir senha',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Link em vermelho, igual ao estilo do login
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
