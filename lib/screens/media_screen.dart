import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';

// CORRIGIDO: substituído dados hardcoded por leitura real da coleção 'notas'.
// Agrupa notas por aluno e calcula a média de cada um.
class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late final Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _stream = FirebaseFirestore.instance
        .collection('notas')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  /// Agrupa docs por aluno e retorna lista ordenada com média calculada
  List<Map<String, dynamic>> _calcularMedias(List<QueryDocumentSnapshot> docs) {
    final Map<String, List<double>> mapa = {};
    for (final doc in docs) {
      final aluno = doc['aluno']?.toString() ?? '';
      final nota = (doc['nota'] as num?)?.toDouble();
      if (aluno.isEmpty || nota == null) continue;
      mapa.putIfAbsent(aluno, () => []).add(nota);
    }
    final lista = mapa.entries.map((e) {
      final media = e.value.reduce((a, b) => a + b) / e.value.length;
      return {'aluno': e.key, 'media': media, 'qtd': e.value.length};
    }).toList();
    lista.sort((a, b) => (a['aluno'] as String).compareTo(b['aluno'] as String));
    return lista;
  }

  Color _corMedia(double media) {
    if (media >= 7) return Colors.green;
    if (media >= 5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Médias',
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            debugPrint('[MediaScreen] Erro no stream: ${snap.error}');
            return Center(
              child: Text(
                'Erro ao carregar médias:\n${snap.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final medias = _calcularMedias(snap.data?.docs ?? []);
          if (medias.isEmpty) {
            return const Center(child: Text('Nenhuma nota cadastrada para calcular médias.'));
          }
          return ListView.builder(
            itemCount: medias.length,
            itemBuilder: (_, i) {
              final m = medias[i];
              final media = (m['media'] as double);
              final qtd = m['qtd'] as int;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _corMedia(media),
                    child: Text(
                      media.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(m['aluno'] as String),
                  subtitle: Text('$qtd nota${qtd > 1 ? 's' : ''} registrada${qtd > 1 ? 's' : ''}'),
                  trailing: Text(
                    'Média: ${media.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: _corMedia(media),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
