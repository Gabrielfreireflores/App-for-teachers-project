import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

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
  final bool _carregando = false;

Future<void> cadastrar() async {
  final provider = context.read<AuthProvider>();

  final erro = await provider.cadastrarUsuario(
    nome.text.trim(),
    email.text.trim(),
    telefone.text.trim(),
    senha.text,
    confirmarSenha.text,
  );

  if (!mounted) return;

  if (erro != null) {
    _erro(erro);
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
            TextField(
              controller: telefone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Telefone"),
            ),
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
              onPressed: _carregando ? null : cadastrar,
              child: _carregando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}