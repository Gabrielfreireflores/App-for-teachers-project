import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {

  final aluno = TextEditingController();
  final nota = TextEditingController();

  void salvar() {
    if (aluno.text.isEmpty || nota.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha tudo")));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Sucesso"),
        content: Text("Nota salva!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Notas",
      child: Column(
        children: [
          TextField(controller: aluno, decoration: const InputDecoration(labelText: "Aluno")),
          TextField(controller: nota, decoration: const InputDecoration(labelText: "Nota")),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: salvar, child: const Text("Salvar")),
        ],
      ),
    );
  }
}