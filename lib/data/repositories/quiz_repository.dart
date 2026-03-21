import 'package:dev_quiz_fix/domain/entities/quiz_item.dart';
import 'package:dev_quiz_fix/domain/repositories/i_quiz_repository.dart';

import '../../core/exceptions/app_exception.dart';
import '../services/json_service.dart';
import '../services/shared_prefs_service.dart';
import '../models/quiz_item_model.dart';

class QuizRepository implements IQuizRepository {
  final JsonService _jsonService;
  final SharedPrefsService _prefsService;

  QuizRepository({
    required JsonService jsonService,
    required SharedPrefsService prefsService,
  }) : _jsonService = jsonService,
       _prefsService = prefsService;

  @override
  Future<List<QuizItem>> obterQuizDiario({int limite = 10}) async {
    try {
      final todasPerguntas = await _jsonService.carregarPerguntas();
      final progresso = await _prefsService.carregarProgresso();

      final mapaProgresso = {for (var p in progresso) p.id: p};
      final List<QuizItem> candidatos = [];

      for (var pergunta in todasPerguntas) {
        final itemProgresso = mapaProgresso[pergunta.id];
        final item = itemProgresso ?? pergunta;

        if (_precisaRevisar(item)) {
          candidatos.add(item);
        }
      }

      candidatos.shuffle();
      final quizDiario = candidatos.take(limite).toList();
      return quizDiario;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Erro ao obter quiz diário', causa: e);
    }
  }

  @override
  Future<void> atualizarItem(QuizItem itemAtualizado) async {
    final model = QuizItemModel.fromEntity(itemAtualizado);
    final progressoAtual = await _prefsService.carregarProgresso();
    final indice = progressoAtual.indexWhere(
      (item) => item.id == model.id,
    );

    if (indice != -1) {
      progressoAtual[indice] = model;
    } else {
      progressoAtual.add(model);
    }

    await _prefsService.salvarProgresso(progressoAtual);
  }

  bool _precisaRevisar(QuizItem item) {
    if (item.acertos < 3) return true;
    final agora = DateTime.now();
    final ultima = item.ultimaRevisada;
    return ultima == null || agora.difference(ultima).inDays > 7;
  }
}
