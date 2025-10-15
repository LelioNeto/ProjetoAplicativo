import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'favoritos_view.dart';

class Receita {
  String nome;
  Map<String, String> ingredientes; // ingrediente: quantidade
  bool favorito;

  Receita({required this.nome, required this.ingredientes, this.favorito = false});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'ingredientes': ingredientes,
      'favorito': favorito,
    };
  }

  factory Receita.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> ing = Map<String, dynamic>.from(json['ingredientes']);
    return Receita(
      nome: json['nome'],
      ingredientes: ing.map((key, value) => MapEntry(key, value.toString())),
      favorito: json['favorito'] ?? false, // ✅ evita erro de tipo nulo
    );
  }
}

class TelaReceitasView extends StatefulWidget {
  const TelaReceitasView({super.key});

  @override
  State<TelaReceitasView> createState() => _TelaReceitasViewState();
}

class _TelaReceitasViewState extends State<TelaReceitasView> {
  List<Receita> receitas = [];
  bool modoEdicao = false;

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  Future<void> _carregarReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dados = prefs.getStringList('receitas') ?? [];
    setState(() {
      receitas = dados.map((e) => Receita.fromJson(json.decode(e))).toList();
    });
  }

  Future<void> _salvarReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dados = receitas.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList('receitas', dados);
  }

  void _adicionarOuEditarReceita({Receita? receita, int? index}) {
    final nomeCtrl = TextEditingController(text: receita?.nome ?? '');
    List<MapEntry<TextEditingController, TextEditingController>> ingredientesCtrl = [];

    if (receita != null) {
      receita.ingredientes.forEach((key, value) {
        ingredientesCtrl.add(MapEntry(TextEditingController(text: key), TextEditingController(text: value)));
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
                const Text('Ingredientes', style: TextStyle(color: Colors.white70)),
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
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    setModalState(() {
                      ingredientesCtrl.add(MapEntry(TextEditingController(), TextEditingController()));
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Adicionar Ingrediente', style: TextStyle(color: Colors.white)),
                ),
                Row(
                  children: [
                    const Text('Favoritar: ', style: TextStyle(color: Colors.white)),
                    Switch(
                      value: favorito,
                      onChanged: (v) {
                        setModalState(() {
                          favorito = v;
                        });
                      },
                      activeColor: Colors.amber,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
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
                    );
                    setState(() {
                      if (index != null) {
                        receitas[index] = nova;
                      } else {
                        receitas.add(nova);
                      }
                    });
                    _salvarReceitas();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text(
                    index != null ? 'Editar Receita' : 'Adicionar Receita',
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

  void _abrirFavoritos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritosView(receitas: receitas.where((r) => r.favorito).toList()),
      ),
    );
  }

  void _excluirReceita(int index) {
    setState(() {
      receitas.removeAt(index);
    });
    _salvarReceitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Receitas'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                modoEdicao = !modoEdicao;
              });
            },
            child: Text(
              modoEdicao ? 'Cancelar' : 'Editar',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: receitas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.10, // 🔹 ajustado para deixar mais quadrado
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final receita = receitas[index];
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receita.nome,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView(
                          children: receita.ingredientes.entries
                              .map((e) => Text(
                                    '${e.key}: ${e.value}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ))
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
                ),
                if (modoEdicao)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _adicionarOuEditarReceita(receita: receita, index: index),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _excluirReceita(index),
                          child: const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
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
                const Text('Adicionar', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.star, color: Colors.white),
                  onPressed: _abrirFavoritos,
                  iconSize: 28,
                ),
                const Text('Favoritos', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
