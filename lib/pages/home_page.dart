import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'clientes_page.dart';
import 'operacoes_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userId = args['userId'];

    final lucro = 5000;
    final prejuizo = -2000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GestIN - Início'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text("Operações"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OperacoesPage(userId: userId),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Clientes"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientesPage(userId: userId),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumo Financeiro",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(
                  icon: LucideIcons.trendingUp,
                  label: 'Lucro do mês',
                  value: 'R\$ $lucro',
                  color: Colors.green,
                ),
                _buildCard(
                  icon: LucideIcons.trendingDown,
                  label: 'Prejuízo do mês',
                  value: 'R\$ $prejuizo',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Gráfico de Lucro (em breve)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text("Gráfico Placeholder")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
