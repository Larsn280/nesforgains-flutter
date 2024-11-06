import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/ingredient.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/database/collections/stage.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/response_data.dart';

class RecipeService {
  final Isar _isar;

  RecipeService(this._isar);

  Future<ResponseData> addRecipe(
      Recipe recipe, List<Ingredient> ingredients, List<Stage> stages) async {
    try {
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

        return ResponseData(
            checksuccess: true, message: '${recipe.title} was added.');
      }

      return ResponseData(
          checksuccess: false, message: '${recipe.title} already exists.');
    } catch (e, stackTrace) {
      logger.e('Error adding recipe: $e', stackTrace: stackTrace);
      return ResponseData(
          checksuccess: false, message: 'Error trying to add recipe: $e');
    }
  }

  Future<ResponseData> editRecipe(
      Recipe recipe, List<Ingredient> ingredients, List<Stage> stages) async {
    try {
      final existingRecipe =
          await _isar.recipes.filter().idEqualTo(recipe.id).findFirst();

      if (existingRecipe != null) {
        await _isar.writeTxn(() async {
          // Save ingredients and stages to the database
          await _isar.ingredients.putAll(ingredients);
          await _isar.stages.putAll(stages);

          existingRecipe.ingredients.addAll(ingredients);
          existingRecipe.stage.addAll(stages);

          existingRecipe.title = recipe.title;
          existingRecipe.description = recipe.description;
          existingRecipe.duration = recipe.duration;
          existingRecipe.difficulty = recipe.difficulty;

          await _isar.recipes.put(existingRecipe);

          await existingRecipe.ingredients.save();
          await existingRecipe.stage.save();
        });

        return ResponseData(
            checksuccess: true,
            message: '${recipe.title} was edited successfully.');
      }

      return ResponseData(
          checksuccess: false, message: 'Recipe not found for editing.');
    } catch (e, stackTrace) {
      logger.e('Error editing recipe: $e', stackTrace: stackTrace);

      return ResponseData(
          checksuccess: false, message: 'Something went wrong: $e');
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
            checksuccess: true, message: '${recipe.title} was deleted.');
      }
      return ResponseData(
          checksuccess: false,
          message: 'Could not find ${recipe.title} to delete.');
    } catch (e, stackTrace) {
      logger.e('Error during recipe deletion: $e', stackTrace: stackTrace);
      return ResponseData(
          checksuccess: false, message: 'Error trying to delete recipe: $e');
    }
  }

  Future<List<Recipe>> getAllRecipesInAlphabeticalOrder() async {
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
