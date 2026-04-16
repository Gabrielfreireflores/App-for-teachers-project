import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Simula uma chamada de API para autenticação
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    // Simula uma chamada de API para registro
    await Future.delayed(const Duration(seconds: 2));
    // Em um cenário real, você faria a validação e o registro no backend
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> forgotPassword(String email) async {
    // Simula uma chamada de API para recuperação de senha
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com') {
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
