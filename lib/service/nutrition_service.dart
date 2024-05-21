import 'package:NESForGains/database/collections/dish.dart';
import 'package:NESForGains/models/nutrition_data.dart';
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

  Future<String> addfoodItem(NutritionData data, int userId) async {
    try {
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
        return '${data.dish} was successfully added!';
      } else {
        return '${data.dish} already exists';
      }
    } catch (e) {
      return 'Sorry something went wrong adding: ${data.dish}';
    }
  }

//   Future<List<NutritionData>> getAllItems() async {
//   // Open the Isar instance

//   // Get a reference to the collection
//   var collection = isar.dishs;

//   try {
//     // Retrieve all items from the collection
//     List<NutritionData> items = await Dish.getAll();

//     // Return the list of items
//     return items;
//   } catch (e) {
//     // Handle any potential errors
//     print('Error fetching items: $e');
//     return [];
//   }
// }
}
