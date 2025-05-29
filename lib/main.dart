import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/home_page.dart';
import 'pages/operacoes_page.dart';
import 'pages/clientes_page.dart';
import 'pages/tela_login.dart';
import 'pages/tela_cadastro.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GestinApp());
}

class GestinApp extends StatelessWidget {
  const GestinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GestIN',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: const TelaLogin(),
      routes: {
        '/home': (_) =>  HomePage(),
        '/operacoes': (_) =>  OperacoesPage(),
        '/clientes': (_) =>  ClientesPage(),
        '/cadastro': (_) => const TelaCadastro(), // 👈 Rota adicionada
      },
    );
  }
}
