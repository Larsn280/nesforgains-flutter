import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
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

  group("fetchDishItems Tests", () {
    test("fetchDishItems returns correct dish names for a user with dishes",
        () async {
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
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishOne);
        await isarTest.dishs.put(dishTwo);
      });

      final dishNames = await nutritionserviceTest.fetchDishItems(1);

      expect(dishNames.length, 2);
      expect(dishNames.contains('DishOne'), true);
      expect(dishNames.contains('DishTwo'), true);

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("fetchDishItems returns empty list for user with no dishes", () async {
      final dishNames = await nutritionserviceTest.fetchDishItems(2);

      expect(dishNames.length, 0);
    });

    test("fetchDishItems handles exceptions correctly", () async {
      // Here, we can simulate an exception by closing the Isar instance
      // before calling the fetchDishItems method.

      await isarTest.close();

      final dishNames = await nutritionserviceTest.fetchDishItems(1);

      expect(dishNames.length, 0);

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  group("addDishItem Tests", () {
    test("addDishItem adds a new dish successfully", () async {
      final nutritionData = NutritionData(
        dish: 'New Dish',
        calories: 300,
        protein: 20,
        carbohydrates: 50,
        fat: 10,
      );

      final response = await nutritionserviceTest.addDishItem(nutritionData, 1);

      expect(response.checksuccess, true);
      expect(response.message, 'New Dish was successfully added!');

      final retrievedDishes =
          await isarTest.dishs.filter().userIdEqualTo(1).findAll();
      expect(retrievedDishes.length, 1);
      expect(retrievedDishes[0].name, 'New Dish');

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("addDishItem returns appropriate message when dish already exists",
        () async {
      final existingDish = Dish()
        ..name = 'Existing Dish'
        ..calories = 200
        ..protein = 10
        ..carbohydrates = 30
        ..fat = 5
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(existingDish);
      });

      final nutritionData = NutritionData(
        dish: 'Existing Dish',
        calories: 200,
        protein: 10,
        carbohydrates: 30,
        fat: 5,
      );

      final response = await nutritionserviceTest.addDishItem(nutritionData, 1);

      expect(response.checksuccess, false);
      expect(response.message, 'Existing Dish already exists');

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("addDishItem handles exceptions properly", () async {
      // Simulate an exception by closing the Isar instance
      await isarTest.close();

      final nutritionData = NutritionData(
        dish: 'Error Dish',
        calories: 100,
        protein: 5,
        carbohydrates: 10,
        fat: 2,
      );

      expect(
        () async => await nutritionserviceTest.addDishItem(nutritionData, 1),
        throwsException,
      );

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  group("getDailyNutritionById Tests", () {
    test("getDailyNutritionById returns correct nutrition data for a user",
        () async {
      final currentDate = DateTime.now();
      final currentDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      final dailyNutrition = DailyNutrition()
        ..userId = 1
        ..date = currentDay
        ..calories = 2000
        ..protein = 150
        ..carbohydrates = 250
        ..fat = 70;

      await isarTest.writeTxn(() async {
        await isarTest.dailyNutritions.put(dailyNutrition);
      });

      final nutritionData = await nutritionserviceTest.getDailyNutritionById(1);

      expect(nutritionData.calories, 2000);
      expect(nutritionData.protein, 150);
      expect(nutritionData.carbohydrates, 250);
      expect(nutritionData.fat, 70);

      await isarTest.writeTxn(() async {
        await isarTest.dailyNutritions.clear();
      });
    });

    test(
        "getDailyNutritionById returns zeroed nutrition data if no entry exists",
        () async {
      final nutritionData = await nutritionserviceTest.getDailyNutritionById(2);

      expect(nutritionData.calories, 0);
      expect(nutritionData.protein, 0);
      expect(nutritionData.carbohydrates, 0);
      expect(nutritionData.fat, 0);
    });

    test("getDailyNutritionById handles exceptions properly", () async {
      // Simulate an exception by closing the Isar instance
      await isarTest.close();

      expect(
        () async => await nutritionserviceTest.getDailyNutritionById(1),
        throwsException,
      );

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  group("deleteDish Tests", () {
    test("deleteDish deletes the specified dish successfully", () async {
      final dishToDelete = Dish()
        ..name = 'DishToDelete'
        ..calories = 200
        ..protein = 50
        ..carbohydrates = 100
        ..fat = 20
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishToDelete);
      });

      final response = await nutritionserviceTest.deleteDish('DishToDelete', 1);

      expect(response.checksuccess, true);
      expect(response.message, 'DishToDelete was deleted!');

      final remainingDishes =
          await isarTest.dishs.filter().userIdEqualTo(1).findAll();
      expect(remainingDishes.any((dish) => dish.name == 'DishToDelete'), false);
    });

    test("deleteDish returns appropriate message when dish name is empty",
        () async {
      final response = await nutritionserviceTest.deleteDish('', 1);

      expect(response.checksuccess, false);
      expect(response.message, 'Could not delete dish');
    });

    test("deleteDish handles non-existent dish properly", () async {
      final response =
          await nutritionserviceTest.deleteDish('NonExistentDish', 1);

      expect(response.checksuccess, false);
      expect(response.message, 'Could not delete dish');
    });

    test("deleteDish handles exceptions properly", () async {
      // Simulate an exception by closing the Isar instance
      await isarTest.close();

      expect(
        () async => await nutritionserviceTest.deleteDish('AnyDish', 1),
        throwsException,
      );

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  group("editDish Tests", () {
    test("editDish edits the specified dish successfully", () async {
      final oldDish = Dish()
        ..name = 'OldDish'
        ..calories = 200
        ..protein = 50
        ..carbohydrates = 100
        ..fat = 20
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(oldDish);
      });

      final newDishData = NutritionData(
        dish: 'NewDish',
        calories: 300,
        protein: 60,
        carbohydrates: 110,
        fat: 25,
      );

      final response =
          await nutritionserviceTest.editDish(newDishData, 'OldDish', 1);

      expect(response.checksuccess, true);
      expect(response.message, 'NewDish was edited');

      final editedDish = await isarTest.dishs
          .filter()
          .nameEqualTo('NewDish')
          .userIdEqualTo(1)
          .findFirst();
      expect(editedDish, isNotNull);
      expect(editedDish?.calories, 300);
      expect(editedDish?.protein, 60);
      expect(editedDish?.carbohydrates, 110);
      expect(editedDish?.fat, 25);

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("editDish returns appropriate message when new dish name is empty",
        () async {
      final oldDish = Dish()
        ..name = 'OldDish'
        ..calories = 200
        ..protein = 50
        ..carbohydrates = 100
        ..fat = 20
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(oldDish);
      });

      final newDishData = NutritionData(
        dish: '',
        calories: 300,
        protein: 60,
        carbohydrates: 110,
        fat: 25,
      );

      final response =
          await nutritionserviceTest.editDish(newDishData, 'OldDish', 1);

      expect(response.checksuccess, false);
      expect(response.message, 'Dish was not edited');

      await isarTest.writeTxn(() async {
        await isarTest.dishs.clear();
      });
    });

    test("editDish handles non-existent dish properly", () async {
      final newDishData = NutritionData(
        dish: 'NonExistentDish',
        calories: 300,
        protein: 60,
        carbohydrates: 110,
        fat: 25,
      );

      final response =
          await nutritionserviceTest.editDish(newDishData, 'OldDish', 1);

      expect(response.checksuccess, true);
      expect(response.message, 'NonExistentDish was edited');

      final editedDish = await isarTest.dishs
          .filter()
          .nameEqualTo('NonExistentDish')
          .userIdEqualTo(1)
          .findFirst();
      expect(editedDish, isNull);
    });

    test("editDish handles exceptions properly", () async {
      // Simulate an exception by closing the Isar instance
      await isarTest.close();

      final newDishData = NutritionData(
        dish: 'NewDish',
        calories: 300,
        protein: 60,
        carbohydrates: 110,
        fat: 25,
      );

      expect(
        () async =>
            await nutritionserviceTest.editDish(newDishData, 'OldDish', 1),
        throwsException,
      );

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  group("postDailyDish Tests", () {
    test("postDailyDish adds dish to daily nutrition successfully", () async {
      final dishToAdd = Dish()
        ..name = 'DishToAdd'
        ..calories = 200
        ..protein = 50
        ..carbohydrates = 100
        ..fat = 20
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishToAdd);
      });

      final response = await nutritionserviceTest.postDailyDish('DishToAdd', 1);

      expect(response.checksuccess, true);
      expect(response.message, 'DishToAdd was added to your intake!');

      final currentDate = DateTime.now();
      final currentDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      final updatedDailyNutrition = await isarTest.dailyNutritions
          .filter()
          .dateEqualTo(currentDay)
          .userIdEqualTo(1)
          .findFirst();

      expect(updatedDailyNutrition, isNotNull);
      expect(updatedDailyNutrition?.calories, 200);
      expect(updatedDailyNutrition?.protein, 50);
      expect(updatedDailyNutrition?.carbohydrates, 100);
      expect(updatedDailyNutrition?.fat, 20);

      await isarTest.writeTxn(() async {
        await isarTest.dailyNutritions.clear();
        await isarTest.dishs.clear();
      });
    });

    test("postDailyDish returns appropriate message for invalid input",
        () async {
      final response =
          await nutritionserviceTest.postDailyDish('NonExistentDish', 1);

      expect(response.checksuccess, false);
      expect(response.message, 'Invalid input');
    });

    test("postDailyDish handles exceptions properly", () async {
      // Simulate an exception by closing the Isar instance
      await isarTest.close();

      expect(
        () async => await nutritionserviceTest.postDailyDish('AnyDish', 1),
        throwsException,
      );

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  group("putDailyDish Tests", () {
    test("putDailyDish removes dish from daily nutrition successfully",
        () async {
      final dishToAdd = Dish()
        ..name = 'DishToPut'
        ..calories = 200
        ..protein = 50
        ..carbohydrates = 100
        ..fat = 20
        ..userId = 1;

      await isarTest.writeTxn(() async {
        await isarTest.dishs.put(dishToAdd);
      });

      final addResponse =
          await nutritionserviceTest.postDailyDish('DishToPut', 1);

      expect(addResponse.checksuccess, true);
      expect(addResponse.message, 'DishToPut was added to your intake!');

      final removeResponse =
          await nutritionserviceTest.putDailyDish('DishToPut', 1);

      expect(removeResponse.checksuccess, true);
      expect(removeResponse.message, 'DishToPut was removed from your intake!');

      final currentDate = DateTime.now();
      final currentDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      final updatedDailyNutrition = await isarTest.dailyNutritions
          .filter()
          .dateEqualTo(currentDay)
          .userIdEqualTo(1)
          .findFirst();

      expect(updatedDailyNutrition, isNotNull);
      expect(updatedDailyNutrition?.calories, 0);
      expect(updatedDailyNutrition?.protein, 0);
      expect(updatedDailyNutrition?.carbohydrates, 0);
      expect(updatedDailyNutrition?.fat, 0);

      await isarTest.writeTxn(() async {
        await isarTest.dailyNutritions.clear();
        await isarTest.dishs.clear();
      });
    });

    test("putDailyDish returns appropriate message for invalid input",
        () async {
      final response =
          await nutritionserviceTest.putDailyDish('NonExistentDish', 1);

      expect(response.checksuccess, false);
      expect(response.message, 'Invalid input');
    });

    test("putDailyDish handles exceptions properly", () async {
      // Simulate an exception by closing the Isar instance
      await isarTest.close();

      expect(
        () async => await nutritionserviceTest.putDailyDish('AnyDish', 1),
        throwsException,
      );

      // Reopen the Isar instance for subsequent tests
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'nutritionInstance');
      nutritionserviceTest = NutritionService(isarTest);
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
