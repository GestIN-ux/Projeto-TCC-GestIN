import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Ícones modernos

class OperacoesPage extends StatefulWidget {
  @override
  State<OperacoesPage> createState() => _OperacoesPageState();
}

class _OperacoesPageState extends State<OperacoesPage> {
  final clienteIdController = TextEditingController();
  final valorController = TextEditingController();
  final descricaoController = TextEditingController();

  void registrarVenda() {
    final clienteId = clienteIdController.text;
    final valor = valorController.text;
    final descricao = descricaoController.text;

    print('Venda: Cliente $clienteId, Valor $valor, Desc: $descricao');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venda registrada (simulado)')),
    );

    // Limpar campos após registrar
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

            // Campo ID do Cliente
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

            // Campo Valor
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

            // Campo Descrição
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

            // Botão Registrar
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
