import 'package:flutter_application_1/config/app_config.dart'
    show AppConfig, AppEnvironment;
import 'package:flutter_application_1/run_app.dart';

void main() {
  AppConfig appConfig = AppConfig(
    baseUrl: 'https://api.development.com',
    environment: AppEnvironment.production,
  );
  runChatApp(appConfig);
}
