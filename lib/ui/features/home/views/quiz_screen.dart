import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/quiz_view_model.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/quiz_progress_bar.dart';
import '../../../core/widgets/question_card.dart';
import '../../../core/widgets/option_tile.dart';
import '../../../core/widgets/quiz_result_view.dart';
import '../../../core/widgets/quiz_start_view.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizViewModel>().addListener(_onViewModelChange);
    });
  }

  void _onViewModelChange() {
    if (!mounted) return;
    final viewModel = context.read<QuizViewModel>();
    if (viewModel.erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  viewModel.erro!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      viewModel.limparErro();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dev Quiz Fixar'),
        actions: [
          Consumer<QuizViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.quizDiario.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '⭐ ${viewModel.pontuacao}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: AppBackground(
        useSafeArea: true,
        child: Consumer<QuizViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (viewModel.quizFinalizado) {
              return QuizResultView(
                pontuacao: viewModel.pontuacao,
                totalPerguntas: viewModel.quizDiario.length,
                porcentagem: viewModel.porcentagemAcerto,
                isSuccess: viewModel.isSuccess,
                onReiniciar: () {
                  viewModel.reiniciarQuiz();
                  viewModel.carregarQuizDiario();
                },
              );
            }

            if (viewModel.quizDiario.isEmpty && !viewModel.isLoading) {
              return QuizStartView(onStart: viewModel.carregarQuizDiario);
            }

            final itemAtual = viewModel.quizDiario[viewModel.indiceAtual];
            final totalPerguntas = viewModel.quizDiario.length;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizProgressBar(
                    indiceAtual: viewModel.indiceAtual,
                    totalPerguntas: totalPerguntas,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          QuestionCard(pergunta: itemAtual.pergunta),
                          const SizedBox(height: 32),
                          ...itemAtual.opcoes.asMap().entries.map((entry) {
                            final indice = entry.key;
                            final opcao = entry.value;

                            return OptionTile(
                              indice: indice,
                              opcao: opcao,
                              respondido: viewModel.opcaoSelecionada != null,
                              selecionado: viewModel.opcaoSelecionada == indice,
                              correto: indice == itemAtual.indiceCorreto,
                              onTap: () => viewModel.responderPergunta(indice),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
