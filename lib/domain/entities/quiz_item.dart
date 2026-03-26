class QuizItem {
  final String id;
  final String pergunta;
  final List<String> opcoes;
  final int indiceCorreto;
  final String? explicacao;
  final DateTime? ultimaRevisada;
  final int acertos;

  QuizItem({
    required this.id,
    required this.pergunta,
    required this.opcoes,
    required this.indiceCorreto,
    this.explicacao,
    this.ultimaRevisada,
    this.acertos = 0,
  });

  QuizItem copyWith({
    String? id,
    String? pergunta,
    List<String>? opcoes,
    int? indiceCorreto,
    String? explicacao,
    DateTime? ultimaRevisada,
    int? acertos,
  }) {
    return QuizItem(
      id: id ?? this.id,
      pergunta: pergunta ?? this.pergunta,
      opcoes: opcoes ?? this.opcoes,
      indiceCorreto: indiceCorreto ?? this.indiceCorreto,
      explicacao: explicacao ?? this.explicacao,
      ultimaRevisada: ultimaRevisada ?? this.ultimaRevisada,
      acertos: acertos ?? this.acertos,
    );
  }
}
