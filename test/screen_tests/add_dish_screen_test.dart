import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/screens/add_dish_screen.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
        [DailyNutritionSchema],
        directory: dirTest.path,
        name: 'addDishInstance',
      );
    }
  });

  Widget buildAddDishScreen() {
    return MaterialApp(
      home: AddDishScreen(isar: isarTest),
    );
  }

  testWidgets('AddDishScreen displays UI elements and validates inputs',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildAddDishScreen());

    expect(find.text('Add new dish'), findsOneWidget);
    expect(find.text('Dish name:'), findsOneWidget);
    expect(find.text('Calories:'), findsOneWidget);
    expect(find.text('Protein:'), findsOneWidget);
    expect(find.text('Carbohydrates:'), findsOneWidget);
    expect(find.text('Fat:'), findsOneWidget);
    expect(find.text('Submit new dish'), findsOneWidget);
    expect(find.text('Go back'), findsOneWidget);

    await tester.tap(find.text('Submit new dish'));
    await tester.pump();

    expect(find.text('Please enter a dish name'), findsOneWidget);
    expect(find.text('Please enter calories'), findsOneWidget);
    expect(find.text('Please enter protein'), findsOneWidget);
    expect(find.text('Please enter carbohydrates'), findsOneWidget);
    expect(find.text('Please enter fat'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Test Dish');
    await tester.enterText(find.byType(TextFormField).at(1), '100');
    await tester.enterText(find.byType(TextFormField).at(2), '10');
    await tester.enterText(find.byType(TextFormField).at(3), '20');
    await tester.enterText(find.byType(TextFormField).at(4), '5');
    await tester.pump();

    await tester.tap(find.text('Submit new dish'));
    await tester.pump();

    expect(find.byType(AddDishScreen), findsOneWidget);
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
