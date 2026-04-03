import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/app_config.dart';
import 'core/utils/custom_bloc_observer.dart';
import 'core/utils/di.dart';

void runChatApp(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerLazySingleton<AppConfig>(() => appConfig);
  setupGetIt();
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
