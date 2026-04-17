import 'package:flutter/material.dart';
import 'turmas_screen.dart';
import 'alunos_screen.dart';
import 'notas_screen.dart';
import 'about_screen.dart';
import 'avaliacoes_screen.dart';
import 'media_screen.dart';
import '../utils/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // WEB / TABLET
            return Row(
              children: [
                _buildSideMenu(context),
                const VerticalDivider(width: 1),
                Expanded(child: _buildGrid(context, 3)),
              ],
            );
          } else {
            // MOBILE
            return _buildGrid(context, 2);
          }
        },
      ),
    );
  }

  // MENU LATERAL (WEB)
  Widget _buildSideMenu(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.push(context,
                createRoute(const TurmasScreen()));
            break;
          case 1:
            Navigator.push(context,
                createRoute(const AlunosScreen()));
            break;
          case 2:
            Navigator.push(context,
                createRoute(const NotasScreen()));
            break;
          case 3:
            Navigator.push(context,
                createRoute(const AboutScreen()));
            break;
        }
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.class_),
          label: Text("Turmas"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          label: Text("Alunos"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.grade),
          label: Text("Notas"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.info),
          label: Text("Sobre"),
        ),
      ],
    );
  }

  // GRID PRINCIPAL
  Widget _buildGrid(BuildContext context, int crossAxisCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCard(context, "Turmas", Icons.class_, const TurmasScreen()),
          _buildCard(context, "Alunos", Icons.people, const AlunosScreen()),
          _buildCard(context, "Notas", Icons.grade, const NotasScreen()),
          _buildCard(context, "Sobre", Icons.info, const AboutScreen()),
          _buildCard(context, "Avaliações", Icons.event, const AvaliacoesScreen()),
          _buildCard(context, "Médias", Icons.bar_chart, const MediaScreen()),
        ],
      ),
    );
  }

  // CARD DO DASHBOARD
  Widget _buildCard(
      BuildContext context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
         context,
          createRoute(screen),
      );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: const Color(0xFF0F3D3E)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}