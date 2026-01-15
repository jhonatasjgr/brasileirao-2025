/// configurações da API
class ApiConfig {
  /// URL base da API
  static const String baseUrl = 'http://localhost:3000';

  /// timeout padrão para requisições (em segundos)
  static const int requestTimeout = 10;

  /// ativa logs de requisições
  static const bool enableLogging = true;
}

/// configurações da aplicação
class AppConfig {
  /// versão da app
  static const String version = '1.0.0';

  /// nome da aplicação
  static const String appName = 'CBF Stats';

  /// descrição
  static const String appDescription = 'Brasileirão 2025';

  /// total de rodadas da temporada
  static const int totalRodadas = 38;
}
