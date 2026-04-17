import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
  title: "Sobre",
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          "Aplicativo desenvolvido para auxiliar docentes no gerenciamento escolar de alunos, notas e avaliações.\nProjeto acadêmico.",
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 20),

        Text(
          "Desenvolvido por:\nGabriel Freire (backend)\nMilene Pereira (frontend)",
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
        ),

      ],
    ),
  ),
);
  }
}