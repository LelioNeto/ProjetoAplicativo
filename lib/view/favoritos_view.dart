import 'package:flutter/material.dart';
import 'receitas_view.dart';

class FavoritosView extends StatelessWidget {
  final List<Receita> receitas;

  const FavoritosView({super.key, required this.receitas});

  void _mostrarReceitaDialog(BuildContext context, Receita receita) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        receita.nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                if (receita.categoria != null)
                  Text(
                    "Categoria: ${receita.categoria!}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (receita.tempoPreparo != null)
                  Text(
                    "Tempo: ${receita.tempoPreparo!}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                const SizedBox(height: 12),
                const Text(
                  "Ingredientes:",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: ListView(
                    children: receita.ingredientes.entries.map((e) {
                      return Text(
                        "• ${e.key}: ${e.value}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: receitas.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma receita favorita',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : GridView.builder(
                itemCount: receitas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.10,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final receita = receitas[index];

                  return InkWell(
                    onTap: () => _mostrarReceitaDialog(context, receita),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 39, 39, 39),
                            Color.fromARGB(255, 29, 29, 29),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(180, 0, 0, 0),
                            blurRadius: 18,
                            spreadRadius: 3,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: const Color.fromARGB(69, 255, 255, 255),
                          width: 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receita.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (receita.categoria != null)
                            Text(
                              receita.categoria!,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          if (receita.tempoPreparo != null)
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  receita.tempoPreparo!,
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          const SizedBox(height: 6),
                          Container(
                            height: 1,
                            color: Colors.white24,
                            margin: const EdgeInsets.only(bottom: 6),
                          ),
                          const Text(
                            "Ingredientes:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ListView(
                              children: receita.ingredientes.entries.map((e) {
                                return Text(
                                  "• ${e.key}: ${e.value}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                );
                              }).toList(),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.star, color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
