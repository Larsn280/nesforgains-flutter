import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/screens/login_screen.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
        [DishSchema, DailyNutritionSchema, AppUserSchema],
        directory: dirTest.path,
        name: 'loginInstance',
      );
    }
  });

  test("Open an instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });

  group('LoginScreen Widget Tests', () {
    testWidgets('Test initial state loginScreen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginScreen(isar: isarTest),
      ));

      // Verify the initial state of the LoginScreen
      expect(find.text('Login Screen'), findsOneWidget);
      expect(find.byKey(const ValueKey('username')), findsOneWidget);
      expect(find.byKey(const ValueKey('password')), findsOneWidget);
      expect(find.byKey(const ValueKey('loginButton')), findsOneWidget);
      expect(find.byKey(const ValueKey('registerButton')), findsOneWidget);
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
