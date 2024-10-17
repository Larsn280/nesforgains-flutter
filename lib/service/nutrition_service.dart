import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/models/response_data.dart';
import 'package:isar/isar.dart';

class NutritionService {
  final Isar _isar;

  NutritionService(this._isar);

  NutritionData handleFoodSubmitted(String food) {
    String dish = '';
    int calories = 250;
    int protein = 20;
    int carbohydrates = 30;
    int fat = 10;

    NutritionData processedFoodNutrition = NutritionData(
        dish: dish,
        calories: calories,
        protein: protein,
        carbohydrates: carbohydrates,
        fat: fat);

    return processedFoodNutrition;
  }

  Future<List<NutritionData>?> getAllDishesById(int userId) async {
    List<NutritionData>? allDishItems = [];
    NutritionData dishItem;

    try {
      final dishItems =
          await _isar.dishs.filter().userIdEqualTo(userId).findAll();
      if (dishItems.isNotEmpty) {
        for (var dish in dishItems) {
          dishItem = NutritionData(
              dish: dish.name,
              calories: dish.calories ?? 0,
              protein: dish.protein ?? 0,
              carbohydrates: dish.carbohydrates ?? 0,
              fat: dish.fat ?? 0);
          allDishItems.add(dishItem);
        }
      }

      allDishItems.sort((a, b) => a.dish!.compareTo(b.dish!));

      return allDishItems;
    } catch (e) {
      throw Exception('Something went wrong fetching dishes: $e');
    }
  }

  Future<List<String>> fetchDishItems(int userId) async {
    List<String> dishItemNames = [];

    try {
      final dishItems =
          await _isar.dishs.filter().userIdEqualTo(userId).findAll();

      if (dishItems.isNotEmpty) {
        for (var dish in dishItems) {
          dishItemNames.add(dish.name.toString());
        }
      } else {
        logger.i('No items found in the dish table.');
      }
    } catch (e) {
      logger.e('Error fetching food items', error: e);
    }

    return dishItemNames;
  }

