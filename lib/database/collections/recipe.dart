import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/ingredient.dart';
import 'package:nes_for_gains/database/collections/stage.dart';

part 'recipe.g.dart';

@collection
class Recipe {
  Id id = Isar.autoIncrement; // Automatically generated unique ID
  late String title; // Recipe title (e.g. "Spaghetti Carbonara")
  String? description; // Optional description of the recipe
  late int duration; // Duration in minutes (e.g., 30 mins)
  late String difficulty; // Difficulty level (e.g., "Easy", "Medium", "Hard")
  final ingredients = IsarLinks<Ingredient>(); // Linking to Ingredients
  final stage = IsarLinks<Stage>(); // Linking to steps
  // final categories = IsarLinks<Category>();     // Linking to categories like "Italian", "Vegetarian"
  DateTime? createdAt; // Date when the recipe was created
  DateTime? updatedAt; // Date when the recipe was last updated
}
