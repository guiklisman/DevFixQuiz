import '../entities/quiz_item.dart';

abstract class IQuizRepository {
  Future<List<QuizItem>> obterQuizDiario({int limite = 10});
  Future<void> atualizarItem(QuizItem itemAtualizado);
}
