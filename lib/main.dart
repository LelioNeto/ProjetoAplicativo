import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'view/tela_principal_view.dart';
import 'view/tela_login_view.dart';
import 'view/tela_redefinir_senha_view.dart';
import 'services/auth_service.dart'; // import do AuthService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica se há usuário logado
  final auth = AuthService();
  final usuario = await auth.usuarioLogado();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(usuarioLogado: usuario),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? usuarioLogado;
  const MyApp({super.key, this.usuarioLogado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      routes: {
        '/redefinir-senha': (context) => const TelaRedefinirSenhaView(),
        '/login': (context) => const TelaLoginView(),
        '/principal': (context) => const TelaPrincipalView(),
      },
      // inicia no menu principal se já estiver logado, senão na tela de login
      home: usuarioLogado != null ? const TelaPrincipalView() : const TelaLoginView(),
    );
  }
}
