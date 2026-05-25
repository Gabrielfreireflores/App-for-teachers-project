import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvaliacoesProvider extends ChangeNotifier {
  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference get _col =>
      FirebaseFirestore.instance.collection('avaliacoes');

  Stream<QuerySnapshot> getStream() {
    return _col.where('userId', isEqualTo: _uid).snapshots();
  }

  
  Future<String?> salvarAvaliacao(String nome, String data, String professor) async {
    if (nome.isEmpty || data.isEmpty) return 'Preencha os campos';
    await _col.add({
      'nome': nome,
      'data': data,
      'professor': professor,
      'userId': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return null;
  }

  
  Future<void> editar(String docId, String nome, String data, String professor) async {
    await _col.doc(docId).update({
      'nome': nome,
      'data': data,
      'professor': professor,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String docId) async {
    await _col.doc(docId).delete();
  }
}
