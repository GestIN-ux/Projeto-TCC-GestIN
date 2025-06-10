import 'package:flutter/material.dart';

class MetasPage extends StatelessWidget {
  final String userId;

  const MetasPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas Mensais'),
      ),
      body: const Center(
        child: Text('Aqui você poderá definir e acompanhar suas metas.'),
      ),
    );
  }
}
