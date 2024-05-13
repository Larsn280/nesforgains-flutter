import 'package:NESForGains/models/nutritionData.dart';

class FoodService {
  NutritionData handleFoodSubmitted(String food) {
    int calories = 250;
    int protein = 20;
    int carbohydrates = 30;
    int fat = 10;

    NutritionData processedFoodNutrition = NutritionData(
        calories: calories,
        protein: protein,
        carbohydrates: carbohydrates,
        fat: fat);

    return processedFoodNutrition;
  }
}
