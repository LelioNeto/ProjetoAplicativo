import 'package:flutter/material.dart';
import 'package:projeto_app/view/tela_cadastro_view.dart';

class TelaLoginView extends StatelessWidget {
  const TelaLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    InputDecoration buildInputDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white10,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white10),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 150, 54, 54), width: 2),
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
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 150, 54, 54),
            selectionColor: Color.fromARGB(255, 150, 54, 54),
            selectionHandleColor: Color.fromARGB(255, 150, 54, 54),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Ícone/logo no topo
              Image.asset(
                'image/LogoChefList.png',
                height: 230,
              ),
             

              // Email
              TextField(
                decoration: buildInputDecoration("Email", Icons.email),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),

              // Senha
              TextField(
                obscureText: true,
                decoration: buildInputDecoration("Senha", Icons.lock),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),

              // "Esqueci minha senha"
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // ação futura: redefinir senha
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.transparent), // sem efeito ao clicar
                  ),
                  child: const Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 54, 54),
                    ),
                  ),
                ),
              ),
              // "Não tem uma conta? Cadastre-se"
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TelaCadastroView()),
      );
    },
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.all(Colors.transparent), // sem efeito ao clicar
    ),
    child: const Text(
      "Não tem uma conta? Cadastre-se",
      style: TextStyle(
        color: Color.fromARGB(255, 150, 54, 54),
      ),
    ),
  ),
),


              const SizedBox(height: 24),

              // Botão Entrar
              ElevatedButton(
                onPressed: () {
                  // futuramente: chamar controller de login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.minPositive, 50),
                ),
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
