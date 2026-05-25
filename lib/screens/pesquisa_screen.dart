import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';

// Opções de ordenação disponíveis
enum _Ordem { az, za, maisRecente, maisAntigo }

class PesquisaScreen extends StatefulWidget {
  const PesquisaScreen({super.key});

  @override
  State<PesquisaScreen> createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  String _busca = '';
  String _colecao = 'alunos';
  // ADICIONADO: estado de ordenação, padrão A-Z
  _Ordem _ordem = _Ordem.az;

  final _cols = ['alunos', 'turmas', 'notas', 'avaliacoes'];

  // Getter intencional: muda stream quando _colecao muda via setState
  Stream<QuerySnapshot> get _stream => FirebaseFirestore.instance
      .collection(_colecao)
      .where('userId', isEqualTo: _uid)
      .snapshots();

  /// Filtra por texto (case insensitive) e aplica ordenação selecionada
  List<QueryDocumentSnapshot> _filtrarEOrdenar(
      List<QueryDocumentSnapshot> docs) {
    // 1. filtro
    List<QueryDocumentSnapshot> resultado = docs;
    if (_busca.isNotEmpty) {
      final q = _busca.toLowerCase();
      resultado = docs.where((d) {
        final data = d.data() as Map<String, dynamic>;
        return data.values.any((v) => v.toString().toLowerCase().contains(q));
      }).toList();
    }

    // 2. ordenação
    resultado.sort((a, b) {
      final da = a.data() as Map<String, dynamic>;
      final db = b.data() as Map<String, dynamic>;

      switch (_ordem) {
        case _Ordem.az:
        case _Ordem.za:
          // usa 'nome' ou 'aluno' como chave de texto
          final ta = (da['nome'] ?? da['aluno'] ?? '').toString().toLowerCase();
          final tb = (db['nome'] ?? db['aluno'] ?? '').toString().toLowerCase();
          return _ordem == _Ordem.az ? ta.compareTo(tb) : tb.compareTo(ta);

        case _Ordem.maisRecente:
        case _Ordem.maisAntigo:
          final ta = da['createdAt'] as Timestamp?;
          final tb = db['createdAt'] as Timestamp?;
          if (ta == null) return 1;
          if (tb == null) return -1;
          return _ordem == _Ordem.maisRecente
              ? tb.compareTo(ta)
              : ta.compareTo(tb);
      }
    });

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Pesquisa',
      child: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _busca = v),
            ),
          ),

          // Linha: dropdown coleção + dropdown ordenação
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                // Seletor de coleção
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _colecao,
                    decoration: const InputDecoration(
                      labelText: 'Coleção',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _cols
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() {
                      _colecao = v!;
                      _busca = '';
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                // ADICIONADO: seletor de ordenação
                Expanded(
                  child: DropdownButtonFormField<_Ordem>(
                    value: _ordem,
                    decoration: const InputDecoration(
                      labelText: 'Ordenar',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: _Ordem.az,         child: Text('A → Z')),
                      DropdownMenuItem(value: _Ordem.za,         child: Text('Z → A')),
                      DropdownMenuItem(value: _Ordem.maisRecente, child: Text('Mais recente')),
                      DropdownMenuItem(value: _Ordem.maisAntigo,  child: Text('Mais antigo')),
                    ],
                    onChanged: (v) => setState(() => _ordem = v!),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snap) {
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
                final docs = _filtrarEOrdenar(snap.data?.docs ?? []);
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
                        subtitle: subtit.toString().isNotEmpty
                            ? Text(subtit)
                            : null,
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
