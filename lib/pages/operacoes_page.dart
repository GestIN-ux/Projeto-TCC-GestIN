import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OperacoesPage extends StatefulWidget {
  final String userId;

  OperacoesPage({required this.userId});

  @override
  State<OperacoesPage> createState() => _OperacoesPageState();
}

class _OperacoesPageState extends State<OperacoesPage> {
  static final Map<String, List<Map<String, String>>> _operacoesPorUsuario = {};

  final clienteIdController = TextEditingController();
  final valorController = TextEditingController();
  final descricaoController = TextEditingController();

  void registrarVenda() {
    final clienteId = clienteIdController.text.trim();
    final valor = valorController.text.trim();
    final descricao = descricaoController.text.trim();

    if (clienteId.isEmpty || valor.isEmpty || descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    _operacoesPorUsuario.putIfAbsent(widget.userId, () => []);
    _operacoesPorUsuario[widget.userId]!.add({
      'clienteId': clienteId,
      'valor': valor,
      'descricao': descricao,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venda registrada')),
    );

    clienteIdController.clear();
    valorController.clear();
    descricaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Operação'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nova Venda',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: clienteIdController,
              decoration: InputDecoration(
                labelText: 'ID do Cliente',
                prefixIcon: Icon(LucideIcons.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: valorController,
              decoration: InputDecoration(
                labelText: 'Valor (R\$)',
                prefixIcon: Icon(LucideIcons.dollarSign),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                prefixIcon: Icon(LucideIcons.fileText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: registrarVenda,
                icon: Icon(LucideIcons.checkCircle),
                label: Text(
                  'Registrar Venda',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
