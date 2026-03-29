import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../domain/entities/quiz_item.dart';
import '../../../../domain/repositories/i_quiz_repository.dart';

class QuizViewModel extends ChangeNotifier {
  final IQuizRepository repository;
  static const _channel = MethodChannel('dev_quiz_fix/vibration');


  List<QuizItem> _quizDiario = [];
  List<QuizItem> get quizDiario => List.unmodifiable(_quizDiario);

  int _indiceAtual = 0;
  int get indiceAtual => _indiceAtual;

  int _pontuacao = 0;
  int get pontuacao => _pontuacao;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _erro;
  String? get erro => _erro;

  int? _opcaoSelecionada;
  int? get opcaoSelecionada => _opcaoSelecionada;

  bool? _isRespostaCorreta;
  bool? get isRespostaCorreta => _isRespostaCorreta;

  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  bool get quizFinalizado => _indiceAtual >= _quizDiario.length;

  int get porcentagemAcerto {
    if (_quizDiario.isEmpty) return 0;
    return ((_pontuacao / _quizDiario.length) * 100).round();
  }

  bool get isSuccess => porcentagemAcerto >= 80;

  QuizViewModel({required this.repository});

  Future<void> carregarQuizDiario() async {
    _setLoading(true);
    _erro = null;
    try {
      _quizDiario = await repository.obterQuizDiario(limite: 500);
      if (_quizDiario.isEmpty) {
        _erro = 'Nenhuma pergunta disponível hoje';
      }
    } on AppException catch (e) {
      _erro = e.mensagem;
    } catch (e) {
      _erro = 'Erro inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> responderPergunta(int indiceSelecionado) async {
    if (_quizDiario.isEmpty || quizFinalizado || _opcaoSelecionada != null) return;

    final itemAtual = _quizDiario[_indiceAtual];
    final correto = indiceSelecionado == itemAtual.indiceCorreto;

    _opcaoSelecionada = indiceSelecionado;
    _isRespostaCorreta = correto;
    notifyListeners();

    //mostrar a animação de certo/errado
    await Future.delayed(const Duration(milliseconds: 1500));

    if (correto) {
      _pontuacao++;
      final novoStreak = itemAtual.acertos + 1;
      final novoItem = itemAtual.copyWith(
        acertos: novoStreak,
        ultimaRevisada: DateTime.now(),
      );
      await repository.atualizarItem(novoItem);
    } else {
      // Aciona o MethodChannel para vibrar o celular
      try {
        await _channel.invokeMethod('vibrate');
      } on PlatformException catch (e) {
        debugPrint("Método não implementado ou falha: ${e.message}");
        _erro = e.message;
      }

      final novoItem = itemAtual.copyWith(
        acertos: 0,
        ultimaRevisada: DateTime.now(),
      );
      await repository.atualizarItem(novoItem);
    }

    _opcaoSelecionada = null;
    _isRespostaCorreta = null;
    _proximaPergunta();
    notifyListeners();
  }

  void _proximaPergunta() {
    _indiceAtual++;
  }

  void reiniciarQuiz() {
    _indiceAtual = 0;
    _pontuacao = 0;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _erro = null;
  }
}
