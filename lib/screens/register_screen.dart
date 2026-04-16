import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [

            TextField(
              decoration: InputDecoration(
                labelText: "Nome",
              ),
            ),

            SizedBox(height: 10),

            TextField(
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),

            SizedBox(height: 10),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: null,
              child: Text("Cadastrar"),
            ),

          ],
        ),
      ),
    );
  }
}