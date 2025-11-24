import 'package:flutter/material.dart';
import 'tela_cadastro_view.dart';
import 'menu_view.dart';
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
  bool carregando = false;

  /// NOVO — controla exibir/ocultar senha
  bool mostrarSenha = false;

  // ==========================================================
  //   AJUSTADO PARA FUNCIONAR COM O NOVO AuthService
  // ==========================================================
  void _realizarLogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMsg('Por favor, preencha todos os campos.', Colors.redAccent);
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _mostrarMsg('Digite um e-mail válido.', Colors.orangeAccent);
      return;
    }

    setState(() => carregando = true);

    final auth = AuthService();
    String? erro = await auth.login(email, senha);

    setState(() => carregando = false);

    if (erro == null) {
      _mostrarMsg('Login realizado com sucesso!', Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuView()),
      );
    } else {
      _mostrarMsg(erro, Colors.redAccent);
    }
  }

  void _mostrarMsg(String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration buildInputDecoration(
      String label,
      IconData icon,
    ) {
      return InputDecoration(
        labelText: label,
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
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

              /// CAMPO EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: buildInputDecoration("E-mail", Icons.email),
              ),
              const SizedBox(height: 16),

              /// CAMPO SENHA COM OLHO
              TextField(
                controller: senhaController,
                obscureText: !mostrarSenha,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Senha",
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
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),

                  /// ÍCONE DE OLHO
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarSenha
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarSenha = !mostrarSenha;
                      });
                    },
                  ),

                  floatingLabelStyle: const TextStyle(
                    color: Color.fromARGB(255, 150, 54, 54),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// BOTÃO LOGIN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: carregando ? null : _realizarLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: carregando
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Entrar"),
                ),
              ),
              const SizedBox(height: 16),

              /// ESQUECI MINHA SENHA
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaRedefinirSenhaView(),
                    ),
                  );
                },
                child: const Text(
                  "Esqueci minha senha",
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 54, 54),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// CADASTRAR-SE
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
