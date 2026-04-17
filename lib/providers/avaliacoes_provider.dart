import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvaliacoesProvider extends ChangeNotifier {
  static const _key = 'avaliacoes';
  List<Map<String, dynamic>> _avaliacoes = [];

  List<Map<String, dynamic>> get avaliacoes => List.unmodifiable(_avaliacoes);

  // ─── Inicialização ─────────────────────────────────────────────────────────

  /// Deve ser chamado na inicialização da tela para carregar os dados persistidos.
  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      _avaliacoes = List<Map<String, dynamic>>.from(jsonDecode(raw));
      notifyListeners();
    }
  }

  // ─── Casos de uso ──────────────────────────────────────────────────────────

  /// Persiste uma nova avaliação no SharedPreferences.
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> salvarAvaliacao(String nome, String data) async {
    if (nome.isEmpty || data.isEmpty) {
      return 'Preencha os campos';
    }

    _avaliacoes.add({
      'nome': nome,
      'data': data,
      'criadoEm': DateTime.now().toIso8601String(),
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_avaliacoes));

    notifyListeners();
    return null;
  }

  /// Retorna a lista completa de avaliações persistidas.
  List<Map<String, dynamic>> listarAvaliacoes() => _avaliacoes;
}