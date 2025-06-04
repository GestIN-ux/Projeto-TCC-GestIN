import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _nomeNegocioController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _areaAtuacaoController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeCompletoController.dispose();
    _nomeNegocioController.dispose();
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _areaAtuacaoController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (_nomeCompletoController.text.isEmpty ||
        _nomeNegocioController.text.isEmpty ||
        _cpfCnpjController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _areaAtuacaoController.text.isEmpty ||
        email.isEmpty ||
        senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Esse email já está em uso.';
          break;
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'weak-password':
          message = 'Senha muito fraca.';
          break;
        default:
          message = 'Erro ao cadastrar: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCadastrarButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _cadastrar,
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
            : const Text('Cadastrar', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1E7),
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: const Color(0xFF3B7A1D),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 180),
                const SizedBox(height: 24),
                _buildCampo('Nome completo', _nomeCompletoController),
                _buildCampo('Nome do negócio', _nomeNegocioController),
                _buildCampo('CPF e/ou CNPJ', _cpfCnpjController, keyboardType: TextInputType.number),
                _buildCampo('E-mail', _emailController, keyboardType: TextInputType.emailAddress),
                _buildCampo('Telefone', _telefoneController, keyboardType: TextInputType.phone),
                _buildCampo('Senha', _senhaController, isPassword: true),
                _buildCampo('Área de atuação', _areaAtuacaoController),
                const SizedBox(height: 24),
                _buildCadastrarButton(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Já possui conta? Faça login',
                    style: TextStyle(
                      color: Color(0xFFC6281C),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
