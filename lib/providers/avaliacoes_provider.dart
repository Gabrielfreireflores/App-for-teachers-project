import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvaliacoesProvider extends ChangeNotifier {
  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference get _col =>
      FirebaseFirestore.instance.collection('avaliacoes');

  Query get query =>
      _col.where('userId', isEqualTo: _uid).orderBy('createdAt', descending: true);

  Future<String?> salvarAvaliacao(String nome, String data) async {
    if (nome.isEmpty || data.isEmpty) return 'Preencha os campos';
    await _col.add({
      'nome': nome,
      'data': data,
      'userId': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return null;
  }

  Future<void> editar(String docId, String nome, String data) async {
    await _col.doc(docId).update({'nome': nome, 'data': data});
  }

  Future<void> excluir(String docId) async {
    await _col.doc(docId).delete();
  }
}