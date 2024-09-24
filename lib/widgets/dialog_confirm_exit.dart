import 'package:flutter/material.dart';

class DialogConfirmExit extends StatelessWidget {
  final VoidCallback onConfirm;

  DialogConfirmExit({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Atenção'),
      content: const Text('Tem certeza de que deseja cancelar esta operação?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o modal
          },
          child: const Text('Não'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm(); // Executa a ação de cancelamento
            Navigator.of(context).pop(); // Fecha o modal
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
