import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/models/recipe_data.dart';
import 'package:nes_for_gains/models/response_data.dart';

class RecipeService {
  final Isar _isar;

  RecipeService(this._isar);

  Future<ResponseData> addRecipeToDatabase(Recipe recipe) async {
    try {
      final ResponseData responseData;

      final checkRecipe =
          await _isar.recipes.filter().titleEqualTo(recipe.title).findFirst();

      if (checkRecipe == null) {
        await _isar.writeTxn(() async {
          await _isar.recipes.put(recipe);
        });
        responseData =
            ResponseData(checksuccess: true, message: 'Recipe was added');
        return responseData;
      } else {
        responseData =
            ResponseData(checksuccess: false, message: 'Recipe already exists');
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

  Future<List<Recipe>> getAllRecipes() async {
    try {
      List<Recipe> recipes =
          await _isar.recipes.where().sortByTitle().findAll();
      return recipes;
    } catch (e) {
      throw Exception('Error while retriving recipes');
    }
  }
}
