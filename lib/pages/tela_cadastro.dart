import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeCompletoController = TextEditingController();
  final _nomeNegocioController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _areaAtuacaoController = TextEditingController();

  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'\d')});
  final _cnpjFormatter = MaskTextInputFormatter(mask: '##.###.###/####-##', filter: {"#": RegExp(r'\d')});
  final _telefoneFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'\d')});

  bool _isCnpj = false;
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

  bool _isCpfCnpjValid(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 11) {
      if (RegExp(r'^(\d)\1*$').hasMatch(cleaned)) return false;
      List<int> digits = cleaned.split('').map(int.parse).toList();
      int calcDigit(List<int> base, List<int> weights) {
        int sum = 0;
        for (int i = 0; i < weights.length; i++) {
          sum += base[i] * weights[i];
        }
        int mod = sum % 11;
        return mod < 2 ? 0 : 11 - mod;
      }

      int d1 = calcDigit(digits, [10, 9, 8, 7, 6, 5, 4, 3, 2]);
      int d2 = calcDigit([...digits.sublist(0, 9), d1], [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]);
      return d1 == digits[9] && d2 == digits[10];
    } else if (cleaned.length == 14) {
      if (RegExp(r'^(\d)\1*$').hasMatch(cleaned)) return false;
      List<int> digits = cleaned.split('').map(int.parse).toList();
      int calcDigit(List<int> base, List<int> weights) {
        int sum = 0;
        for (int i = 0; i < weights.length; i++) {
          sum += base[i] * weights[i];
        }
        int mod = sum % 11;
        return mod < 2 ? 0 : 11 - mod;
      }

      int d1 = calcDigit(digits, [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
      int d2 = calcDigit([...digits.sublist(0, 12), d1], [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
      return d1 == digits[12] && d2 == digits[13];
    }
    return false;
  }

  bool _isEmailValid(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isTelefoneValid(String telefone) {
    final cleaned = telefone.replaceAll(RegExp(r'\D'), '');
    return cleaned.length == 11;
  }

  Future<void> _cadastrar() async {
    final nome = _nomeCompletoController.text.trim();
    final negocio = _nomeNegocioController.text.trim();
    final cpfCnpj = _cpfCnpjController.text.trim();
    final email = _emailController.text.trim();
    final telefone = _telefoneController.text.trim();
    final senha = _senhaController.text.trim();
    final area = _areaAtuacaoController.text.trim();

    if ([nome, negocio, cpfCnpj, email, telefone, senha, area].any((v) => v.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos.')));
      return;
    }

    if (!_isCpfCnpjValid(cpfCnpj)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CPF ou CNPJ inválido.')));
      return;
    }

    if (!_isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email inválido.')));
      return;
    }

    if (!_isTelefoneValid(telefone)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Telefone inválido.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha);
      final uid = cred.user!.uid;

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'userId': uid, // salva explicitamente o userId
        'nomeCompleto': nome,
        'nomeNegocio': negocio,
        'cpfCnpj': cpfCnpj,
        'email': email,
        'telefone': telefone,
        'areaAtuacao': area,
        'criadoEm': FieldValue.serverTimestamp(),
      });

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCampo(String label, TextEditingController controller,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text, MaskTextInputFormatter? mask}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        inputFormatters: mask != null ? [mask] : [],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          if (label == 'CPF e/ou CNPJ') {
            setState(() {
              _isCnpj = value.replaceAll(RegExp(r'\D'), '').length > 11;
              final formatter = _isCnpj ? _cnpjFormatter : _cpfFormatter;
              _cpfCnpjController.value = formatter.updateMask(mask: formatter.getMask());
            });
          }
        },
      ),
    );
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
                _buildCampo('CPF e/ou CNPJ', _cpfCnpjController,
                    keyboardType: TextInputType.number,
                    mask: _isCnpj ? _cnpjFormatter : _cpfFormatter),
                _buildCampo('E-mail', _emailController, keyboardType: TextInputType.emailAddress),
                _buildCampo('Telefone', _telefoneController, keyboardType: TextInputType.phone, mask: _telefoneFormatter),
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
