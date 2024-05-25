import 'package:NESForGains/database/collections/daily_nutrition.dart';
import 'package:NESForGains/database/collections/dish.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/models/response_data.dart';
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
      return allDishItems;
    } catch (e) {
      throw Exception('Something went wrong fetching dishes');
    }
  }

  Future<List<String>> fetchFoodItems(int userId) async {
    // Initialize an empty list to store food item names
    List<String> dishItemNames = [];

    try {
      // Perform the database query to get all items
      final dishItems =
          await _isar.dishs.filter().userIdEqualTo(userId).findAll();

      // Check if any items were returned
      if (dishItems.isNotEmpty) {
        // Extract dish names from the list of Dish objects
        // dishItemNames = dishItems.map((dish) => dish.name!).toList();
        for (var dish in dishItems) {
          dishItemNames.add(dish.name.toString());
        }
      } else {
        print('No items found in the dish table.');
        // Optionally handle the case where the database is empty
      }
    } catch (e) {
      print('Error fetching food items: $e');
      // Handle any potential errors
    }

    return dishItemNames;
  }

  Future<ResponseData> addfoodItem(NutritionData data, int userId) async {
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

  // TODO Fixa så att den deletar med id.
  Future<ResponseData> deleteDish(String name) async {
    ResponseData responseData;
    try {
      if (name != '') {
        final dishtodelete =
            await _isar.dishs.filter().nameEqualTo(name).findFirst();
        await _isar.writeTxn(() async {
          await _isar.dishs.delete(dishtodelete!.id);
        });
        responseData = ResponseData(
            checksuccess: true, message: '${dishtodelete!.name} was deleted!');
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

  Future<ResponseData> editDish(NutritionData dishdata) async {
    ResponseData responseData;
    try {
      {
        if (dishdata.dish != '') {
          final dishtoedit =
              await _isar.dishs.filter().nameEqualTo(dishdata.dish).findFirst();
          dishtoedit!.name == dishdata.dish;
          dishtoedit.calories == dishdata.calories;
          dishtoedit.protein == dishdata.protein;
          dishtoedit.carbohydrates == dishdata.carbohydrates;
          dishtoedit.fat == dishdata.fat;

          await _isar.writeTxn(() async {
            await _isar.dishs.put(dishtoedit);
          });
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
      throw Exception('message: $e');
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
