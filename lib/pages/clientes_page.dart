import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Ícones modernos

class ClientesPage extends StatefulWidget {
  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Map<String, String>> clientes = [
    {'nome': 'Maria Silva', 'email': 'maria@email.com'},
    {'nome': 'João Souza', 'email': 'joao@email.com'}
  ];

  final nomeController = TextEditingController();
  final emailController = TextEditingController();

  void cadastrarCliente() {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();

    if (nome.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() {
      clientes.add({'nome': nome, 'email': email});
    });

    nomeController.clear();
    emailController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cliente cadastrado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clientes Cadastrados',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Lista de Clientes
            Expanded(
              child: clientes.isEmpty
                  ? Center(child: Text('Nenhum cliente cadastrado.'))
                  : ListView.builder(
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = clientes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(LucideIcons.user),
                            title: Text(cliente['nome'] ?? ''),
                            subtitle: Text(cliente['email'] ?? ''),
                          ),
                        );
                      },
                    ),
            ),

            Divider(height: 30),

            Text(
              'Novo Cliente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),

            // Campo Nome
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(LucideIcons.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Campo Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(LucideIcons.mail),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            // Botão Cadastrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: cadastrarCliente,
                icon: Icon(LucideIcons.plusCircle),
                label: Text('Cadastrar Cliente', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
