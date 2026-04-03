import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/custom_bloc_observer.dart';
import 'core/utils/di.dart';
import 'features/auth/domain/auth_repo.dart';
import 'features/auth/domain/auth_user.dart';
import 'features/auth/ui/cubits/auth_cubit/auth_cubit.dart';
import 'features/auth/ui/screens/login_screen.dart';
import 'features/chat/ui/screens/chat_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        ),
        home: StreamBuilder<AppUser?>(
          stream: getIt<AuthRepo>().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return const ChatScreenWidget();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
