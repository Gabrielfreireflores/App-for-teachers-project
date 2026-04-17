import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const AppLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    bool canGoBack = Navigator.canPop(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // BOTÃO DE VOLTAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [

                  if (canGoBack)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                  if (canGoBack) const SizedBox(width: 8),

                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),

            //CONTEÚDO
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  padding: const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}