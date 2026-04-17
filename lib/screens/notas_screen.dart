import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';
import '../widgets/app_card.dart';

class NotasScreen extends StatelessWidget {
  const NotasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Notas",
      child: Column(
        children: const [
          AppCard(title: "João - 8.5", icon: Icons.grade),
          AppCard(title: "Maria - 9.0", icon: Icons.grade),
        ],
      ),
    );
  }
}