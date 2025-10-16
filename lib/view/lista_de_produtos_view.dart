import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaDeProdutosView extends StatefulWidget {
  const ListaDeProdutosView({super.key});

  @override
  State<ListaDeProdutosView> createState() => _ListaDeProdutosViewState();
}

class _ListaDeProdutosViewState extends State<ListaDeProdutosView> {
  static const _storageKey = 'lista_compras_v1';
  final List<_Item> _itens = [];

  // Paleta local para harmonizar com o app (dark + textos brancos)
  static const _bgColor = Color(0xFF0F0F0F);
  static const _cardColor = Color(0xFF1A1A1A);
  static const _text = Colors.white;
  static const _subText = Colors.white70;
  static const _icon = Colors.white70;
  static const _divider = Colors.white12;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      final List<dynamic> raw = json.decode(jsonStr);
      setState(() {
        _itens
          ..clear()
          ..addAll(raw.map((e) => _Item.fromMap(e as Map<String, dynamic>)));
      });
    }
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      json.encode(_itens.map((e) => e.toMap()).toList()),
    );
  }

  Future<void> _adicionarItemSheet() async {
    final nomeCtrl = TextEditingController();
    final qtdCtrl = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: _cardColor,
      builder: (ctx) {
        final viewInsets = MediaQuery.of(ctx).viewInsets;
        final inputBorder = OutlineInputBorder(
          borderSide: const BorderSide(color: _divider),
          borderRadius: BorderRadius.circular(12),
        );
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Adicionar item',
                  style: Theme.of(
                    ctx,
                  ).textTheme.titleLarge?.copyWith(color: _text),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nomeCtrl,
                  style: const TextStyle(color: _text),
                  decoration: InputDecoration(
                    labelText: 'Nome do item',
                    labelStyle: const TextStyle(color: _subText),
                    hintText: 'Ex.: Arroz',
                    hintStyle: const TextStyle(color: _subText),
                    filled: true,
                    fillColor: _bgColor,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o nome';
                    if (v.trim().length > 60) return 'Nome muito longo';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: qtdCtrl,
                  style: const TextStyle(color: _text),
                  decoration: InputDecoration(
                    labelText: 'Quantidade',
                    labelStyle: const TextStyle(color: _subText),
                    filled: true,
                    fillColor: _bgColor,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe a quantidade';
                    }
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Quantidade inválida';
                    if (n > 9999) return 'Quantidade muito alta';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close, color: _text),
                        label: const Text(
                          'Cancelar',
                          style: TextStyle(color: _text),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _divider),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          final nome = nomeCtrl.text.trim();
                          final qtd = int.parse(qtdCtrl.text.trim());
                          _adicionarOuSomar(nome, qtd);
                          Navigator.of(ctx).pop();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _adicionarOuSomar(String nome, int qtd) {
    final idx = _itens.indexWhere(
      (e) => e.nome.toLowerCase().trim() == nome.toLowerCase().trim(),
    );
    setState(() {
      if (idx >= 0) {
        _itens[idx] = _itens[idx].copyWith(
          quantidade: _itens[idx].quantidade + qtd,
        );
      } else {
        _itens.add(_Item(nome: nome, quantidade: qtd));
      }
    });
    _salvar();
  }

  void _removerItem(int index) {
    setState(() {
      _itens.removeAt(index);
    });
    _salvar();
  }

  void _alterarQuantidade(int index, int delta) {
    final atual = _itens[index].quantidade + delta;
    if (atual <= 0) {
      _removerItem(index);
      return;
    }
    setState(() {
      _itens[index] = _itens[index].copyWith(quantidade: atual);
    });
    _salvar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text('Lista de Compras', style: TextStyle(color: _text)),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: _text),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarItemSheet,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: _itens.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.shopping_basket_outlined, size: 64, color: _icon),
                  SizedBox(height: 12),
                  Text('Sua lista está vazia', style: TextStyle(color: _text)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemBuilder: (context, index) {
                final item = _itens[index];
                return Dismissible(
                  key: ValueKey('${item.nome}_${item.quantidade}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: const Color(0xFF8B0000),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _removerItem(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.checklist, color: _icon),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nome,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Quantidade: ${item.quantidade}',
                                style: const TextStyle(
                                  color: _subText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Diminuir',
                              onPressed: () => _alterarQuantidade(index, -1),
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: _icon,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Aumentar',
                              onPressed: () => _alterarQuantidade(index, 1),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: _icon,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remover',
                              onPressed: () => _removerItem(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: _icon,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: _itens.length,
            ),
    );
  }
}

class _Item {
  final String nome;
  final int quantidade;

  const _Item({required this.nome, required this.quantidade});

  _Item copyWith({String? nome, int? quantidade}) =>
      _Item(nome: nome ?? this.nome, quantidade: quantidade ?? this.quantidade);

  Map<String, dynamic> toMap() => {'nome': nome, 'quantidade': quantidade};

  factory _Item.fromMap(Map<String, dynamic> map) => _Item(
    nome: map['nome'] as String,
    quantidade: (map['quantidade'] as num).toInt(),
  );
}
