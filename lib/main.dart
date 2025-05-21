import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/operacoes_page.dart';
import 'pages/clientes_page.dart';

void main() {
  runApp(GestinApp());
}

class GestinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestIN',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
      routes: {
        '/home': (_) => HomePage(),
        '/operacoes': (_) => OperacoesPage(),
        '/clientes': (_) => ClientesPage(),
      },
    );
  }
}
