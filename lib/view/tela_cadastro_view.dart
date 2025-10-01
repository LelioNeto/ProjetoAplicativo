import 'package:flutter/material.dart';

class TelaCadastroView extends StatelessWidget {
  const TelaCadastroView({super.key});

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
        fillColor: Colors.white10,
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
        title: const Text("Cadastro", style: TextStyle(color: Colors.black)),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Ícone/logo no topo
              Image.asset('image/LogoChefList.png', height: 230),

              // Nome
              TextField(
                decoration: buildInputDecoration("Nome", Icons.person),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),

              // Confirmação de senha
              TextField(
                obscureText: true,
                decoration: buildInputDecoration(
                  "Confirme sua Senha",
                  Icons.lock,
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 16),

              // Telefone
              TextField(
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration(
                  "Telefone number",
                  Icons.phone,
                  hintText: "(99) 99999-9999",
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromARGB(255, 150, 54, 54),
              ),
              const SizedBox(height: 24),

              // Botão Cadastrar
              ElevatedButton(
                onPressed: () {
                  // futuramente: salvar no banco
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
