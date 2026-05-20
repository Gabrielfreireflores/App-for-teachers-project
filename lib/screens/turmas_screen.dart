import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';

class TurmasScreen extends StatelessWidget {
  const TurmasScreen({super.key});

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference get _col =>
      FirebaseFirestore.instance.collection('turmas');

  Query get _query =>
      _col.where('userId', isEqualTo: _uid).orderBy('nome');

  void _abrirDialog(BuildContext context, {DocumentSnapshot? doc}) {
    final nomeCtrl = TextEditingController(text: doc?['nome'] ?? '');
    final periodoCtrl = TextEditingController(text: doc?['periodo'] ?? '');
    final turnoCtrl = TextEditingController(text: doc?['turno'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doc == null ? 'Nova Turma' : 'Editar Turma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome da Turma'),
            ),
            TextField(
              controller: periodoCtrl,
              decoration: const InputDecoration(labelText: 'Período (ex: 2025/1)'),
            ),
            TextField(
              controller: turnoCtrl,
              decoration: const InputDecoration(labelText: 'Turno (Manhã/Tarde/Noite)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              if (nome.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nome obrigatório')),
                );
                return;
              }
              if (doc == null) {
                await _col.add({
                  'nome': nome,
                  'periodo': periodoCtrl.text.trim(),
                  'turno': turnoCtrl.text.trim(),
                  'userId': _uid,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } else {
                await doc.reference.update({
                  'nome': nome,
                  'periodo': periodoCtrl.text.trim(),
                  'turno': turnoCtrl.text.trim(),
                });
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Turmas',
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _query.snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snap.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('Nenhuma turma cadastrada.'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final doc = docs[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.class_),
                      title: Text(doc['nome'] ?? ''),
                      subtitle: Text(
                        '${doc['periodo'] ?? '—'} · ${doc['turno'] ?? '—'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _abrirDialog(context, doc: doc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => doc.reference.delete(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => _abrirDialog(context),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}