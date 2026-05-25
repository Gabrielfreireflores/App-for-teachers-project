import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/avaliacoes_provider.dart';
import '../widgets/app_layout.dart';

class AvaliacoesScreen extends StatefulWidget {
  const AvaliacoesScreen({super.key});

  @override
  State<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends State<AvaliacoesScreen> {
  late final Stream<QuerySnapshot> _stream;
  late final AvaliacoesProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<AvaliacoesProvider>();
    _stream = _provider.getStream();
  }

  void _abrirDialog(BuildContext context, {DocumentSnapshot? doc}) {
    final nomeCtrl = TextEditingController(text: doc?['nome'] ?? '');
    final dataCtrl = TextEditingController(text: doc?['data'] ?? '');
    // CORRIGIDO: adicionado campo professor
    final professorCtrl = TextEditingController(text: doc?['professor'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doc == null ? 'Nova Avaliação' : 'Editar Avaliação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: dataCtrl,
              decoration: const InputDecoration(labelText: 'Data'),
            ),
            TextField(
              controller: professorCtrl,
              decoration: const InputDecoration(labelText: 'Professor'),
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
              final data = dataCtrl.text.trim();
              final professor = professorCtrl.text.trim();
              if (doc == null) {
                final erro = await _provider.salvarAvaliacao(nome, data, professor);
                if (erro != null && context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(erro)));
                  return;
                }
              } else {
                await _provider.editar(doc.id, nome, data, professor);
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
      title: 'Avaliações',
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, snap) {
              if (snap.hasError) {
                debugPrint('[AvaliacoesScreen] Erro no stream: ${snap.error}');
                return Center(
                  child: Text(
                    'Erro ao carregar avaliações:\n${snap.error}',
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
                return const Center(child: Text('Nenhuma avaliação cadastrada.'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final doc = docs[i];
                  // CORRIGIDO: exibe professor na listagem
                  final professor = doc['professor'] ?? '';
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: Text(doc['nome'] ?? ''),
                      subtitle: Text(
                        'Data: ${doc['data'] ?? '—'}'
                        '${professor.isNotEmpty ? ' · Prof: $professor' : ''}',
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
                            onPressed: () => _provider.excluir(doc.id),
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
