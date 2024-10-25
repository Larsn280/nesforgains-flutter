import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/models/response_data.dart';

class NutritionService {
  final Isar _isar;

  NutritionService(this._isar);

  Future<NutritionData> fetchDailyNutritionById(int userId) async {
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

  Future<List<DailyNutrition>> fetchNutritionListByUserId(int userId) async {
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

  Future<ResponseData> postDailyDish(String dish, int userId) async {
    try {
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
          return ResponseData(
              checksuccess: true, message: '$dish was added to your intake!');
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
        return ResponseData(
            checksuccess: true, message: '$dish was added to your intake!');
      } else {
        return ResponseData(checksuccess: false, message: 'Invalid input');
      }
    } catch (e) {
      throw Exception('Error when trying to add intake: $e');
    }
  }

  Future<ResponseData> putDailyDish(String dish, int userId) async {
    try {
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
          return ResponseData(
              checksuccess: true,
              message: '$dish was removed from your intake!');
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
        return ResponseData(
            checksuccess: true, message: '$dish was added to you intake!');
      } else {
        return ResponseData(checksuccess: false, message: 'Invalid input');
      }
    } catch (e) {
      throw Exception('Error while trying to add intake: $e');
    }
  }
}
