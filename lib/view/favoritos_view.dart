import 'package:flutter/material.dart';
import 'receitas_view.dart';

class FavoritosView extends StatelessWidget {
  final List<Receita> receitas;

  const FavoritosView({super.key, required this.receitas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: receitas.isEmpty
            ? const Center(
                child: Text('Nenhuma receita favorita',
                    style: TextStyle(color: Colors.white, fontSize: 16)))
            : GridView.builder(
                itemCount: receitas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.10, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemBuilder: (context, index) {
                  final receita = receitas[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(receita.nome,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Expanded(
                          child: ListView(
                            children: receita.ingredientes.entries
                                .map((e) => Text('${e.key}: ${e.value}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12)))
                                .toList(),
                          ),
                        ),
                        if (receita.favorito)
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.star, color: Colors.amber),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
