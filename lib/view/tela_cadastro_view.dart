import 'package:flutter/material.dart';
import 'tela_login_view.dart';

class TelaCadastroView extends StatefulWidget {
  const TelaCadastroView({super.key});

  @override
  State<TelaCadastroView> createState() => _TelaCadastroViewState();
}

class _TelaCadastroViewState extends State<TelaCadastroView> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  void _realizarCadastro() {
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();
    String confirmaSenha = confirmaSenhaController.text.trim();
    String telefone = telefoneController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || confirmaSenha.isEmpty || telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Aqui você pode adicionar outras validações, como e-mail válido ou senha igual

    // Após validação, redireciona para login (ou salva no banco)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaLoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration buildInputDecoration(
      String label,
      IconData icon, {
      String? hintText,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent, // transparente
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
        title: const Text("Cadastro", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
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
              Image.asset('image/LogoChefList.png', height: 190),

              const SizedBox(height: 16),
              TextField(
                controller: nomeController,
                decoration: buildInputDecoration("Nome", Icons.person),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: buildInputDecoration("Email", Icons.email),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: buildInputDecoration("Senha", Icons.lock),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmaSenhaController,
                obscureText: true,
                decoration: buildInputDecoration("Confirme sua Senha", Icons.lock),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration(
                  "Número de Telefone",
                  Icons.phone,
                  hintText: "(99) 99999-9999",
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _realizarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Cadastrar"),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaLoginView()),
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Já tem uma conta? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: "Faça seu Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 150, 54, 54),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
