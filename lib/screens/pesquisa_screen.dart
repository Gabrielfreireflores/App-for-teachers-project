import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';

class PesquisaScreen extends StatefulWidget {
  const PesquisaScreen({super.key});

  @override
  State<PesquisaScreen> createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  String _busca = '';
  String _colecao = 'alunos';

  final _cols = ['alunos', 'turmas', 'notas', 'avaliacoes'];

  // Getter aqui é intencional: precisa mudar de stream quando _colecao muda via setState
  Stream<QuerySnapshot> get _stream => FirebaseFirestore.instance
      .collection(_colecao)
      .where('userId', isEqualTo: _uid)
      .snapshots();

  List<QueryDocumentSnapshot> _filtrar(List<QueryDocumentSnapshot> docs) {
    if (_busca.isEmpty) return docs;
    final q = _busca.toLowerCase();
    return docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return data.values.any((v) => v.toString().toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Pesquisa',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _busca = v),
            ),
          ),
          DropdownButton<String>(
            value: _colecao,
            items: _cols
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() {
              _colecao = v!;
              _busca = '';
            }),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snap) {
                // CORRIGIDO: adicionado tratamento de erro
                if (snap.hasError) {
                  debugPrint('[PesquisaScreen] Erro no stream: ${snap.error}');
                  return Center(
                    child: Text(
                      'Erro ao buscar dados:\n${snap.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = _filtrar(snap.data?.docs ?? []);
                if (docs.isEmpty) {
                  return const Center(child: Text('Nenhum resultado.'));
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final titulo = data['nome'] ?? data['aluno'] ?? '—';
                    final subtit = data['disciplina'] ??
                        data['periodo'] ??
                        data['data'] ??
                        '';
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(titulo),
                        subtitle: subtit.toString().isNotEmpty ? Text(subtit) : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
