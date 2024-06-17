import 'package:isar/isar.dart';

part 'dish.g.dart';

@collection
class Dish {
  Id id = Isar.autoIncrement;
  String? name;
  int? calories;
  int? protein;
  int? carbohydrates;
  int? fat;
  int? userId;

  Dish({
    this.name,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.userId,
  });
}
