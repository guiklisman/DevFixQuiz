import 'dart:convert';
import 'package:dev_quiz_fix/data/models/quiz_item_model.dart';
import 'package:dev_quiz_fix/domain/entities/quiz_item.dart';
import 'package:flutter/services.dart';

import '../../core/exceptions/app_exception.dart';

class JsonService {
  Future<List<QuizItem>> carregarPerguntas() async {
    try {
      final String resposta = await rootBundle.loadString(
        'assets/perguntas.json',
      );
      final List<dynamic> listaJson = json.decode(resposta);
      return listaJson.map((json) => QuizItemModel.fromJson(json)).toList();
    } catch (e) {
      throw AppException('Falha ao carregar perguntas do JSON', causa: e);
    }
  }
}
