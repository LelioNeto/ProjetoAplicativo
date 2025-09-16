import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // coloca false quando for publicar
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
      builder: DevicePreview.appBuilder, // <- esse sim é importante
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        ),
        body: const Center(
          child: Text(
            "Bem-vindo ao app!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
