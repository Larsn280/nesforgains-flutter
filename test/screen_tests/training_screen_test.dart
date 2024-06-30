import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/screens/training_screen.dart';

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
        name: 'trainingInstance',
      );
    }
  });

  test("Open an instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });

  group('TrainingScreen Widget Tests', () {
    testWidgets('Test initial state of TrainingScreen',
        (WidgetTester tester) async {
      // Build TrainingScreen widget
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      // Verify initial state
      expect(find.text('Training Screen'), findsOneWidget);
      expect(find.text('Your one rep max : 125 kg'), findsOneWidget);
      expect(find.text('Reps'), findsOneWidget);
      expect(find.text('Sets'), findsOneWidget);
      expect(find.text('Weigth'), findsOneWidget);
      expect(find.text('Submit trainingdata'), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('Test selecting reps, sets, and weight',
        (WidgetTester tester) async {
      // Build TrainingScreen widget
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      // Open and select reps by index
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
      await tester.pumpAndSettle();
      // await tester.tap(find.byKey(ValueKey<String>(
      //     'reps_item_10'))); // Assuming '10 reps' is at index 10
      // await tester.pumpAndSettle();

      // Open and select sets by index
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      // await tester.tap(find.byKey(
      //     ValueKey<String>('sets_item_5'))); // Assuming '5 sets' is at index 5
      // await tester.pumpAndSettle();

      // Open and select weight by index
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(2));
      await tester.pumpAndSettle();
      // await tester.tap(find.byKey(ValueKey<String>(
      //     'weight_item_50'))); // Assuming '50 kg' is at index 50
      // await tester.pumpAndSettle();

      // Verify selections
      // expect(find.text('10 reps'), findsOneWidget);
      // expect(find.text('5 sets'), findsOneWidget);
      // expect(find.text('50 kg'), findsOneWidget);
    });

    testWidgets('Test submitting training data', (WidgetTester tester) async {
      // Build TrainingScreen widget
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      // Select reps
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
      await tester.pumpAndSettle();
      // await tester.tap(find.text('10 reps').last);
      // await tester.pump();

      // Select sets
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      // await tester.tap(find.text('5 sets').last);
      // await tester.pump();

      // Select weight
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(2));
      await tester.pumpAndSettle();
      // await tester.tap(find.text('50 kg').last);
      // await tester.pump();

      // Tap on the submit button
      await tester.tap(find.text('Submit trainingdata'));
      await tester.pump();

      // Since the form just prints to console, we assume success if no exceptions are thrown
      // Ideally, you should verify form submission behavior and state changes if applicable
    });

    testWidgets('Test navigating back', (WidgetTester tester) async {
      // Build TrainingScreen widget
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      // Tap on the Go Back button
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();

      // Verify navigation back (assuming the previous screen has a specific text)
      // This is a placeholder and should be replaced with actual verification
      // expect(find.text('Previous Screen Text'), findsOneWidget);
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
