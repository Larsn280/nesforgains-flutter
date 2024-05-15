import 'package:NESForGains/models/nutrition_data.dart';

class NutritionService {
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
}
