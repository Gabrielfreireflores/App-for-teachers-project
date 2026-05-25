import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  bool validarTelefone(String telefone) {
    final apenasDigitos = RegExp(r'^\d+$');
    return apenasDigitos.hasMatch(telefone) && telefone.length >= 10;
  }

  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return 'Preencha todos os campos';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _traduzirErro(e.code);
    } catch (e) {
      return 'Erro inesperado';
    }
  }

  Future<String?> cadastrarUsuario(
    String nome,
    String email,
    String telefone,
    String senha,
    String confirmarSenha,
  ) async {
    if (nome.isEmpty || email.isEmpty || telefone.isEmpty ||
        senha.isEmpty || confirmarSenha.isEmpty) {
      return 'Preencha todos os campos';
    }
    if (!validarTelefone(telefone)) {
      return 'Telefone inválido: apenas números, mínimo 10 dígitos';
    }
    if (senha != confirmarSenha) return 'As senhas não coincidem';

    try {
      debugPrint('[cadastrarUsuario] Criando usuário no Auth...');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = credential.user;
      if (user == null) {
        debugPrint('[cadastrarUsuario] Erro: user é null após criação');
        return 'Erro inesperado ao criar usuário';
      }

      debugPrint('[cadastrarUsuario] Auth OK — uid: ${user.uid}');
      await user.updateDisplayName(nome);
      debugPrint('[cadastrarUsuario] displayName atualizado');

      // CORRIGIDO: adicionado userId ao documento (campo obrigatório da coleção)
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
        'userId': user.uid,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[cadastrarUsuario] Dados salvos no Firestore');

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('[cadastrarUsuario] FirebaseAuthException: ${e.code}');
      return _traduzirErro(e.code);
    } catch (e) {
      debugPrint('[cadastrarUsuario] Erro inesperado: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> recuperarSenha(String email) async {
    if (email.isEmpty) return 'Informe o e-mail';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return _traduzirErro(e.code);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  String _traduzirErro(String code) {
    switch (code) {
      case 'user-not-found': return 'E-mail não encontrado';
      case 'wrong-password': return 'Senha incorreta';
      case 'email-already-in-use': return 'E-mail já cadastrado';
      case 'weak-password': return 'Senha muito fraca (mín. 6 caracteres)';
      case 'invalid-email': return 'E-mail inválido';
      case 'invalid-credential': return 'E-mail ou senha incorretos';
      default: return 'Erro: $code';
    }
  }
}
