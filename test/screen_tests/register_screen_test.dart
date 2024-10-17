import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/screens/authScreens/register_screen.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
        [AppUserSchema],
        directory: dirTest.path,
        name: 'registerInstance',
      );
    }
  });

  Widget buildRegisterScreen() {
    return MaterialApp(
      home: RegisterScreen(isar: isarTest),
    );
  }

  testWidgets('RegisterScreen displays UI elements and handles user input',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildRegisterScreen());

    expect(find.text('Register Screen'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Enter you email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Enter yout password'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Go back to Login'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.pump();

    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
