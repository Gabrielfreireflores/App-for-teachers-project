import 'package:flutter/material.dart';

class NotasScreen extends StatelessWidget {
  const NotasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
      ),
      body: ListView(
  children: const [

    ListTile(
      title: Text("Maria Silva - Matemática: 8.5"),
    ),

    ListTile(
      title: Text("João Souza - Português: 7.0"),
    ),

    ListTile(
      title: Text("Ana Paula - História: 9.0"),
    ),

    ListTile(
      title: Text("Julia Santos - Geografia: 8.0"),
    ),

  ],
),
      );
  }
}