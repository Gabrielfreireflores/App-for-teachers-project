import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF0F3D3E)),
            const SizedBox(width: 15),
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