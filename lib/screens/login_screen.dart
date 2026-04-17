import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _carregando = false;

  bool validarEmail(String email) {
    return email.contains("@") && email.contains(".");
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro("Preencha todos os campos");
      return;
    }

    if (!validarEmail(email)) {
      _mostrarErro("E-mail inválido");
      return;
    }

    setState(() => _carregando = true);

    final provider = context.read<AuthProvider>();
    final erro = await provider.login(email, senha);

    if (!mounted) return;
    setState(() => _carregando = false);

    if (erro != null) {
      _mostrarErro(erro);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset(
        "assets/images/logo.png",
        height: 60,
        )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Senha",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _carregando ? null : login,
              child: _carregando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Entrar"),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: const Text("Cadastrar"),
            ),

            // CORREÇÃO RF003: era createRoute(const DashboardScreen())
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  createRoute(const ForgotPasswordScreen()),
                );
              },
              child: const Text("Esqueceu a senha?"),
            ),
          ],
        ),
      ),
    );
  }
}