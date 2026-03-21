import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String pergunta;

  const QuestionCard({
    super.key,
    required this.pergunta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        pergunta,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3142),
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
