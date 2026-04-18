import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_layout.dart';

class TurmasScreen extends StatefulWidget {
  const TurmasScreen({super.key});

  @override
  State<TurmasScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends State<TurmasScreen> {
  List<String> turmas = [];

  @override
  void initState() {
    super.initState();
    carregarTurmas();
  }

  Future<void> carregarTurmas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      turmas = prefs.getStringList('turmas') ?? [];
    });
  }

  Future<void> salvarTurmas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('turmas', turmas);
  }

  void adicionarTurma() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova Turma"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                setState(() {
                  turmas.add(controller.text);
                });

                await salvarTurmas();

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