import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final email = TextEditingController();
  bool _carregando = false;

  bool validarEmail(String email) {
    return email.contains("@") && email.contains(".");
  }

  Future<void> recuperar() async {
    if (email.text.isEmpty) {
      _erro("Informe o e-mail");
      return;
    }

    if (!validarEmail(email.text)) {
      _erro("E-mail inválido");
      return;
    }

    setState(() => _carregando = true);

    // Lógica de verificação delegada ao provider
    final provider = context.read<AuthProvider>();
    final erro = await provider.recuperarSenha(email.text.trim());

    if (!mounted) return;
    setState(() => _carregando = false);

    if (erro != null) {
      _erro(erro);
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Recuperação"),
        content: const Text("Instruções enviadas para o e-mail"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _erro(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar senha")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text("Digite seu e-mail"),

            TextField(controller: email),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _carregando ? null : recuperar,
              child: _carregando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}