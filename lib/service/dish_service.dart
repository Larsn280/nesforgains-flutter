import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/models/response_data.dart';
import 'package:isar/isar.dart';

class DishService {
  final Isar _isar;

  DishService(this._isar);

  Future<List<NutritionData>> fetchAllDishesById(int userId) async {
    try {
      final dishItems =
          await _isar.dishs.filter().userIdEqualTo(userId).findAll();

      // Return early if no dish items are found
      if (dishItems.isEmpty) {
        return []; // Returning an empty list
      }

      // Transforming dishItems into NutritionData using map
      List<NutritionData> allDishItems = dishItems.map((dish) {
        return NutritionData(
          dish: dish.name,
          calories: dish.calories ?? 0,
          protein: dish.protein ?? 0,
          carbohydrates: dish.carbohydrates ?? 0,
          fat: dish.fat ?? 0,
        );
      }).toList();

      // Sorting the dish items by name
      allDishItems.sort((a, b) => a.dish!.compareTo(b.dish!));

      return allDishItems;
    } catch (e) {
      // Log the error if necessary and return an empty list
      logger.e('Error trying to fetch dishes: ${e.toString()}');
      return []; // Returning an empty list on error
    }
  }

  Future<List<String>> fetchAllDishNamesById(int userId) async {
    try {
      final dishItems =
          await _isar.dishs.filter().userIdEqualTo(userId).findAll();

      // Return an empty list if no dish items are found
      if (dishItems.isEmpty) {
        logger.i('No items found in the dish table.');
        return []; // Returning an empty list
      }

      // Using map to create the list of dish names
      List<String> dishItemNames =
          dishItems.map((dish) => dish.name.toString()).toList();

      return dishItemNames;
    } catch (e) {
      logger.e('Error fetching food items', error: e);
      return []; // Returning an empty list on error
    }
  }

  Future<ResponseData> addDish(NutritionData data, int userId) async {
    try {
      final dishItem = await _isar.dishs
          .filter()
          .nameEqualTo(data.dish)
          .userIdEqualTo(userId)
          .findFirst();

      // If the dish does not exist, create a new one
      if (dishItem == null) {
        final newDish = Dish()
          ..name = data.dish.toString()
          ..calories = data.calories.toInt() ?? 0
          ..protein = data.protein.toInt() ?? 0
          ..carbohydrates = data.carbohydrates.toInt() ?? 0
          ..fat = data.fat.toInt() ?? 0
          ..userId = userId;

        await _isar.writeTxn(() async {
          await _isar.dishs.put(newDish);
        });

        return ResponseData(
          checksuccess: true,
          message: '${data.dish} was successfully added!',
        );
      } else {
        // If the dish already exists, return a failure response
        return ResponseData(
          checksuccess: false,
          message: '${data.dish} already exists',
        );
      }
    } catch (e) {
      // Log the error and return a response indicating failure
      return ResponseData(
        checksuccess: false,
        message: 'Error trying to add dish: ${e.toString()}',
      );
    }
  }

  Future<ResponseData> deleteDish(String name, int userId) async {
    try {
      // Check if the dish name is provided
      if (name.isEmpty) {
        return ResponseData(
            checksuccess: false, message: 'Dish name cannot be empty.');
      }

      // Attempt to find the dish to delete
      final dishToDelete = await _isar.dishs
          .filter()
          .nameEqualTo(name)
          .userIdEqualTo(userId)
          .findFirst();

      // If the dish is found, proceed to delete
      if (dishToDelete != null) {
        await _isar.writeTxn(() async {
          await _isar.dishs.delete(dishToDelete.id);
        });
        return ResponseData(
            checksuccess: true, message: '${dishToDelete.name} was deleted!');
      }

      // If the dish was not found, return a failure response
      return ResponseData(
          checksuccess: false, message: 'Could not find: $name to delete');
    } catch (e) {
      // Log the error and return a failure response
      return ResponseData(
          checksuccess: false,
          message: 'Error trying to delete dish: ${e.toString()}');
    }
  }

  Future<ResponseData> editDish(
      NutritionData dishData, String oldDishName, int userId) async {
    try {
      // Early return if the new dish name is empty
      if (dishData.dish == '') {
        return ResponseData(
            checksuccess: false, message: 'New dish name cannot be empty.');
      }

      // Attempt to find the dish to edit
      final dishToEdit = await _isar.dishs
          .filter()
          .nameEqualTo(oldDishName)
          .userIdEqualTo(userId)
          .findFirst();

      // If the dish is found, update its properties
      if (dishToEdit != null) {
        dishToEdit.name = dishData.dish;
        dishToEdit.calories = dishData.calories.toInt();
        dishToEdit.protein = dishData.protein.toInt();
        dishToEdit.carbohydrates = dishData.carbohydrates.toInt();
        dishToEdit.fat = dishData.fat.toInt();

        await _isar.writeTxn(() async {
          await _isar.dishs.put(dishToEdit);
        });

        return ResponseData(
            checksuccess: true, message: '${dishData.dish} was edited');
      }

      // If the dish was not found, return a failure response
      return ResponseData(
          checksuccess: false, message: 'Could not find: $oldDishName to edit');
    } catch (e) {
      // Log the error and return a failure response
      return ResponseData(
          checksuccess: false,
          message: 'Error trying to edit dish: ${e.toString()}');
    }
  }
}
