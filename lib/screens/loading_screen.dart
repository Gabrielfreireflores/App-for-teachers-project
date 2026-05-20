import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

@override
void initState() {
  super.initState();
  Future.delayed(const Duration(seconds: 2), () {
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3D3E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
             'assets/images/logo.png',
               height: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "Teacher's Best Friend",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}