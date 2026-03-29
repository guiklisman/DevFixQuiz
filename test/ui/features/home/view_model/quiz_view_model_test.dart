import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_quiz_fix/ui/features/home/view_model/quiz_view_model.dart';
import 'package:dev_quiz_fix/domain/repositories/i_quiz_repository.dart';
import 'package:dev_quiz_fix/domain/entities/quiz_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('dev_quiz_fix/vibration');

  late QuizViewModel viewModel;
  late MockQuizRepository mockRepository;
  bool vibrateErro = false;

  setUp(() {
    mockRepository = MockQuizRepository();
    viewModel = QuizViewModel(repository: mockRepository);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'vibrate')
            if (vibrateErro) {
              throw PlatformException(code: 'ERROR', message: 'Falha');
            } else
              return null;
          return null;
        });
  });

  tearDown(() {
    vibrateErro = false;
  });

  group('QuizViewModel Tests', () {
    test('Carregamento inicial está correto', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.quizDiario, isEmpty);
    });

    group('carregarQuizDiario', () {
      test('carregarQuizDiario deve atualizar o estado com itens', () async {
        mockRepository.itensParaRetornar = [
          QuizItem(
            id: '1',
            pergunta: 'Teste?',
            opcoes: ['Sim', 'Não', 'Talvez'],
            indiceCorreto: 0,
          ),
        ];

        await viewModel.carregarQuizDiario();

        expect(viewModel.quizDiario.length, 1);
        expect(viewModel.quizDiario.first.pergunta, 'Teste?');
      });

      test('QuizDiario sem perguntas', () async {
        mockRepository.itensParaRetornar = [];
        await viewModel.carregarQuizDiario();
        expect(viewModel.erro, 'Nenhuma pergunta disponível hoje');
        expect(viewModel.isLoading, false);
      });

      test('QuizDiario com erro', () async {
        mockRepository.deveLancarErro = true;
        await viewModel.carregarQuizDiario();
        expect(viewModel.erro, 'Erro inesperado: Exception: Erro de teste');
        expect(viewModel.isLoading, false);
      });
    });
  });

  group('responderPergunta', () {
    test('responderPergunta corretamente', () async {
      mockRepository.itensParaRetornar = [
        QuizItem(
          id: '1',
          pergunta: 'Primeira Pergunta',
          opcoes: ['Sim', 'Não', 'Talvez'],
          indiceCorreto: 0,
          acertos: 0,
          ultimaRevisada: DateTime.now(),
        ),
      ];

      await viewModel.carregarQuizDiario();
      await viewModel.responderPergunta(0);

      expect(viewModel.pontuacao, 1);
      expect(viewModel.indiceAtual, 1);
      expect(mockRepository.atualizarItemChamadoCount, 1);
      expect(mockRepository.ultimoItemAtualizado?.acertos, 1);
    });

    test('responderPergunta incorretamente', () async {
      mockRepository.itensParaRetornar = [
        QuizItem(
          id: '1',
          pergunta: 'Primeira Pergunta',
          opcoes: ['Sim', 'Não', 'Talvez'],
          indiceCorreto: 0,
          acertos: 0,
          ultimaRevisada: DateTime.now(),
        ),
      ];

      await viewModel.carregarQuizDiario();
      await viewModel.responderPergunta(1);

      expect(viewModel.pontuacao, 0);
      expect(viewModel.indiceAtual, 1);
      expect(mockRepository.atualizarItemChamadoCount, 1);
      expect(mockRepository.ultimoItemAtualizado?.acertos, 0);
    });

    test('responderPergunta incorreta e erro ao vibrar', () async {
      vibrateErro = true;
      mockRepository.itensParaRetornar = [
        QuizItem(
          id: '1',
          pergunta: 'Primeira Pergunta',
          opcoes: ['Sim', 'Não', 'Talvez'],
          indiceCorreto: 0,
          acertos: 0,
          ultimaRevisada: DateTime.now(),
        ),
      ];

      await viewModel.carregarQuizDiario();
      await viewModel.responderPergunta(1);

      expect(viewModel.erro, 'Falha');
    });
  });

}

class MockQuizRepository implements IQuizRepository {
  List<QuizItem> itensParaRetornar = [];
  bool deveLancarErro = false;

  int atualizarItemChamadoCount = 0;
  QuizItem? ultimoItemAtualizado;

  @override
  Future<List<QuizItem>> obterQuizDiario({int limite = 10}) async {
    if (deveLancarErro) throw Exception('Erro de teste');
    return itensParaRetornar;
  }

  @override
  Future<void> atualizarItem(QuizItem itemAtualizado) async {
    atualizarItemChamadoCount++;
    ultimoItemAtualizado = itemAtualizado;
  }
}
