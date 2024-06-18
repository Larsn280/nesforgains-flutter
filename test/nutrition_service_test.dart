import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/service/nutrition_service.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;
  late NutritionService nutritionserviceTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
    }

    nutritionserviceTest = NutritionService(isarTest);
  });

  test("Open a instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });

  group("getAllDishesById Tests", () {
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

    final dishwithNull = Dish()
      ..name = "Dish Null Fields"
      ..calories = null
      ..protein = null
      ..carbohydrates = null
      ..fat = null
      ..userId = 2;

    test("getAllDishesById returns correct dishes for a user", () async {
      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishOne);
        await isarTest.dishs.put(dishTwo);
      });

      final retrievedDishes = await nutritionserviceTest.getAllDishesById(2);

      expect(retrievedDishes?.length, 1);
      expect(retrievedDishes?[0].dish, "DishTwo");
      expect(retrievedDishes?[0].calories, 20);
      expect(retrievedDishes?[0].protein, 100);
      expect(retrievedDishes?[0].carbohydrates, 50);
      expect(retrievedDishes?[0].fat, 20);

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("getAllDishesById returns empty list for user with no dishes",
        () async {
      final retrievedDishes = await nutritionserviceTest.getAllDishesById(4);

      expect(retrievedDishes?.length, 0);
    });

    test("getAllDishesById handles null fields correctly", () async {
      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishwithNull);
      });

      final retrievedDishes = await nutritionserviceTest.getAllDishesById(2);

      expect(retrievedDishes?.length, 1);
      expect(retrievedDishes?[0].dish, "Dish Null Fields");
      expect(retrievedDishes?[0].calories, 0);
      expect(retrievedDishes?[0].protein, 0);
      expect(retrievedDishes?[0].carbohydrates, 0);
      expect(retrievedDishes?[0].fat, 0);

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("getAllDishesById handles large number of dishes", () async {
      for (int i = 0; i < 100; i++) {
        final dish = Dish()
          ..userId = 2
          ..name = "Dish $i"
          ..calories = i * 10
          ..protein = i
          ..carbohydrates = i * 2
          ..fat = i * 3;
        await isarTest.writeTxn(() async {
          await isarTest.dishs.put(dish);
        });
      }

      final retrievedDishes = await nutritionserviceTest.getAllDishesById(2);

      expect(retrievedDishes?.length, 100);

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
