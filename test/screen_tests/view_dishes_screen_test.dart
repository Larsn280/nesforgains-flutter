import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/screens/view_dishes_screen.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
        [
          DishSchema,
          DailyNutritionSchema,
          AppUserSchema
        ], // Assuming no collections are needed for this screen
        directory: dirTest.path,
        name: 'dishInstance',
      );
    }
  });

  test("Open an instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });
  testWidgets('ViewDishesScreen UI test', (WidgetTester tester) async {
    // Build ViewDishesScreen widget
    await tester.pumpWidget(MaterialApp(
      home: ViewDishesScreen(
          isar:
              isarTest), // Pass null for isar as we're not testing database calls
    ));

    // Wait for the widget to render
    await tester.pumpAndSettle();

    // Verify that the main widgets and texts are present
    expect(find.text('Dishlist'), findsOneWidget);
    expect(
        find.byType(ElevatedButton), findsOneWidget); // Verify 'Go back' button

    await tester.pumpWidget(MaterialApp(
      home: ViewDishesScreen(isar: isarTest),
    ));

    await tester.pumpAndSettle();

    // Optionally, you can verify the presence of background image decoration
    expect(find.byType(DecoratedBox), findsOneWidget);
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
