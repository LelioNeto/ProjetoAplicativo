import 'package:flutter/material.dart';
import 'tela_cadastro_view.dart';
import 'menu_view.dart'; // substitui tela_principal_view.dart se for o menu principal
import '../services/auth_service.dart';
import 'tela_redefinir_senha_view.dart';

class TelaLoginView extends StatefulWidget {
  const TelaLoginView({super.key});

  @override
  State<TelaLoginView> createState() => _TelaLoginViewState();
}

class _TelaLoginViewState extends State<TelaLoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void _realizarLogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um e-mail válido.'),
          backgroundColor: Colors.orangeAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final auth = AuthService();
    bool logado = await auth.login(email, senha);

    if (logado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha incorretos.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration buildInputDecoration(String label, IconData icon,
        {String? hintText}) {
      return InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 150, 54, 54),
            width: 2,
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 150, 54, 54),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 150, 54, 54),
            selectionColor: Color.fromARGB(255, 150, 54, 54),
            selectionHandleColor: Color.fromARGB(255, 150, 54, 54),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Image.asset('image/LogoChefList.png', height: 230),
              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: buildInputDecoration("E-mail", Icons.email),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: senhaController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: buildInputDecoration("Senha", Icons.lock),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _realizarLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Entrar"),
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaRedefinirSenhaView(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    overlayColor:
                        WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 54, 54),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Não tem uma conta?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaCadastroView(),
                        ),
                      );
                    },
                    child: const Text(
                      "Cadastre-se",
                      style: TextStyle(
                        color: Color.fromARGB(255, 150, 54, 54),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
