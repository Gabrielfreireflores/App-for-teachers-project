import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';
import '../widgets/app_card.dart';

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Alunos",
      child: Column(
        children: const [
          AppCard(title: "João", icon: Icons.person),
          AppCard(title: "Maria", icon: Icons.person),
          AppCard(title: "Ana", icon: Icons.person),
        ],
      ),
    );
  }
}
 