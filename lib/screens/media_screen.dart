import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Médias",
      child: ListView(
        children: const [
          Card(child: ListTile(title: Text("João - Média: 8.5"))),
          Card(child: ListTile(title: Text("Maria - Média: 9.0"))),
        ],
      ),
    );
  }
}