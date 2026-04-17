import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class TurmasScreen extends StatefulWidget {
  const TurmasScreen({super.key});

  @override
  State<TurmasScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends State<TurmasScreen> {

  List<String> turmas = ["Matemática", "Português"];

  void adicionarTurma() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Turma"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  turmas.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Turmas",
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: turmas.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(title: Text(turmas[i])),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: adicionarTurma,
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}