  Future<ResponseData> addDishItem(NutritionData data, int userId) async {
    try {
      final ResponseData responseData;
      final dishItem = await _isar.dishs
          .filter()
          .nameEqualTo(data.dish)
          .userIdEqualTo(userId)
          .findFirst();

      if (dishItem == null) {
        final newDish = Dish()
          ..name = data.dish.toString()
          ..calories = data.calories.toInt()
          ..protein = data.protein.toInt()
          ..carbohydrates = data.carbohydrates.toInt()
          ..fat = data.fat.toInt()
          ..userId = userId;
        await _isar.writeTxn(() async {
          await _isar.dishs.put(newDish);
        });
        responseData = ResponseData(
            checksuccess: true,
            message: '${data.dish} was successfully added!');
        return responseData;
      } else {
        responseData = ResponseData(
            checksuccess: false, message: '${data.dish} already exists');
        return responseData;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<NutritionData> getDailyNutritionById(int userId) async {
    try {
      final currentDate = DateTime.now();
      // Set time components to 0
      final currentDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      final intake = await _isar.dailyNutritions
          .filter()
          .userIdEqualTo(userId)
          .dateEqualTo(currentDay)
          .findFirst();
      if (intake != null) {
        final nutritionData = NutritionData(
            dish: '',
            calories: intake.calories!,
            protein: intake.protein!,
            carbohydrates: intake.carbohydrates!,
            fat: intake.fat!);
        return nutritionData;
      } else {
        final nutritionData = NutritionData(
            dish: '', calories: 0, protein: 0, carbohydrates: 0, fat: 0);
        return nutritionData;
      }
    } catch (e) {
      throw Exception('Oops something went wrong fetching intake!');
    }
  }

  Future<List<DailyNutrition>> getNutritionListByUserId(int userId) async {
    try {
      final nutrition =
          await _isar.dailyNutritions.filter().userIdEqualTo(userId).findAll();
      if (nutrition.isNotEmpty) {
        return nutrition;
      }
      return [];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ResponseData> deleteDish(String name, int userId) async {
    ResponseData responseData;
    try {
      if (name != '') {
        final dishtodelete = await _isar.dishs
            .filter()
            .nameEqualTo(name)
            .userIdEqualTo(userId)
            .findFirst();
        if (dishtodelete != null) {
          await _isar.writeTxn(() async {
            await _isar.dishs.delete(dishtodelete.id);
          });
          responseData = ResponseData(
              checksuccess: true, message: '${dishtodelete.name} was deleted!');
          return responseData;
        }
        responseData =
            ResponseData(checksuccess: false, message: 'Could not delete dish');
        return responseData;
      } else {
        responseData =
            ResponseData(checksuccess: false, message: 'Could not delete dish');
        return responseData;
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<ResponseData> editDish(
      NutritionData dishdata, String olddishname, int userId) async {
    ResponseData responseData;
    try {
      {
        if (dishdata.dish != '') {
          final dishtoedit = await _isar.dishs
              .filter()
              .nameEqualTo(olddishname)
              .userIdEqualTo(userId)
              .findFirst();

          if (dishtoedit != null) {
            dishtoedit.name = dishdata.dish;
            dishtoedit.calories = dishdata.calories;
            dishtoedit.protein = dishdata.protein;
            dishtoedit.carbohydrates = dishdata.carbohydrates;
            dishtoedit.fat = dishdata.fat;
            await _isar.writeTxn(() async {
              await _isar.dishs.put(dishtoedit);
            });
          }

          responseData = ResponseData(
              checksuccess: true, message: '${dishdata.dish} was edited');
          return responseData;
        } else {
          responseData =
              ResponseData(checksuccess: false, message: 'Dish was not edited');
          return responseData;
        }
      }
    } catch (e) {
      throw Exception('Error editing: $e');
    }
  }

  Future<ResponseData> postDailyDish(String dish, int userId) async {
    try {
      final ResponseData responseData;
      final dishItem = await _isar.dishs
          .filter()
          .nameEqualTo(dish)
          .userIdEqualTo(userId)
          .findFirst();

      if (dishItem != null) {
        // Get the current date
        final currentDate = DateTime.now();
        // Set time components to 0
        final currentDay =
            DateTime(currentDate.year, currentDate.month, currentDate.day);

        final currentDailyNutrition = await _isar.dailyNutritions
            .filter()
            .dateEqualTo(currentDay)
            .userIdEqualTo(userId)
            .findFirst();

        if (currentDailyNutrition != null) {
          currentDailyNutrition.calories =
              (currentDailyNutrition.calories ?? 0) + (dishItem.calories ?? 0);
          currentDailyNutrition.protein =
              (currentDailyNutrition.protein ?? 0) + (dishItem.protein ?? 0);
          currentDailyNutrition.carbohydrates =
              (currentDailyNutrition.carbohydrates ?? 0) +
                  (dishItem.carbohydrates ?? 0);
          currentDailyNutrition.fat =
              (currentDailyNutrition.fat ?? 0) + (dishItem.fat ?? 0);
          // Save the updated DailyNutrition item
          await _isar.writeTxn(() async {
            await _isar.dailyNutritions.put(currentDailyNutrition);
          });
          responseData = ResponseData(
              checksuccess: true, message: '$dish was added to your intake!');
          return responseData;
        } else {
          final newDailyNutrition = DailyNutrition()
            ..date = currentDay
            ..calories = dishItem.calories
            ..protein = dishItem.protein
            ..carbohydrates = dishItem.carbohydrates
            ..fat = dishItem.fat
            ..userId = userId;
          await _isar.writeTxn(() async {
            await _isar.dailyNutritions.put(newDailyNutrition);
          });
        }
        responseData = ResponseData(
            checksuccess: true, message: '$dish was added to your intake!');
        return responseData;
      } else {
        responseData =
            ResponseData(checksuccess: false, message: 'Invalid input');
        return responseData;
      }
    } catch (e) {
      throw Exception('Oops something went wrong posting intake!');
    }
  }

  Future<ResponseData> putDailyDish(String dish, int userId) async {
    try {
      final ResponseData responseData;
      final dishItem = await _isar.dishs
          .filter()
          .nameEqualTo(dish)
          .userIdEqualTo(userId)
          .findFirst();

      if (dishItem != null) {
        // Get the current date
        final currentDate = DateTime.now();
        // Set time components to 0
        final currentDay =
            DateTime(currentDate.year, currentDate.month, currentDate.day);

        final currentDailyNutrition = await _isar.dailyNutritions
            .filter()
            .dateEqualTo(currentDay)
            .userIdEqualTo(userId)
            .findFirst();

        int checkNutrition(int nutrition, int subtractednutrition) {
          nutrition = nutrition - subtractednutrition;
          if (nutrition < 0) {
            nutrition = 0;
            return nutrition;
          }
          return nutrition;
        }

        if (currentDailyNutrition != null) {
          currentDailyNutrition.calories = checkNutrition(
              currentDailyNutrition.calories!, dishItem.calories!);

          currentDailyNutrition.protein =
              checkNutrition(currentDailyNutrition.protein!, dishItem.protein!);

          currentDailyNutrition.carbohydrates = checkNutrition(
              currentDailyNutrition.carbohydrates!, dishItem.carbohydrates!);

          currentDailyNutrition.fat =
              checkNutrition(currentDailyNutrition.fat!, dishItem.fat!);

          // Save the updated DailyNutrition item
          await _isar.writeTxn(() async {
            await _isar.dailyNutritions.put(currentDailyNutrition);
          });
          responseData = ResponseData(
              checksuccess: true,
              message: '$dish was removed from your intake!');
          return responseData;
        } else {
          final newDailyNutrition = DailyNutrition()
            ..date = currentDay
            ..calories = dishItem.calories
            ..protein = dishItem.protein
            ..carbohydrates = dishItem.carbohydrates
            ..fat = dishItem.fat
            ..userId = userId;
          await _isar.writeTxn(() async {
            await _isar.dailyNutritions.put(newDailyNutrition);
          });
        }
        responseData = ResponseData(
            checksuccess: true, message: '$dish was added to you intake!');
        return responseData;
      } else {
        responseData =
            ResponseData(checksuccess: false, message: 'Invalid input');
        return responseData;
      }
    } catch (e) {
      throw Exception('Oops something went wrong posting intake!');
    }
  }
}
