import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/screens/home_screen.dart';
import 'package:nes_for_gains/screens/nutrition_screen.dart'; // Import if needed
import 'package:nes_for_gains/screens/training_screen.dart'; // Import if needed

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
        [AppUserSchema], // Add other schemas as needed
        directory: dirTest.path,
        name: 'homeScreenInstance',
      );
    }
  });

  Widget buildHomeScreen() {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/nutritionScreen': (context) => NutritionScreen(isar: isarTest),
        '/trainingScreen': (context) => TrainingScreen(isar: isarTest),
      },
    );
  }

  testWidgets('HomeScreen displays UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(buildHomeScreen());

    // Verify the presence of text elements
    expect(find.text('NESForGains!'), findsOneWidget);
    expect(find.text('Welcome to NESForGains!'), findsOneWidget);
    expect(find.textContaining('Lorem Ipsum'), findsOneWidget);

    // Verify the presence of buttons
    expect(find.text('Go to Nutrition'), findsOneWidget);
    expect(find.text('Go to Training'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Tapping "Go to Nutrition" navigates to NutritionScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildHomeScreen());

    // Tap the "Go to Nutrition" button
    await tester.tap(find.text('Go to Nutrition'));
    await tester.pumpAndSettle();

    // Verify navigation to NutritionScreen
    expect(find.byType(NutritionScreen), findsOneWidget);
  });

  testWidgets('Tapping "Go to Training" navigates to TrainingScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildHomeScreen());

    // Tap the "Go to Training" button
    await tester.tap(find.text('Go to Training'));
    await tester.pumpAndSettle();

    // Verify navigation to TrainingScreen
    expect(find.byType(TrainingScreen), findsOneWidget);
  });

  // You can add more tests for other interactions and edge cases here

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
