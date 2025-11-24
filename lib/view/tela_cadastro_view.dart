import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tela_login_view.dart';
import '../services/auth_service.dart';

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

  bool mostrarSenha = false;
  bool mostrarConfirmarSenha = false;

  // Máscara de Telefone
  String _formatarTelefone(String input) {
    input = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (input.length >= 2) {
      input = "(${input.substring(0, 2)}) ${input.substring(2)}";
    }
    if (input.length > 10) {
      input =
          "${input.substring(0, 9)}-${input.substring(9, input.length.clamp(9, 13))}";
    }

    return input;
  }

  // ======================================================
  void _realizarCadastro() async {
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();
    String confirmaSenha = confirmaSenhaController.text.trim();
    String telefone = telefoneController.text.trim();

    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmaSenha.isEmpty ||
        telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um e-mail válido.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (senha != confirmaSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    bool senhaValida =
        senha.length >= 6 &&
            senha.contains(RegExp(r'[A-Z]')) &&
            senha.contains(RegExp(r'[a-z]')) &&
            senha.contains(RegExp(r'[0-9]')) &&
            senha.contains(RegExp(r'[!@#\$&*~%]'));

    if (!senhaValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'A senha deve conter ao menos:\n- 6 caracteres\n- Letra maiúscula\n- Letra minúscula\n- Número\n- Caracter especial (!@#\$&*~%)'),
          backgroundColor: Colors.orangeAccent,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    final auth = AuthService();
    String? erro = await auth.cadastrarUsuario(
      nome: nome,
      email: email,
      senha: senha,
      telefone: telefone,
    );

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    // Sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cadastro realizado com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );

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
        Widget? suffixIcon,
      }) {
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
        suffixIcon: suffixIcon,
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 150, 54, 54),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: const Text("Cadastro", style: TextStyle(color: Colors.white)),
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
              Image.asset('image/LogoChefList.png', height: 190),
              const SizedBox(height: 16),

              // Nome
              TextField(
                controller: nomeController,
                decoration: buildInputDecoration("Nome", Icons.person),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                decoration: buildInputDecoration("Email", Icons.email),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Senha
              TextField(
                controller: senhaController,
                obscureText: !mostrarSenha,
                decoration: buildInputDecoration(
                  "Senha",
                  Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarSenha ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() => mostrarSenha = !mostrarSenha);
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Confirmar Senha
              TextField(
                controller: confirmaSenhaController,
                obscureText: !mostrarConfirmarSenha,
                decoration: buildInputDecoration(
                  "Confirme sua Senha",
                  Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarConfirmarSenha
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(
                          () => mostrarConfirmarSenha = !mostrarConfirmarSenha);
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Telefone com máscara
              TextField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  final novo = _formatarTelefone(value);
                  telefoneController.value = TextEditingValue(
                    text: novo,
                    selection: TextSelection.collapsed(offset: novo.length),
                  );
                },
                decoration: buildInputDecoration(
                  "Número de Telefone",
                  Icons.phone,
                  hintText: "(99) 99999-9999",
                ),
                style: const TextStyle(color: Colors.white),
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
                    MaterialPageRoute(
                        builder: (context) => const TelaLoginView()),
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
