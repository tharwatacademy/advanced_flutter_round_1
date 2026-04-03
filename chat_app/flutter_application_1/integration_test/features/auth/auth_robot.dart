import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  final WidgetTester tester;

  AuthRobot({required this.tester});

  Future<void> runApp({required Widget screen}) async {
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pumpAndSettle();
  }

  Future<void> enterText({required String text, required int index}) async {
    await tester.enterText(find.byType(TextField).at(index), text);
    await tester.pumpAndSettle();
  }

  Future<void> tapButton() async {
    await tester.tap(find.byType(FilledButton).at(0));
    await tester.pump();
  }
}
