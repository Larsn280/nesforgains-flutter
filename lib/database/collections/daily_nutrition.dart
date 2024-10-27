import 'package:isar/isar.dart';

part 'daily_nutrition.g.dart';

@collection
class DailyNutrition {
  Id id = Isar.autoIncrement;
  DateTime? date;
  int? calories;
  int? protein;
  int? carbohydrates;
  int? fat;
  int? userId;

  DailyNutrition({
    this.date,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.userId,
  });
}
