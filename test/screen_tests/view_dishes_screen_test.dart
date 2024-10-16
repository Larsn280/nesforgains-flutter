import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/screens/dishScreens/display_dishes_screen.dart';

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

  group('DisplayDishesScreen tests', () {
    testWidgets('DisplayDishesScreen UI test', (WidgetTester tester) async {
      // Pump the main widget
      await tester.pumpWidget(MaterialApp(
        home: DisplayDishesScreen(isar: isarTest),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Dishlist'), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.text('No dishes available'), findsOneWidget);

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Carbohydrates'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
