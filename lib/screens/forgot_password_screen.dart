import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final email = TextEditingController();

  bool validarEmail(String email) {
    return email.contains("@") && email.contains(".");
  }

  void recuperar() {
    if (email.text.isEmpty) {
      _erro("Informe o e-mail");
      return;
    }

    if (!validarEmail(email.text)) {
      _erro("E-mail inválido");
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
              onPressed: recuperar,
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}