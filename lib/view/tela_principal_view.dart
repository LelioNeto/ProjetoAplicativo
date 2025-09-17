import 'package:flutter/material.dart';
import 'tela_login_view.dart';
import 'tela_cadastro_view.dart';

class TelaPrincipalView extends StatelessWidget {
  const TelaPrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IMAGEM AQUI
            Image.asset(
              'image/LogoCookList.png',
              height: 120, // ajusta o tamanho
            ),
            const SizedBox(height: 40), // espaço entre a imagem e os botões

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLoginView()),
                );
              },
              child: const Text("Fazer Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCadastroView()),
                );
              },
              child: const Text("Fazer Cadastro"),
            ),
          ],
        ),
      ),
    );
  }
}
