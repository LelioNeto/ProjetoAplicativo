import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'view/tela_principal_view.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, 
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder, 
      home: const TelaPrincipalView(),
    );
  }
}
