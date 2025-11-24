import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BibliotecaReceitasView extends StatefulWidget {
  const BibliotecaReceitasView({super.key});

  @override
  State<BibliotecaReceitasView> createState() => _BibliotecaReceitasViewState();
}

class _BibliotecaReceitasViewState extends State<BibliotecaReceitasView> {
  Future<List<dynamic>> fetchReceitas() async {
    final url = Uri.parse(
      "https://www.themealdb.com/api/json/v1/1/search.php?s=", // todas as receitas
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["meals"] == null) return [];

      return data["meals"];
    } else {
      throw Exception("Falha ao carregar receitas da API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("Biblioteca de Receitas"),
        backgroundColor: Color(0xFF1A1A1A),
      ),

      body: FutureBuilder<List<dynamic>>(
        future: fetchReceitas(), //
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final receitas = snapshot.data ?? [];

          if (receitas.isEmpty) {
            return const Center(child: Text("Nenhuma receita encontrada"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: receitas.length,
            itemBuilder: (context, index) {
              final receita = receitas[index];

              final nome = receita["strMeal"] ?? "Sem nome";
              final img = receita["strMealThumb"] ?? "";
              final instructions =
                  receita["strInstructions"] ?? "Sem instruções.";

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(nome),
                      content: Text(instructions),
                    ),
                  );
                },
                child: Card(
                  color: const Color(0xFF1E1E1E),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            img,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) {
                              return const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
