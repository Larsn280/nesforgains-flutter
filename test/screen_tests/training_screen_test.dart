import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/screens/training_screen.dart';

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
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      await tester.pumpAndSettle();

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
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Reps'), findsOneWidget);
      expect(find.text('Sets'), findsOneWidget);
      expect(find.text('Weigth'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
      await tester.pumpAndSettle();

      expect(find.text('1 reps').last, findsOneWidget);
      expect(find.text('2 reps'), findsOneWidget);
      expect(find.text('3 reps'), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('32 reps'),
        find.byType(ListView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('32 reps'));
      await tester.pumpAndSettle();

      expect(find.text('32 reps'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();

      expect(find.text('1 sets').last, findsOneWidget);
      expect(find.text('2 sets'), findsOneWidget);
      expect(find.text('3 sets'), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('20 sets'),
        find.byType(ListView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('20 sets'));
      await tester.pumpAndSettle();

      expect(find.text('20 sets'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>).at(2));
      await tester.pumpAndSettle();

      expect(find.text('1 kg').last, findsOneWidget);
      expect(find.text('2 kg'), findsOneWidget);
      expect(find.text('3 kg'), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('10 kg'),
        find.byType(ListView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('10 kg'));
      await tester.pumpAndSettle();

      expect(find.text('10 kg'), findsOneWidget);
    });

    testWidgets('Test navigating back', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TrainingScreen(isar: isarTest),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
