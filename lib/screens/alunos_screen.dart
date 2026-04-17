import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> alunos = ["João", "Maria", "Ana"];

    return AppLayout(
      title: "Alunos",
      child: ListView.builder(
        itemCount: alunos.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(alunos[i]),
          ),
        ),
      ),
    );
  }
}