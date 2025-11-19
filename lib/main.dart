import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// Import das views
import 'view/tela_principal_view.dart';
import 'view/tela_login_view.dart';
import 'view/tela_redefinir_senha_view.dart';
import 'view/tela_cadastro_view.dart';
import 'view/menu_view.dart';
import 'view/lista_de_produtos_view.dart';
import 'view/receitas_view.dart';
import 'view/perfil_view.dart';
import 'view/tela_conversor_medidas_view.dart';
import 'view/cronometro_view.dart';

import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verificar usuário logado
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
      title: 'App de Receitas',
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),

      // Agora verifica se há usuário autenticado
      initialRoute: usuarioLogado != null ? '/menu' : '/principal',

      routes: {
        '/principal': (context) => const TelaPrincipalView(),
        '/login': (context) => const TelaLoginView(),
        '/cadastro': (context) => const TelaCadastroView(),
        '/redefinir-senha': (context) => const TelaRedefinirSenhaView(),
        '/menu': (context) => const MenuView(),
        '/lista-compras': (context) => const ListaDeProdutosView(),
        '/receitas': (context) => const TelaReceitasView(),
        '/perfil': (context) => const TelaPerfilView(),
        '/conversor-medidas': (context) => const TelaConversorMedidasView(),
        '/cronometro': (context) => const CronometroView(),
      },
    );
  }
}
