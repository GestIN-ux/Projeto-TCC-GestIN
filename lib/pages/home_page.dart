import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  void _goTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route, arguments: {'userId': userId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F1E7),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text(
          'GestIN - Página Inicial',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              icon: Icons.swap_horiz,
              label: 'Operações Financeiras',
              color: Colors.teal,
              route: '/operacoes',
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              icon: Icons.flag,
              label: 'Metas Mensais',
              color: Colors.amber[700]!,
              route: '/metas',
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              icon: Icons.bar_chart,
              label: 'Relatório Financeiro',
              color: Colors.redAccent,
              route: '/relatorio',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _goTo(context, route),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
