import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/models/response_data.dart';
import 'package:isar/isar.dart';

class DishService {
  final Isar _isar;

  DishService(this._isar);

  Future<List<NutritionData>?> fetchAllDishesById(int userId) async {
    try {
      List<NutritionData>? allDishItems = [];
      NutritionData dishItem;
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
      throw Exception('Error trying to fetch dishes: $e');
    }
  }

  Future<List<String>> fetchAllDishNamesById(int userId) async {
    try {
      List<String> dishItemNames = [];
      final dishItems =
          await _isar.dishs.filter().userIdEqualTo(userId).findAll();

      if (dishItems.isNotEmpty) {
        for (var dish in dishItems) {
          dishItemNames.add(dish.name.toString());
        }
      } else {
        logger.i('No items found in the dish table.');
      }
      return dishItemNames;
    } catch (e) {
      logger.e('Error fetching food items', error: e);
      throw Exception('Error trying to fetch dishnames: $e');
    }
  }

  Future<ResponseData> addDish(NutritionData data, int userId) async {
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
      throw Exception('Error trying to add dish: $e');
    }
  }

  Future<ResponseData> deleteDish(String name, int userId) async {
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
          return ResponseData(
              checksuccess: true, message: '${dishtodelete.name} was deleted!');
        }
      }
      return ResponseData(
          checksuccess: false, message: 'Could not find: $name to delete');
    } catch (e) {
      throw Exception('Error trying to delete: $e');
    }
  }

  Future<ResponseData> editDish(
      NutritionData dishdata, String olddishname, int userId) async {
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

          return ResponseData(
              checksuccess: true, message: '${dishdata.dish} was edited');
        }
        return ResponseData(
            checksuccess: false,
            message: 'Could not find: $olddishname to edit');
      }
    } catch (e) {
      throw Exception('Error tryng to edit: $e');
    }
  }
}
