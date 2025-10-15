import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'view/tela_principal_view.dart';
import 'view/tela_login_view.dart';
import 'view/tela_redefinir_senha_view.dart';
import 'view/menu_view.dart';       // import do MenuView
import 'services/auth_service.dart';

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
        '/menu': (context) => const MenuView(),
      },
      // Se já está logado → abre MenuView, senão → TelaPrincipalView
      home: usuarioLogado != null ? const MenuView() : const TelaPrincipalView(),
    );
  }
}
