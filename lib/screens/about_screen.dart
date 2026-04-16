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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aplicativo desenvolvido para auxiliar docentes no gerenciamento escolar de alunos, notas e avaliações.\nProjeto acadêmico.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Desenvolvido por:\nGabriel Freire (Desenvolvedor backend)\n Milene Pereira(Desenvolvedor frontend)",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Instituição de ensino: FATEC - Faculdade de Tecnologia de Ribeirão Preto",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Professor: Rodrigo Plotze",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}