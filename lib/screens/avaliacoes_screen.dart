import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class AvaliacoesScreen extends StatefulWidget {
  const AvaliacoesScreen({super.key});

  @override
  State<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends State<AvaliacoesScreen> {

  final nome = TextEditingController();
  final data = TextEditingController();

  void criar() {
    if (nome.text.isEmpty || data.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha os campos")));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Criado"),
        content: Text("Avaliação criada com sucesso"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Avaliações",
      child: Column(
        children: [
          TextField(controller: nome, decoration: const InputDecoration(labelText: "Nome")),
          TextField(controller: data, decoration: const InputDecoration(labelText: "Data")),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: criar, child: const Text("Criar")),
        ],
      ),
    );
  }
}