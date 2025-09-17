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

            // BOTÃO FAZER LOGIN
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLoginView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 23, 2, 63), // cor de fundo
                foregroundColor: Colors.white, // cor do texto
                minimumSize: const Size(200, 50), // tamanho fixo
              ),
              child: const Text("Fazer Login"),
            ),
            const SizedBox(height: 20),

            // BOTÃO FAZER CADASTRO
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCadastroView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,// cor de fundo
                foregroundColor: const Color.fromARGB(255, 23, 2, 63), // cor do texto
                minimumSize: const Size(200, 50), // tamanho fixo
              ),
              child: const Text("Fazer Cadastro"),
            ),
          ],
        ),
      ),
    );
  }
}
