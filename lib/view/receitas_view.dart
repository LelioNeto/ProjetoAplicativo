import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'favoritos_view.dart';
import 'biblioteca_receitas_view.dart';

class Receita {
  String nome;
  Map<String, String> ingredientes;
  bool favorito;
  String? categoria;
  String? tempoPreparo;

  Receita({
    required this.nome,
    required this.ingredientes,
    this.favorito = false,
    this.categoria,
    this.tempoPreparo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'ingredientes': ingredientes,
      'favorito': favorito,
      'categoria': categoria,
      'tempoPreparo': tempoPreparo,
    };
  }

  factory Receita.fromJson(Map<String, dynamic> json) {
    final ingredientesMap = Map<String, dynamic>.from(json['ingredientes']);
    return Receita(
      nome: json['nome'],
      ingredientes: ingredientesMap.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      favorito: json['favorito'] ?? false,
      categoria: json['categoria'],
      tempoPreparo: json['tempoPreparo'],
    );
  }
}

class TelaReceitasView extends StatefulWidget {
  const TelaReceitasView({super.key});

  @override
  State<TelaReceitasView> createState() => _TelaReceitasViewState();
}

class _TelaReceitasViewState extends State<TelaReceitasView> {
  bool modoEdicao = false;
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference get _receitasRef => FirebaseFirestore.instance
      .collection("usuarios")
      .doc(user!.uid)
      .collection("receitas");

  Future<void> adicionarReceita(Receita r) async {
    await _receitasRef.add(r.toJson());
  }

  Future<void> atualizarReceita(String id, Receita r) async {
    await _receitasRef.doc(id).update(r.toJson());
  }

  Future<void> excluirReceita(String id) async {
    await _receitasRef.doc(id).delete();
  }

  void _adicionarOuEditarReceita({Receita? receita, String? id}) {
    final nomeCtrl = TextEditingController(text: receita?.nome ?? '');
    final categoriaCtrl = TextEditingController(text: receita?.categoria ?? '');
    final tempoCtrl = TextEditingController(text: receita?.tempoPreparo ?? '');

    List<MapEntry<TextEditingController, TextEditingController>> ingredientesCtrl =
        [];

    if (receita != null) {
      receita.ingredientes.forEach((key, value) {
        ingredientesCtrl.add(
          MapEntry(TextEditingController(text: key), TextEditingController(text: value)),
        );
      });
    } else {
      ingredientesCtrl.add(MapEntry(TextEditingController(), TextEditingController()));
    }

    bool favorito = receita?.favorito ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nome da Receita',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: categoriaCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Categoria (opcional)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempoCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Tempo de preparo (opcional)',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Ingredientes",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 5),
                ...ingredientesCtrl.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var controllers = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllers.key,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Ingrediente',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: controllers.value,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Quantidade',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setModalState(() {
                              ingredientesCtrl.removeAt(idx);
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    setModalState(() {
                      ingredientesCtrl.add(
                        MapEntry(TextEditingController(), TextEditingController()),
                      );
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Adicionar ingrediente",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Favoritar:",
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      value: favorito,
                      onChanged: (v) => setModalState(() => favorito = v),
                      activeColor: Colors.amber,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, String> mapIng = {};
                    for (var c in ingredientesCtrl) {
                      if (c.key.text.isNotEmpty && c.value.text.isNotEmpty) {
                        mapIng[c.key.text.trim()] = c.value.text.trim();
                      }
                    }
                    final nova = Receita(
                      nome: nomeCtrl.text.trim(),
                      ingredientes: mapIng,
                      favorito: favorito,
                      categoria: categoriaCtrl.text.trim().isEmpty
                          ? null
                          : categoriaCtrl.text.trim(),
                      tempoPreparo: tempoCtrl.text.trim().isEmpty
                          ? null
                          : tempoCtrl.text.trim(),
                    );
                    if (id != null) {
                      await atualizarReceita(id, nova);
                    } else {
                      await adicionarReceita(nova);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text(
                    id != null ? "Editar Receita" : "Adicionar Receita",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _abrirFavoritos(List<Receita> receitas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritosView(receitas: receitas),
      ),
    );
  }

  // NOVA FUNÇÃO PARA MOSTRAR RECEITA CENTRALIZADA
  void _mostrarReceitaDialog(Receita receita) {
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
        title: const Text("Receitas"),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => setState(() => modoEdicao = !modoEdicao),
            child: Text(
              modoEdicao ? "Cancelar" : "Editar",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _receitasRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          List<Receita> listaFavoritos = [];

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.10,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final receita = Receita.fromJson(doc.data() as Map<String, dynamic>);

              if (receita.favorito) listaFavoritos.add(receita);

              return InkWell(
                onTap: () => _mostrarReceitaDialog(receita), // NOVO CLIQUE
                child: Stack(
                  children: [
                    Container(
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
                          if (receita.favorito)
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.star, color: Colors.amber),
                            ),
                        ],
                      ),
                    ),
                    if (modoEdicao)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _adicionarOuEditarReceita(receita: receita, id: doc.id),
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => excluirReceita(doc.id),
                              child: const Icon(Icons.delete, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder<QuerySnapshot>(
          stream: _receitasRef.snapshots(),
          builder: (context, snapshot) {
            List<Receita> favs = [];
            if (snapshot.hasData) {
              for (var doc in snapshot.data!.docs) {
                final receita = Receita.fromJson(doc.data() as Map<String, dynamic>);
                if (receita.favorito) favs.add(receita);
              }
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _adicionarOuEditarReceita(),
                      iconSize: 28,
                    ),
                    const Text("Adicionar", style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.star, color: Colors.white),
                      onPressed: () => _abrirFavoritos(favs),
                      iconSize: 28,
                    ),
                    const Text("Favoritos", style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu_book, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BibliotecaReceitasView()),
                        );
                      },
                      iconSize: 28,
                    ),
                    const Text("Biblioteca", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
