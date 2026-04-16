import 'package:flutter/material.dart';

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alunos"),
      ),
      body: ListView(
  children: const [

    ListTile(
      title: Text("Maria Silva"),
    ),

    ListTile(
      title: Text("João Souza"),
    ),

    ListTile(
      title: Text("Ana Paula"),
    ),

    ListTile(
      title: Text("Julia Santos"),
    ),

  ],
),
    );
  }
}