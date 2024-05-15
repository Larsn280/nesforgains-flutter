import 'package:isar/isar.dart';

part 'ingredient.g.dart';

@collection
class Ingredient {
  Id id = Isar.autoIncrement;
  String? name;
  int? calories;
  int? protein;
  int? carbohydrates;
  int? fat;
  int? userId;
}
