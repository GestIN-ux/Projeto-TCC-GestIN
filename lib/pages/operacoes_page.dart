import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'relatorios_page.dart';

class OperacoesPage extends StatefulWidget {
  final String userId;

  const OperacoesPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<OperacoesPage> createState() => _OperacoesPageState();
}

class _OperacoesPageState extends State<OperacoesPage> {
  final TextEditingController nomeClienteController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  String formaPagamento = 'Dinheiro';
  String tipoOperacao = 'Entrada';

  final Color verde = Colors.green.shade600;
  final Color vermelho = Colors.red.shade600;
  final Color dourado = const Color(0xFFFFD700);
  final Color fundo = Colors.black;
  final Color textoBranco = Colors.white;

  Future<void> registrarVenda() async {
    final nomeCliente = nomeClienteController.text.trim();
    final valorTexto = valorController.text.trim();
    final descricao = descricaoController.text.trim();

    if (nomeCliente.isEmpty || valorTexto.isEmpty || descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final valor = double.tryParse(valorTexto);
    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('operacoes').add({
        'userId': widget.userId,
        'nomeCliente': nomeCliente,
        'valor': valor,
        'descricao': descricao,
        'formaPagamento': formaPagamento,
        'tipoOperacao': tipoOperacao,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Operação "$tipoOperacao" registrada com sucesso')),
      );

      nomeClienteController.clear();
      valorController.clear();
      descricaoController.clear();
      setState(() {
        formaPagamento = 'Dinheiro';
        tipoOperacao = 'Entrada';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar operação: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        title: Text('Registrar Operação', style: TextStyle(color: textoBranco)),
        iconTheme: IconThemeData(color: textoBranco),
        actions: [
          IconButton(
            tooltip: 'Ver Relatório',
            icon: Icon(Icons.bar_chart, color: textoBranco),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RelatorioPage(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nova Operação',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textoBranco,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomeClienteController,
                style: TextStyle(color: textoBranco),
                decoration: InputDecoration(
                  labelText: 'Nome do Cliente',
                  labelStyle: TextStyle(color: textoBranco),
                  prefixIcon: Icon(Icons.person, color: textoBranco),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textoBranco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dourado),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valorController,
                style: TextStyle(color: textoBranco),
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                  labelStyle: TextStyle(color: textoBranco),
                  prefixIcon: Icon(Icons.attach_money, color: textoBranco),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textoBranco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dourado),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                style: TextStyle(color: textoBranco),
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: textoBranco),
                  prefixIcon: Icon(Icons.description, color: textoBranco),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textoBranco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dourado),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: formaPagamento,
                dropdownColor: fundo,
                decoration: InputDecoration(
                  labelText: 'Forma de Pagamento',
                  labelStyle: TextStyle(color: textoBranco),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textoBranco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: textoBranco),
                items: ['Dinheiro', 'Pix', 'Cartão de Débito', 'Cartão de Crédito']
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e, style: TextStyle(color: textoBranco)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      formaPagamento = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoOperacao,
                dropdownColor: fundo,
                decoration: InputDecoration(
                  labelText: 'Tipo de Operação',
                  labelStyle: TextStyle(color: textoBranco),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textoBranco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: textoBranco),
                items: ['Entrada', 'Saída']
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                              color: e == 'Entrada' ? verde : vermelho,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      tipoOperacao = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: registrarVenda,
                  icon: Icon(Icons.check_circle, color: textoBranco),
                  label: Text(
                    'Registrar $tipoOperacao',
                    style: TextStyle(color: textoBranco),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoOperacao == 'Entrada' ? verde : vermelho,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
