import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// Views
import 'view/tela_principal_view.dart';
import 'view/menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Receitas',
      debugShowCheckedModeBanner: false,

      // =========================
      //   🎨  TEMA GLOBAL
      // =========================
      theme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0F0F0F),

        // Cor principal do app (vermelho padrão)
        primaryColor: const Color.fromARGB(255, 150, 54, 54),

        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 150, 54, 54),
          secondary: Color.fromARGB(255, 150, 54, 54),
        ),

        // Cursor, seleção e handles VERMELHOS em todo o app
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 150, 54, 54),
          selectionColor: Color.fromARGB(90, 150, 54, 54),
          selectionHandleColor: Color.fromARGB(255, 150, 54, 54),
        ),

        // Estilo padrão dos TextFields
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 150, 54, 54),
              width: 2,
            ),
          ),
        ),

        // Loading global em vermelho
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromARGB(255, 150, 54, 54),
        ),

        // AppBar — seta voltar branca e fundo correto
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
        ),
      ),

      // ============================================
      //         ⚡ STREAM PARA LOGIN NO FIREBASE
      // ============================================
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Usuário NÃO logado → Tela Principal
          if (!snapshot.hasData) {
            return const TelaPrincipalView();
          }

          // Usuário logado → Menu principal
          return const MenuView();
        },
      ),
    );
  }
}
