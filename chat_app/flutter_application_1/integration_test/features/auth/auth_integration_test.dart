import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/di.dart';
import 'package:flutter_application_1/features/auth/domain/auth_repo.dart';
import 'package:flutter_application_1/features/auth/ui/screens/login_screen.dart';
import 'package:flutter_application_1/features/chat/ui/screens/chat_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_robot.dart';

class AuthMockRepo extends Mock implements AuthRepo {}

// create method to return record with password and email
({String email, String password}) getRecord() {
  return (password: 'password', email: 'test@test.com');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late AuthMockRepo chatMockrepo;

  setUp(() async {
    await getIt.reset();
    setupGetIt();
    await getIt.unregister<AuthRepo>();
    chatMockrepo = AuthMockRepo();
    getIt.registerLazySingleton<AuthRepo>(() => chatMockrepo);
  });
  group("login flow", () {
    testWidgets("should login successfully", (tester) async {
      when(
        () => chatMockrepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {
        return await Future.delayed(const Duration(seconds: 2));
      });
      AuthRobot authRobot = AuthRobot(tester: tester);
      await authRobot.runApp(screen: LoginScreen());
      await authRobot.enterText(text: getRecord().email, index: 0);
      await authRobot.enterText(text: getRecord().password, index: 1);
      await authRobot.tapButton();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreenWidget), findsOneWidget);
    });

    testWidgets("should login fails", (tester) async {
      when(
        () => chatMockrepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {
        return await Future.delayed(const Duration(seconds: 2), () {
          throw Exception();
        });
      });
      AuthRobot authRobot = AuthRobot(tester: tester);
      await authRobot.runApp(screen: LoginScreen());
      await authRobot.enterText(text: getRecord().email, index: 0);
      await authRobot.enterText(text: getRecord().password, index: 1);
      await authRobot.tapButton();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets("Flow shouldn't start if form is not valid", (tester) async {
      when(
        () => chatMockrepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception());
      AuthRobot authRobot = AuthRobot(tester: tester);
      await authRobot.runApp(screen: LoginScreen());
      await authRobot.enterText(text: '', index: 0);
      await authRobot.enterText(text: getRecord().password, index: 1);
      await authRobot.tapButton();
      verifyNever(
        () => chatMockrepo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });
  });
}
