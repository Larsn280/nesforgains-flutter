import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/screens/nutrition_screen.dart';

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
        name: 'nutritionInstance',
      );
    }
  });

  test("Open an instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });

  group('NutritionScreen Widget Tests', () {
    testWidgets('Test initial state nutritionScreen',
        (WidgetTester tester) async {
      // Build NutritionScreen widget
      await tester.pumpWidget(MaterialApp(
        home: NutritionScreen(isar: isarTest),
      ));

      // Verify initial state
      expect(find.text('Nutrition Screen'), findsOneWidget);
      expect(find.text('Total calories today: 0 g'),
          findsOneWidget); // Assuming initial state
      expect(find.text('Protein: 0 g'), findsOneWidget);
      expect(find.text('Carbohydrates: 0 g'), findsOneWidget);
      expect(find.text('Fat: 0 g'), findsOneWidget);
    });

    testWidgets('Test adding a new dish', (WidgetTester tester) async {
      // Build NutritionScreen widget
      await tester.pumpWidget(MaterialApp(
        home: NutritionScreen(isar: isarTest),
      ));

      // Tap on the add button
      await tester.tap(find.byType(FloatingActionButton).first);
      await tester.pump();

      // Verify that the message is updated after adding a dish
      expect(find.text('Choose a dish or add a new one!'), findsOneWidget);
    });

    // Add more tests for other interactions and edge cases as needed
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
