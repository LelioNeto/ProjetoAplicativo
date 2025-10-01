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
            // TÍTULO
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Chef",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "LIST",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                        255,
                        150,
                        54,
                        54,
                      ), // Vermelho Padrão do App
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // IMAGEM
            Image.asset('image/LogoChefList.png', height: 300),
            const SizedBox(height: 40),

            // BOTÃO FAZER LOGIN
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaLoginView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 150, 54, 54),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Fazer Login"),
            ),
            const SizedBox(height: 20),

            // BOTÃO FAZER CADASTRO
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaCadastroView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Fazer Cadastro"),
            ),
          ],
        ),
      ),
    );
  }
}
