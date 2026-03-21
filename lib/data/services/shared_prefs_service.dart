import 'package:dev_quiz_fix/data/models/quiz_item_model.dart';
import 'package:dev_quiz_fix/domain/entities/quiz_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/exceptions/app_exception.dart';


class SharedPrefsService {
  static const String chaveProgressoQuiz = 'progresso_quiz';

  Future<void> salvarProgresso(List<QuizItem> itens) async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = itens.map((item) => QuizItemModel.fromEntity(item).toJson()).toList();
    await prefs.setString(chaveProgressoQuiz, json.encode(listaJson));
  }

Future<List<QuizItem>> carregarProgresso() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(chaveProgressoQuiz);
    if (jsonString == null) return [];
    return (json.decode(jsonString) as List)
        .map((json) => QuizItemModel.fromJson(json))
        .toList();
  } catch (e) {
    throw AppException('Falha ao carregar progresso', causa: e);
  }
}

}
