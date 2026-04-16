import 'package:flutter/material.dart';
import 'package:app_for_teachers_project/screens/turmas_screen.dart';
import 'package:app_for_teachers_project/screens/alunos_screen.dart';
import 'package:app_for_teachers_project/screens/notas_screen.dart';
import 'package:app_for_teachers_project/screens/about_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TurmasScreen(),
                  ),
                );
              },
              child: const Text("Turmas"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlunosScreen(),
                  ),
                );
              },
              child: const Text("Alunos"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotasScreen(),
                  ),
                );
              },
              child: const Text("Notas"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
              child: const Text("Sobre"),
            ),

          ],
        ),
      ),
    );
  }
}