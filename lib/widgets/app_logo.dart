import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [

        CircleAvatar(
          radius: 35,
          backgroundColor: Color(0xFFA8E6CF),
          child: Icon(
            Icons.school,
            color: Color(0xFF0F3D3E),
            size: 30,
          ),
        ),

        SizedBox(height: 10),

        Text(
          "Teacher's Best Friend",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F3D3E),
          ),
        ),
      ],
    );
  }
}