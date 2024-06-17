import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'dishInstance');
    }
  });

  test("Open ain instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });

  group("check for dishes", () {
    final dishOne = Dish()
      ..name = 'DishOne'
      ..calories = 20
      ..protein = 100
      ..carbohydrates = 50
      ..fat = 20
      ..userId = 1;

    final dishTwo = Dish()
      ..name = 'DishTwo'
      ..calories = 20
      ..protein = 100
      ..carbohydrates = 50
      ..fat = 20
      ..userId = 2;

    test('check dishes', () async {
      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishOne);
        await isarTest.dishs.put(dishTwo);
      });

      final check = await isarTest.dishs.get(dishOne.id);
      expect(check?.id, dishOne.id);

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("read the dish", () async {
      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishTwo);
      });

      final retrivedDish = await isarTest.dishs.get(2);

      expect(retrivedDish?.protein, 100);
      expect(retrivedDish?.id, 2);

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
