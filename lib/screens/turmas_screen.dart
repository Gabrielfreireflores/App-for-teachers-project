import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';

class TurmasScreen extends StatefulWidget {
  const TurmasScreen({super.key});

  @override
  State<TurmasScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends State<TurmasScreen> {
  late final Stream<QuerySnapshot> _stream;
  late final CollectionReference _col;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _col = FirebaseFirestore.instance.collection('turmas');
    _stream = _col.where('userId', isEqualTo: _uid).snapshots();
  }

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
                // CORRIGIDO: adicionado updatedAt na edição
                await doc.reference.update({
                  'nome': nome,
                  'periodo': periodoCtrl.text.trim(),
                  'turno': turnoCtrl.text.trim(),
                  'updatedAt': FieldValue.serverTimestamp(),
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
            stream: _stream,
            builder: (context, snap) {
              if (snap.hasError) {
                debugPrint('[TurmasScreen] Erro no stream: ${snap.error}');
                return Center(
                  child: Text(
                    'Erro ao carregar turmas:\n${snap.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = [...(snap.data?.docs ?? [])];
              docs.sort((a, b) {
                final nomeA = (a['nome'] ?? '').toString().toLowerCase();
                final nomeB = (b['nome'] ?? '').toString().toLowerCase();
                return nomeA.compareTo(nomeB);
              });
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
