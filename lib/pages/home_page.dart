import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Para ícones modernos


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lucro = 5000;
    final prejuizo = -2000;

    return Scaffold(
      appBar: AppBar(
        title: Text('GestIN - Início'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.swap_horiz),
              title: Text("Operações"),
              onTap: () => Navigator.pushNamed(context, '/operacoes'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Clientes"),
              onTap: () => Navigator.pushNamed(context, '/clientes'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Resumo Financeiro",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Cards de Lucro e Prejuízo
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

            SizedBox(height: 30),
            Text(
              "Gráfico de Lucro (em breve)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text("Gráfico Placeholder")),
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
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16)),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
