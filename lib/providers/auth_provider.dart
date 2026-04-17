import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  static const _usersKey = 'usuarios';

  bool get isAuthenticated => _isAuthenticated;

  // ─── Helpers de persistência ───────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _getUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  Future<void> _salvarUsuarios(List<Map<String, dynamic>> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(usuarios));
  }

  // ─── Validações (regras de negócio ficam aqui, nunca na UI) ───────────────

  /// Retorna true se o telefone contém apenas dígitos e tem mínimo 10 caracteres.
  bool validarTelefone(String telefone) {
    final apenasDigitos = RegExp(r'^\d+$');
    return apenasDigitos.hasMatch(telefone) && telefone.length >= 10;
  }

  // ─── Casos de uso ──────────────────────────────────────────────────────────

  /// Autentica o usuário consultando os dados persistidos.
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      return 'Preencha todos os campos';
    }

    final usuarios = await _getUsuarios();
    final encontrado = usuarios.any(
      (u) => u['email'] == email && u['password'] == password,
    );

    if (!encontrado) return 'E-mail ou senha incorretos';

    _isAuthenticated = true;
    notifyListeners();
    return null;
  }

  /// Valida e persiste um novo usuário.
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> cadastrarUsuario(
    String nome,
    String email,
    String telefone,
    String senha,
    String confirmarSenha,
  ) async {
    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      return 'Preencha todos os campos';
    }

    if (!validarTelefone(telefone)) {
      return 'Telefone inválido: apenas números, mínimo 10 dígitos';
    }

    if (senha != confirmarSenha) {
      return 'As senhas não coincidem';
    }

    await Future.delayed(const Duration(seconds: 1));

    final usuarios = await _getUsuarios();
    final jaExiste = usuarios.any((u) => u['email'] == email);
    if (jaExiste) return 'E-mail já cadastrado';

    usuarios.add({
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'password': senha,
    });
    await _salvarUsuarios(usuarios);

    _isAuthenticated = true;
    notifyListeners();
    return null;
  }

  /// Verifica se o e-mail existe na base local.
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> recuperarSenha(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty) return 'Informe o e-mail';

    final usuarios = await _getUsuarios();
    final existe = usuarios.any((u) => u['email'] == email);

    if (!existe) return 'E-mail não encontrado';
    return null;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}