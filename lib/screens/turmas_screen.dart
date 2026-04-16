import 'package:flutter/material.dart';

class TurmasScreen extends StatelessWidget {
  const TurmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Turmas"),
      ),
      body: ListView(
  children: const [

    ListTile(
      title: Text("Matemática"),
    ),

    ListTile(
      title: Text("Português"),
    ),

    ListTile(
      title: Text("História"),
    ),

    ListTile(
      title: Text("Geografia"),
    ),

  ],
),
    );
  }
}