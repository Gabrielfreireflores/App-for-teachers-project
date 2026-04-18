import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_layout.dart';

class AlunosScreen extends StatefulWidget {
  const AlunosScreen({super.key});

  @override
  State<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen> {

  List<String> alunos = [];

  @override
  void initState() {
    super.initState();
    carregarAlunos();
  }

  Future<void> carregarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alunos = prefs.getStringList('alunos') ?? [];
    });
  }

  Future<void> salvarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('alunos', alunos);
  }

  void adicionarAluno() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Novo Aluno"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                setState(() {
                  alunos.add(controller.text);
                });

                await salvarAlunos();

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
      title: "Alunos",
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(alunos[i]),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: adicionarAluno,
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}