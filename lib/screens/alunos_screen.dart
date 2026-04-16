import 'package:flutter/material.dart';

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alunos"),
      ),
      body: const Center(
        child: Text("Lista de Alunos"),
      ),
    );
  }
}