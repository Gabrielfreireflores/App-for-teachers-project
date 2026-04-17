import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';
import '../widgets/app_card.dart';

class TurmasScreen extends StatelessWidget {
  const TurmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Turmas",
      child: Column(
        children: const [
          AppCard(title: "Matemática", icon: Icons.class_),
          AppCard(title: "Português", icon: Icons.class_),
          AppCard(title: "História", icon: Icons.class_),
        ],
      ),
    );
  }
}