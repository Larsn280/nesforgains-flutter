import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/screens/home_screen.dart';
import 'package:nes_for_gains/screens/nutrition_screen.dart'; // Import if needed
import 'package:nes_for_gains/screens/training_calculator_screen.dart'; // Import if needed

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
        name: 'homeScreenInstance',
      );
    }
  });

  Widget buildHomeScreen() {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/nutritionScreen': (context) => NutritionScreen(isar: isarTest),
        '/trainingScreen': (context) =>
            TrainingCalculatorScreen(isar: isarTest),
      },
    );
  }

  testWidgets('HomeScreen displays UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(buildHomeScreen());

    expect(find.text('NESForGains!'), findsOneWidget);
    expect(find.text('Welcome to NESForGains!'), findsOneWidget);
    expect(find.textContaining('Lorem Ipsum'), findsOneWidget);

    expect(find.text('Go to Nutrition'), findsOneWidget);
    expect(find.text('Go to Training'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Tapping "Go to Nutrition" navigates to NutritionScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildHomeScreen());

    await tester.tap(find.text('Go to Nutrition'));
    await tester.pumpAndSettle();

    expect(find.byType(NutritionScreen), findsOneWidget);
  });

  testWidgets('Tapping "Go to Training" navigates to TrainingScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildHomeScreen());

    await tester.tap(find.text('Go to Training'));
    await tester.pumpAndSettle();

    expect(find.byType(TrainingCalculatorScreen), findsOneWidget);
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
