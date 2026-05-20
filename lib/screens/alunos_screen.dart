import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/app_layout.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AlunosScreen extends StatelessWidget {
  const AlunosScreen({super.key});

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference get _col =>
      FirebaseFirestore.instance.collection('alunos');

  Query get _query => _col.where('userId', isEqualTo: _uid).orderBy('nome');

  void _abrirDialog(BuildContext context, {DocumentSnapshot? doc}) {
  final nomeCtrl = TextEditingController(text: doc?['nome'] ?? '');
  final matriculaCtrl = TextEditingController(text: doc?['matricula'] ?? '');
  final cepCtrl = TextEditingController(text: doc?['cep'] ?? '');
  final enderecoCtrl = TextEditingController(text: doc?['endereco'] ?? '');
  bool buscando = false;

  Future<void> buscarCep(StateSetter setState) async {
    final cep = cepCtrl.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) return;
    setState(() => buscando = true);
    try {
      final res = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      final data = jsonDecode(res.body);
      if (data['erro'] == null) {
        enderecoCtrl.text =
            '${data['logradouro']}, ${data['bairro']} - ${data['localidade']}/${data['uf']}';
      } else {
        enderecoCtrl.text = 'CEP não encontrado';
      }
    } catch (_) {
      enderecoCtrl.text = 'Erro ao buscar CEP';
    }
    setState(() => buscando = false);
  }

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(doc == null ? 'Novo Aluno' : 'Editar Aluno'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: matriculaCtrl,
                decoration: const InputDecoration(labelText: 'Matrícula'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cepCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CEP'),
                      onChanged: (_) {
                        if (cepCtrl.text.replaceAll(RegExp(r'\D'), '').length == 8) {
                          buscarCep(setState);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  buscando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => buscarCep(setState),
                        ),
                ],
              ),
              TextField(
                controller: enderecoCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              if (nome.isEmpty) return;
              final payload = {
                'nome': nome,
                'matricula': matriculaCtrl.text.trim(),
                'cep': cepCtrl.text.trim(),
                'endereco': enderecoCtrl.text.trim(),
              };
              if (doc == null) {
                await _col.add({
                  ...payload,
                  'userId': _uid,
                  'createdAt': FieldValue.serverTimestamp(),
                });
              } else {
                await doc.reference.update(payload);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    ),
  );
}

  void _excluir(DocumentSnapshot doc) {
    doc.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Alunos',
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
                return const Center(child: Text('Nenhum aluno cadastrado.'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final doc = docs[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(doc['nome'] ?? ''),
                      subtitle: Text(
                                      'Matrícula: ${doc['matricula'] ?? '—'}'
                                      '${doc['endereco'] != null && doc['endereco'].toString().isNotEmpty ? '\n${doc['endereco']}' : ''}',
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
                            onPressed: () => _excluir(doc),
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