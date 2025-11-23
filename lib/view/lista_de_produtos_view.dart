import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListaDeProdutosView extends StatefulWidget {
  const ListaDeProdutosView({super.key});

  @override
  State<ListaDeProdutosView> createState() => _ListaDeProdutosViewState();
}

class _ListaDeProdutosViewState extends State<ListaDeProdutosView> {
  static const _bg = Color(0xFF0F0F0F);
  static const _card = Color(0xFF1A1A1A);
  static const _text = Colors.white;
  static const _sub = Colors.white70;
  static const _icon = Colors.white70;
  static const _vermelho = Color.fromARGB(255, 150, 54, 54);

  final _auth = FirebaseAuth.instance;

  User? _user;
  bool _carregandoUsuario = true;

  @override
  void initState() {
    super.initState();

    _auth.userChanges().listen((u) {
      setState(() {
        _user = u;
        _carregandoUsuario = false;
      });
    });
  }

  CollectionReference<Map<String, dynamic>> get _col {
    return FirebaseFirestore.instance
        .collection("usuarios")
        .doc(_user!.uid)
        .collection("lista_compras");
  }

  Future<void> _addOrIncrement(String nome, int qtd) async {
    final lower = nome.toLowerCase().trim();

    final query = await _col.where("nomeLower", isEqualTo: lower).limit(1).get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first.reference;

      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(doc);
        int atual = (snap["quantidade"] ?? 0);
        tx.update(doc, {"quantidade": atual + qtd});
      });

      _msg("Quantidade atualizada");
    } else {
      await _col.add({
        "nome": nome.trim(),
        "nomeLower": lower,
        "quantidade": qtd,
        "comprado": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _msg("Item adicionado");
    }
  }

  Future<void> _toggleComprado(id, atual) async {
    await _col.doc(id).update({"comprado": !atual});
  }

  Future<void> _updateQtd(id, qtd) async {
    if (qtd <= 0) {
      await _col.doc(id).delete();
      _msg("Item removido");
    } else {
      await _col.doc(id).update({"quantidade": qtd});
    }
  }

  void _msg(String msg, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: erro ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _stream() {
    return _col.orderBy("comprado").snapshots();
  }

  Future<void> _addSheet() async {
    final nome = TextEditingController();
    final qtd = TextEditingController(text: "1");
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final pad = MediaQuery.of(ctx).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, pad + 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Adicionar item",
                    style: TextStyle(color: _text, fontSize: 18)),
                const SizedBox(height: 12),

                // CAMPO NOME — agora com cursor e seleção vermelha
                TextFormField(
                  controller: nome,
                  style: const TextStyle(color: _text),
                  cursorColor: _vermelho,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: _sub),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _vermelho,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? "Digite um nome" : null,
                ),

                const SizedBox(height: 12),

                // CAMPO QUANTIDADE — cursor vermelho também
                TextFormField(
                  controller: qtd,
                  style: const TextStyle(color: _text),
                  cursorColor: _vermelho,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantidade",
                    labelStyle: TextStyle(color: _sub),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _vermelho,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return "Digite";
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return "Número inválido";
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _addOrIncrement(nome.text, int.parse(qtd.text));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoUsuario) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (_user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Usuário não logado", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text("Lista de Compras", style: TextStyle(color: _text)),
        backgroundColor: _card,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSheet,
        label: const Text("Adicionar"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: StreamBuilder(
        stream: _stream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _vermelho),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar", style: TextStyle(color: _text)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Sua lista está vazia", style: TextStyle(color: _text)),
            );
          }

          final itens = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: itens.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final doc = itens[i];
              final d = doc.data();

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleComprado(doc.id, d["comprado"]),
                      child: Icon(
                        d["comprado"]
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                            d["comprado"] ? Colors.greenAccent : _icon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${d["nome"]}\nQuantidade: ${d["quantidade"]}",
                        style: const TextStyle(color: _text),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove, color: _icon),
                      onPressed: () =>
                          _updateQtd(doc.id, d["quantidade"] - 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: _icon),
                      onPressed: () =>
                          _updateQtd(doc.id, d["quantidade"] + 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _col.doc(doc.id).delete(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
