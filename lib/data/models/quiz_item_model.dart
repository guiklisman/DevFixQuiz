import '../../domain/entities/quiz_item.dart';

class QuizItemModel extends QuizItem {
  QuizItemModel({
    required super.id,
    required super.pergunta,
    required super.opcoes,
    required super.indiceCorreto,
    super.ultimaRevisada,
    super.acertos = 0,
  });

  factory QuizItemModel.fromJson(Map<String, dynamic> json) => QuizItemModel(
        id: json['id'],
        pergunta: json['pergunta'],
        opcoes: List<String>.from(json['opcoes']),
        indiceCorreto: json['indiceCorreto'],
        ultimaRevisada: json['ultimaRevisada'] != null
            ? DateTime.parse(json['ultimaRevisada'])
            : null,
        acertos: json['acertos'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pergunta': pergunta,
        'opcoes': opcoes,
        'indiceCorreto': indiceCorreto,
        'ultimaRevisada': ultimaRevisada?.toIso8601String(),
        'acertos': acertos,
      };

  factory QuizItemModel.fromEntity(QuizItem entity) => QuizItemModel(
        id: entity.id,
        pergunta: entity.pergunta,
        opcoes: entity.opcoes,
        indiceCorreto: entity.indiceCorreto,
        ultimaRevisada: entity.ultimaRevisada,
        acertos: entity.acertos,
      );
}
