import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int indiceAtual;
  final int totalPerguntas;

  const QuizProgressBar({
    super.key,
    required this.indiceAtual,
    required this.totalPerguntas,
  });

  @override
  Widget build(BuildContext context) {
    final progresso = (indiceAtual + 1) / totalPerguntas;

    return Row(
      children: [
        Text(
          '${indiceAtual + 1}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progresso,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.greenAccent,
              ),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$totalPerguntas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
