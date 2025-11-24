import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaPesquisaProdutosView extends StatefulWidget {
  final String userId;

  const TelaPesquisaProdutosView({super.key, required this.userId});

  @override
  State<TelaPesquisaProdutosView> createState() =>
      _TelaPesquisaProdutosViewState();
}

class _TelaPesquisaProdutosViewState extends State<TelaPesquisaProdutosView> {
  final buscaCtrl = TextEditingController();
  String ordenacao = "nomeAsc";

  Query<Map<String, dynamic>> get _base =>
      FirebaseFirestore.instance
          .collection("usuarios")
          .doc(widget.userId)
          .collection("lista_compras");

  Stream<QuerySnapshot> _pesquisar() {
    final termo = buscaCtrl.text.trim().toLowerCase();

    Query<Map<String, dynamic>> q =
        _base.where("nomeLower", isGreaterThanOrEqualTo: termo)
             .where("nomeLower", isLessThanOrEqualTo: "$termo\uf8ff");

    switch (ordenacao) {
      case "nomeAsc":
        q = q.orderBy("nomeLower", descending: false);
        break;
      case "nomeDesc":
        q = q.orderBy("nomeLower", descending: true);
        break;
      case "quantidade":
        q = q.orderBy("quantidade", descending: true);
        break;
      case "data":
        q = q.orderBy("createdAt", descending: true);
        break;
      case "marca":
        q = q.orderBy("marca", descending: false);
        break;
    }

    return q.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Pesquisar Produtos", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: buscaCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Buscar...",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // ORDENAR
            DropdownButtonFormField<String>(
              value: ordenacao,
              dropdownColor: const Color(0xFF1A1A1A),
              decoration: const InputDecoration(
                labelText: "Ordenar por",
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: "nomeAsc", child: Text("Nome (A-Z)")),
                DropdownMenuItem(value: "nomeDesc", child: Text("Nome (Z-A)")),
                DropdownMenuItem(value: "quantidade", child: Text("Quantidade")),
                DropdownMenuItem(value: "marca", child: Text("Marca")),
                DropdownMenuItem(value: "data", child: Text("Mais recentes")),
              ],
              onChanged: (v) {
                setState(() => ordenacao = v!);
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _pesquisar(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("Nenhum resultado encontrado",
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final d = docs[i].data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d["nome"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (d["marca"] != null)
                              Text(
                                "Marca: ${d["marca"]}",
                                style: const TextStyle(color: Colors.white70),
                              ),

                            Text(
                              "Quantidade: ${d["quantidade"]}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
