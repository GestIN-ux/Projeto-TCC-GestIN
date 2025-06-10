import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/home_page.dart';
import 'pages/operacoes_page.dart';
import 'pages/clientes_page.dart';
import 'pages/tela_login.dart';
import 'pages/tela_cadastro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => const HomePage(),
              settings: RouteSettings(arguments: args),
            );
          case '/operacoes':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => OperacoesPage(userId: args['userId']),
            );
          case '/clientes':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ClientesPage(userId: args['userId']),
            );
          case '/cadastro':
            return MaterialPageRoute(builder: (_) => const TelaCadastro());
          case '/login':
            return MaterialPageRoute(builder: (_) => const TelaLogin());
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Tela não encontrada')),
              ),
            );
        }
      },
    );
  }
}
