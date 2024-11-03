import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/ingredient.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/database/collections/stage.dart';
import 'package:nes_for_gains/models/recipe_data.dart';
import 'package:nes_for_gains/models/response_data.dart';

class RecipeService {
  final Isar _isar;

  RecipeService(this._isar);

  Future<ResponseData> addRecipeToDatabase(
      Recipe recipe, List<Ingredient> ingredients, List<Stage> stages) async {
    try {
      final ResponseData responseData;

      final checkRecipe =
          await _isar.recipes.filter().titleEqualTo(recipe.title).findFirst();

      if (checkRecipe == null) {
        await _isar.writeTxn(() async {
          // Save ingredients and stages to the database
          await _isar.ingredients.putAll(ingredients);
          await _isar.stages.putAll(stages);

          // Link ingredients and stages to the recipe
          recipe.ingredients.addAll(ingredients);
          recipe.stage.addAll(stages);

          // Save the recipe with the linked ingredients and stages
          await _isar.recipes.put(recipe);

          // Save the links to the database
          await recipe.ingredients.save();
          await recipe.stage.save();
        });
        responseData = ResponseData(
            checksuccess: true, message: '${recipe.title} was added');
        return responseData;
      } else {
        responseData = ResponseData(
            checksuccess: false, message: '${recipe.title} already exists');
        return responseData;
      }
    } catch (e) {
      throw Exception('Error while saving recipe: $e');
    }
  }

  Future<ResponseData> updateRecipe(RecipeData data) async {
    try {
      late ResponseData responseData;
      responseData = ResponseData(checksuccess: true, message: '');

      return responseData;
    } catch (e) {
      throw Exception('Something went wrong editing $e');
    }
  }

  Future<ResponseData> deleteRecipe(Recipe recipe) async {
    try {
      final recipeToDelete = await _isar.recipes
          .filter()
          .idEqualTo(recipe.id)
          .titleEqualTo(recipe.title)
          .findFirst();

      if (recipeToDelete != null) {
        await _isar.writeTxn(() async {
          await _isar.recipes.delete(recipeToDelete.id);
        });
        return ResponseData(
            checksuccess: true, message: '${recipe.title} was deleted');
      }
      return ResponseData(
          checksuccess: false,
          message: 'Could not find ${recipe.title} to delete.');
    } catch (e) {
      return ResponseData(
          checksuccess: false, message: 'Error trying to delete recipe: $e');
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    try {
      List<Recipe> recipes =
          await _isar.recipes.where().sortByTitle().findAll();

      for (var recipe in recipes) {
        await recipe.ingredients.load();
        await recipe.stage.load();
      }
      return recipes;
    } catch (e) {
      throw Exception('Error while retriving recipes');
    }
  }
}
