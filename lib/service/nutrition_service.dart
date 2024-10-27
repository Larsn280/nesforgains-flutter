import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/logger.dart';
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

      // Attempt to find daily nutrition intake for the user
      final intake = await _isar.dailyNutritions
          .filter()
          .userIdEqualTo(userId)
          .dateEqualTo(currentDay)
          .findFirst();

      // If intake exists, return the nutrition data
      if (intake != null) {
        return NutritionData(
          dish: '',
          calories: intake.calories ?? 0,
          protein: intake.protein ?? 0,
          carbohydrates: intake.carbohydrates ?? 0,
          fat: intake.fat ?? 0,
        );
      }

      // Return default nutrition data if no intake is found
      return NutritionData(
        dish: '',
        calories: 0,
        protein: 0,
        carbohydrates: 0,
        fat: 0,
      );
    } catch (e) {
      // Log the error and return a default NutritionData object
      return NutritionData(
        dish: '',
        calories: 0,
        protein: 0,
        carbohydrates: 0,
        fat: 0,
      );
    }
  }

  Future<List<DailyNutrition>> fetchNutritionListByUserId(int userId) async {
    try {
      // Fetch nutrition data for the user
      final nutrition = await _isar.dailyNutritions
          .filter()
          .userIdEqualTo(userId)
          .findAll(); // Use null-aware operator to avoid null

      // Return the fetched nutrition data
      return nutrition;
    } catch (e) {
      // Log the error if you have a logging mechanism
      logger.e('Error fetching nutrition list for user $userId', error: e);

      // Return an empty list to indicate failure
      return [];
    }
  }

  Future<ResponseData> postDailyDish(String dish, int userId) async {
    try {
      final dishItem = await _isar.dishs
          .filter()
          .nameEqualTo(dish)
          .userIdEqualTo(userId)
          .findFirst();

      // Check if the dish item is valid
      if (dishItem == null) {
        return ResponseData(checksuccess: false, message: 'Invalid input');
      }

      // Get the current date and set time components to 0
      final currentDate = DateTime.now();
      final currentDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      // Attempt to fetch current daily nutrition for the user
      final currentDailyNutrition = await _isar.dailyNutritions
          .filter()
          .dateEqualTo(currentDay)
          .userIdEqualTo(userId)
          .findFirst();

      if (currentDailyNutrition != null) {
        // Update existing daily nutrition
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
      } else {
        // Create a new DailyNutrition record
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

      // Return success response once
      return ResponseData(
          checksuccess: true, message: '$dish was added to your intake!');
    } catch (e) {
      // Log the error if you have a logging mechanism
      // logger.e('Error adding intake for user $userId', error: e);
      return ResponseData(
          checksuccess: false,
          message: 'Error when trying to add intake: ${e.toString()}');
    }
  }

  Future<ResponseData> putDailyDish(String dish, int userId) async {
    try {
      final dishItem = await _isar.dishs
          .filter()
          .nameEqualTo(dish)
          .userIdEqualTo(userId)
          .findFirst();

      // Check if the dish item is valid
      if (dishItem == null) {
        return ResponseData(checksuccess: false, message: 'Invalid input');
      }

      // Set current date to remove dish from intake
      final currentDay =
          DateTime.now().toLocal(); // Time components set to 0 implicitly

      // Attempt to fetch current daily nutrition for the user
      final currentDailyNutrition = await _isar.dailyNutritions
          .filter()
          .dateEqualTo(currentDay)
          .userIdEqualTo(userId)
          .findFirst();

      // Function to check nutrition after subtraction
      int checkNutrition(int nutrition, int subtractedNutrition) {
        return (nutrition - subtractedNutrition).clamp(0, nutrition);
      }

      if (currentDailyNutrition != null) {
        // Update existing daily nutrition
        currentDailyNutrition.calories = checkNutrition(
            currentDailyNutrition.calories ?? 0, dishItem.calories ?? 0);
        currentDailyNutrition.protein = checkNutrition(
            currentDailyNutrition.protein ?? 0, dishItem.protein ?? 0);
        currentDailyNutrition.carbohydrates = checkNutrition(
            currentDailyNutrition.carbohydrates ?? 0,
            dishItem.carbohydrates ?? 0);
        currentDailyNutrition.fat =
            checkNutrition(currentDailyNutrition.fat ?? 0, dishItem.fat ?? 0);

        // Save the updated DailyNutrition item
        await _isar.writeTxn(() async {
          await _isar.dailyNutritions.put(currentDailyNutrition);
        });
        return ResponseData(
            checksuccess: true, message: '$dish was removed from your intake!');
      } else {
        // If no daily nutrition exists, create one with negative values for removal scenario
        final newDailyNutrition = DailyNutrition()
          ..date = currentDay
          ..calories = 0 // Start at 0 since we are removing intake
          ..protein = 0
          ..carbohydrates = 0
          ..fat = 0
          ..userId = userId;

        await _isar.writeTxn(() async {
          await _isar.dailyNutritions.put(newDailyNutrition);
        });

        return ResponseData(
            checksuccess: true, message: '$dish was removed from your intake!');
      }
    } catch (e) {
      // Log the error if you have a logging mechanism
      // logger.e('Error removing dish $dish for user $userId', error: e);
      return ResponseData(
          checksuccess: false,
          message: 'Error while trying to remove intake: ${e.toString()}');
    }
  }
}
