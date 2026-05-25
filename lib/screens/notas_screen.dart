import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  late final Stream<QuerySnapshot> _stream;
  late final CollectionReference _col;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _col = FirebaseFirestore.instance.collection('notas');
    _stream = _col.where('userId', isEqualTo: _uid).snapshots();
  }

  void _abrirDialog(BuildContext context, {DocumentSnapshot? doc}) {
    final alunoCtrl = TextEditingController(text: doc?['aluno'] ?? '');
    final disciplinaCtrl = TextEditingController(text: doc?['disciplina'] ?? '');
    final notaCtrl = TextEditingController(text: doc?['nota']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doc == null ? 'Nova Nota' : 'Editar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: alunoCtrl,
              decoration: const InputDecoration(labelText: 'Aluno'),
            ),
            TextField(
              controller: disciplinaCtrl,
              decoration: const InputDecoration(labelText: 'Disciplina'),
            ),
            TextField(
              controller: notaCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Nota (0–10)'),
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
              final aluno = alunoCtrl.text.trim();
              final disciplina = disciplinaCtrl.text.trim();
              final nota = double.tryParse(notaCtrl.text.trim());

              if (aluno.isEmpty || disciplina.isEmpty || nota == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preencha todos os campos corretamente')),
                );
                return;
              }

              if (doc == null) {
                await _col.add({
                  'aluno': aluno,
                  'disciplina': disciplina,
                  'nota': nota,
                  'userId': _uid,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } else {
                // CORRIGIDO: adicionado updatedAt na edição
                await doc.reference.update({
                  'aluno': aluno,
                  'disciplina': disciplina,
                  'nota': nota,
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
      title: 'Notas',
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, snap) {
              if (snap.hasError) {
                debugPrint('[NotasScreen] Erro no stream: ${snap.error}');
                return Center(
                  child: Text(
                    'Erro ao carregar notas:\n${snap.error}',
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
                final ta = a['createdAt'] as Timestamp?;
                final tb = b['createdAt'] as Timestamp?;
                if (ta == null) return -1;
                if (tb == null) return 1;
                return tb.compareTo(ta);
              });
              if (docs.isEmpty) {
                return const Center(child: Text('Nenhuma nota cadastrada.'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final doc = docs[i];
                  final nota = doc['nota'];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.grade),
                      title: Text(doc['aluno'] ?? ''),
                      subtitle: Text('${doc['disciplina'] ?? '—'} · Nota: $nota'),
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
