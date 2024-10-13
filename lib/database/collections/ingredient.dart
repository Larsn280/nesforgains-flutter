import 'package:isar/isar.dart';

part 'ingredient.g.dart';

@collection
class Ingredient {
  Id id = Isar.autoIncrement;
  late String name; // Ingredient name (e.g., "Flour", "Eggs")
  String? unit; // Unit (e.g., "grams", "ml", "pieces")
  late double quantity; // Quantity of the ingredient (e.g., "200 grams")
  String? note; // Optional note (e.g., "chopped finely")
}
