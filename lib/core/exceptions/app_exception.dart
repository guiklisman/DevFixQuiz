class AppException implements Exception {
  final String mensagem;
  final String? codigo;
  final Object? causa;

  AppException(this.mensagem, {this.codigo, this.causa});

  @override
  String toString() => 'AppException: $mensagem${causa != null ? ' ($causa)' : ''}';
}
