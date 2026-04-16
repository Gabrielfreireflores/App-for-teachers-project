import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Senha"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [

            Text(
              "Digite seu email para recuperar a senha",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: null,
              child: Text("Enviar"),
            ),

          ],
        ),
      ),
    );
  }
}