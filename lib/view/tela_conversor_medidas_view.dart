import 'package:flutter/material.dart';

class TelaConversorMedidasView extends StatefulWidget {
  const TelaConversorMedidasView({super.key});

  @override
  State<TelaConversorMedidasView> createState() =>
      _TelaConversorMedidasViewState();
}

class _TelaConversorMedidasViewState extends State<TelaConversorMedidasView> {
  final TextEditingController valorController = TextEditingController();
  String unidadeOrigem = 'Xícaras';
  String unidadeDestino = 'Mililitros';
  double resultado = 0.0;

  final Map<String, double> fatoresConversao = const {
    'Xícaras': 240.0,
    'Colheres de sopa': 15.0,
    'Colheres de chá': 5.0,
    'Mililitros': 1.0,
  };

  void converter() {
    final valor = double.tryParse(valorController.text.replaceAll(',', '.'));
    if (valor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insira um valor válido!')));
      return;
    }
    final valorEmMl = valor * fatoresConversao[unidadeOrigem]!;
    final convertido = valorEmMl / fatoresConversao[unidadeDestino]!;
    setState(() => resultado = convertido);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Conversor de Medidas'),
        //centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Insira um valor e escolha as unidades para converter:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Campo de valor (sem prefixIcon)
            TextField(
              controller: valorController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Valor',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[850],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'De',
                    unidadeOrigem,
                    (val) => setState(() => unidadeOrigem = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Para',
                    unidadeDestino,
                    (val) => setState(() => unidadeDestino = val!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: converter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Converter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),
            if (resultado != 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '$resultado $unidadeDestino',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true, // evita overflow interno
      dropdownColor: Colors.grey[900],
      items: fatoresConversao.keys
          .map(
            (unidade) => DropdownMenuItem(
              value: unidade,
              child: Text(
                unidade,
                overflow: TextOverflow.ellipsis, // segurança extra
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[850],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}
