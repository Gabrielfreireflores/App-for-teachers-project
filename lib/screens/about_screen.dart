import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre"),
      ),
      body: const Center(
        child: Text(
          "Aplicativo para gerenciamento escolar.\nProjeto acadêmico.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}