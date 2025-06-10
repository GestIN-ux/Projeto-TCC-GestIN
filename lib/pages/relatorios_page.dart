import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RelatorioPage extends StatelessWidget {
  final String userId;

  const RelatorioPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color fundo = Colors.black;
    final Color textoBranco = Colors.white;
    final Color verde = Colors.green.shade600;
    final Color vermelho = Colors.red.shade600;
    final Color dourado = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        iconTheme: IconThemeData(color: textoBranco),
        title: Text('Relatório', style: TextStyle(color: textoBranco)),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('operacoes')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true) // Requer índice composto
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados.', style: TextStyle(color: textoBranco)),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          double totalEntradas = 0;
          double totalSaidas = 0;

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final valor = (data['valor'] ?? 0).toDouble();
            final tipo = data['tipoOperacao'] ?? '';

            if (tipo == 'Entrada') {
              totalEntradas += valor;
            } else if (tipo == 'Saída') {
              totalSaidas += valor;
            }
          }

          final saldo = totalEntradas - totalSaidas;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Resumo Financeiro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: dourado)),
                const SizedBox(height: 20),
                _buildResumo('Total de Entradas', totalEntradas, verde),
                const SizedBox(height: 10),
                _buildResumo('Total de Saídas', totalSaidas, vermelho),
                const SizedBox(height: 10),
                _buildResumo('Saldo Final', saldo, saldo >= 0 ? verde : vermelho),
                const SizedBox(height: 30),
                Text('Histórico de Operações', style: TextStyle(fontSize: 20, color: textoBranco)),
                const SizedBox(height: 10),
                Expanded(
                  child: docs.isEmpty
                      ? Center(child: Text('Nenhuma operação encontrada.', style: TextStyle(color: textoBranco)))
                      : ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final valor = (data['valor'] ?? 0).toDouble();
                            final descricao = data['descricao'] ?? '';
                            final tipo = data['tipoOperacao'] ?? '';
                            final cliente = data['nomeCliente'] ?? '';
                            final forma = data['formaPagamento'] ?? '';
                            final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

                            return Card(
                              color: fundo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: tipo == 'Entrada' ? verde : vermelho),
                              ),
                              child: ListTile(
                                title: Text('$tipo - R\$ ${valor.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: tipo == 'Entrada' ? verde : vermelho,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text('$descricao\nCliente: $cliente\nPagamento: $forma',
                                    style: TextStyle(color: textoBranco)),
                                trailing: timestamp != null
                                    ? Text(
                                        '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                                        style: TextStyle(color: textoBranco),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResumo(String titulo, double valor, Color cor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(fontSize: 16, color: cor)),
          const SizedBox(height: 5),
          Text('R\$ ${valor.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cor)),
        ],
      ),
    );
  }
}
