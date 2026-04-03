import 'package:flutter_application_1/config/app_config.dart';
import 'package:flutter_application_1/run_app.dart';

void main() {
  AppConfig appConfig = AppConfig(
    baseUrl: 'https://api.development.com',
    environment: AppEnvironment.development,
  );
  runChatApp(appConfig);
}
