import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 30),

            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                 ), 
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Entrar'),
            ),

            TextButton(
              onPressed: () {},
              child: const Text("Cadastrar"),
            ),

            TextButton(
              onPressed: () {},
              child: const Text("Esqueceu a senha?"),
            )
          ],
        ),
      ),
    );
  }
}