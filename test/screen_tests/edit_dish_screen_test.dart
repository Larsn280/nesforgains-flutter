import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/screens/edit_dish_screen.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
        [DailyNutritionSchema], // Add other schemas as needed
        directory: dirTest.path,
        name: 'editDishInstance',
      );
    }
  });

  Widget buildEditDishScreen(NutritionData nutritionData) {
    return MaterialApp(
      home: EditDishScreen(isar: isarTest, nutritionData: nutritionData),
    );
  }

  testWidgets('EditDishScreen displays UI elements and allows editing',
      (WidgetTester tester) async {
    final testNutritionData = NutritionData(
      dish: 'Test Dish',
      calories: 100,
      protein: 10,
      carbohydrates: 20,
      fat: 5,
    );

    await tester.pumpWidget(buildEditDishScreen(testNutritionData));

    // Verify the presence of initial UI elements
    expect(find.text('Edit Dish'), findsOneWidget);
    expect(find.text('Edit dish or go back'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Carbohydrates'), findsOneWidget);
    expect(find.text('Fat'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Go back'), findsOneWidget);

    // Verify the initial form field values
    expect(find.text('Test Dish'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);

    // Simulate user editing the form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'Updated Dish');
    await tester.enterText(find.byType(TextFormField).at(1), '200');
    await tester.enterText(find.byType(TextFormField).at(2), '20');
    await tester.enterText(find.byType(TextFormField).at(3), '40');
    await tester.enterText(find.byType(TextFormField).at(4), '10');
    await tester.pump();

    // Verify the updated form field values
    expect(find.text('Updated Dish'), findsOneWidget);
    expect(find.text('200'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    // Tap the save button
    await tester.tap(find.text('Save'));
    await tester.pump();

    // Verify the success message (assuming success message handling in the UI)
    // expect(find.textContaining('was edited'), findsOneWidget);

    // Navigate back
    // await tester.tap(find.text('Go back'));
    // await tester.pumpAndSettle();

    // Verify navigation to the previous screen
    // expect(find.byType(EditDishScreen), findsNothing);
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
