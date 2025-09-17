import 'package:flutter/material.dart';

class TelaLoginView extends StatelessWidget {
  const TelaLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // aqui futuramente vai chamar o controller de login
              },
              child: const Text("Entrar"),
            )
          ],
        ),
      ),
    );
  }
}
