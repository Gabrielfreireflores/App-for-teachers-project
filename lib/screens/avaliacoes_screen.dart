import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/avaliacoes_provider.dart';
import '../widgets/app_layout.dart';




class AvaliacoesScreen extends StatefulWidget {
  const AvaliacoesScreen({super.key});

  @override
  State<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends State<AvaliacoesScreen> {

  final nome = TextEditingController();
  final data = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega as avaliações persistidas ao abrir a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AvaliacoesProvider>().carregar();
    });
  }

  Future<void> criar() async {
    final provider = context.read<AvaliacoesProvider>();
    final erro = await provider.salvarAvaliacao(nome.text.trim(), data.text.trim());

    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(erro)));
      return;
    }

    // Limpa os campos após salvar
    nome.clear();
    data.clear();

    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Criado"),
        content: Text("Avaliação criada com sucesso"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Avaliações",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // RF004 – Nome da disciplina e versão do app (somente exibição)
          
          

          const SizedBox(height: 16),

          TextField(controller: nome, decoration: const InputDecoration(labelText: "Nome")),
          TextField(controller: data, decoration: const InputDecoration(labelText: "Data")),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: criar, child: const Text("Criar")),

          const SizedBox(height: 24),

          // Lista de avaliações persistidas
          Consumer<AvaliacoesProvider>(
            builder: (_, provider, __) {
              final lista = provider.listarAvaliacoes();
              if (lista.isEmpty) {
                return const Text(
                  'Nenhuma avaliação cadastrada.',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lista.length,
                itemBuilder: (_, i) {
                  final item = lista[i];
                  return ListTile(
                    title: Text(item['nome'] ?? ''),
                    subtitle: Text(item['data'] ?? ''),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}