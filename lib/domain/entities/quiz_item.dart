class QuizItem {
  final String id;
  final String pergunta;
  final List<String> opcoes;
  final int indiceCorreto;
  final DateTime? ultimaRevisada;
  final int acertos;

  QuizItem({
    required this.id,
    required this.pergunta,
    required this.opcoes,
    required this.indiceCorreto,
    this.ultimaRevisada,
    this.acertos = 0,
  });

  QuizItem copyWith({
    String? id,
    String? pergunta,
    List<String>? opcoes,
    int? indiceCorreto,
    DateTime? ultimaRevisada,
    int? acertos,
  }) {
    return QuizItem(
      id: id ?? this.id,
      pergunta: pergunta ?? this.pergunta,
      opcoes: opcoes ?? this.opcoes,
      indiceCorreto: indiceCorreto ?? this.indiceCorreto,
      ultimaRevisada: ultimaRevisada ?? this.ultimaRevisada,
      acertos: acertos ?? this.acertos,
    );
  }
}
