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

  Future<ResponseData> editRecipe(Recipe recipe,
      List<Ingredient> newIngredients, List<Stage> newStages) async {
    try {
      final existingRecipe =
          await _isar.recipes.filter().idEqualTo(recipe.id).findFirst();

      if (existingRecipe != null) {
        await _isar.writeTxn(() async {
          await existingRecipe.ingredients.load();
          await existingRecipe.stage.load();

          if (existingRecipe.ingredients.isNotEmpty) {
            await _isar.ingredients.deleteAll(
                existingRecipe.ingredients.map((ing) => ing.id).toList());
          }

          if (existingRecipe.stage.isNotEmpty) {
            await _isar.stages
                .deleteAll(existingRecipe.stage.map((s) => s.id).toList());
          }

          existingRecipe.ingredients.reset();
          existingRecipe.ingredients.save();
          existingRecipe.stage.reset();
          existingRecipe.stage.save();

          await _isar.ingredients.putAll(newIngredients);
          await _isar.stages.putAll(newStages);

          existingRecipe.ingredients.addAll(newIngredients);
          existingRecipe.stage.addAll(newStages);

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
          checksuccess: false, message: 'Error editing recipe: $e');
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
    } catch (e, stackTrace) {
      logger.e('Error fetching recipes $e', stackTrace: stackTrace);
      throw Exception('Error while retriving recipes');
    }
  }

  Future<Recipe> fetchRecipeById(int recipeId) async {
    try {
      final recipeToFetch =
          await _isar.recipes.filter().idEqualTo(recipeId).findFirst();

      if (recipeToFetch == null) {
        throw Exception('Recipe not found for ID $recipeId');
      }

      await recipeToFetch.stage.load();
      await recipeToFetch.ingredients.load();

      return recipeToFetch;
    } catch (e, stackTrace) {
      logger.e('Error fetching recipe: $e', stackTrace: stackTrace);
      throw Exception('Failed to fetch recipe: $e');
    }
  }
}
