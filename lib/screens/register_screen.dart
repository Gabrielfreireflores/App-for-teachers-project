import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nome = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  bool validarEmail(String email) {
    return email.contains("@") && email.contains(".");
  }

  void cadastrar() {
    if (nome.text.isEmpty ||
        email.text.isEmpty ||
        telefone.text.isEmpty ||
        senha.text.isEmpty ||
        confirmarSenha.text.isEmpty) {

      _erro("Preencha todos os campos");
      return;
    }

    if (!validarEmail(email.text)) {
      _erro("E-mail inválido");
      return;
    }

    if (senha.text != confirmarSenha.text) {
      _erro("As senhas não coincidem");
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sucesso"),
        content: const Text("Cadastro realizado com sucesso!"),
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
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(controller: nome, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: telefone, decoration: const InputDecoration(labelText: "Telefone")),
            TextField(controller: senha, obscureText: true, decoration: const InputDecoration(labelText: "Senha")),
            TextField(controller: confirmarSenha, obscureText: true, decoration: const InputDecoration(labelText: "Confirmar senha")),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: cadastrar,
              child: const Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}