import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}
class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha para continuar.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final uid = cred.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        final dados = doc.data()!;
        Navigator.pushReplacementNamed(context, '/home', arguments: dados);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados do usuário não encontrados.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta.';
          break;
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'user-disabled':
          message = 'Usuário desabilitado.';
          break;
        default:
          message = 'Erro ao fazer login: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B7A1D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text('Continuar', style: TextStyle(fontSize: 16)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1E7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/logo.png', height: 250),
                const SizedBox(height: 48),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bem Vindo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Insira o email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '********',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLoginButton(),
                const SizedBox(height: 24),
                const Text.rich(
                  TextSpan(
                    text: 'Ao clicar em continuar, você concorda com nossos\n',
                    children: [
                      TextSpan(
                        text: 'Termos de Serviço',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(text: ' e ', style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: 'Política de Privacidade.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cadastro');
                  },
                  child: const Text(
                    'Não tem conta? Cadastre-se',
                    style: TextStyle(
                      color: Color(0xFFC6281C),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
