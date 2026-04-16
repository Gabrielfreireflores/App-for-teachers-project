import 'package:flutter/material.dart';

class TurmasScreen extends StatelessWidget {
  const TurmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Turmas"),
      ),
      body: const Center(
        child: Text("Lista de Turmas"),
      ),
    );
  }
}