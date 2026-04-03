enum AppEnvironment { development, production, staging }

class AppConfig {
  final String baseUrl;
  final AppEnvironment environment;
  AppConfig({required this.baseUrl, required this.environment});
}
