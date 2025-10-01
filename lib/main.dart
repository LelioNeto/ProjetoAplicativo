import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'view/tela_principal_view.dart';
import 'view/tela_redefinir_senha_view.dart'; // importa a tela de redefinir senha

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      // aqui registramos as rotas
      routes: {'/redefinir-senha': (context) => const TelaRedefinirSenhaView()},
      home: const TelaPrincipalView(),
    );
  }
}
