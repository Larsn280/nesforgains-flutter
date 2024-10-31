import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/screens/recipeScreens/edit_recipe_screen.dart';
import 'package:nes_for_gains/service/recipe_service.dart';

class DisplayRecipeScreen extends StatefulWidget {
  final Isar isar;

  const DisplayRecipeScreen({super.key, required this.isar});

  @override
  State<DisplayRecipeScreen> createState() => _DisplayRecipeScreenState();
}

class _DisplayRecipeScreenState extends State<DisplayRecipeScreen> {
  late RecipeService recipeService;

  @override
  void initState() {
    super.initState();
    recipeService = RecipeService(widget.isar);
  }

  Future<List<Recipe>> getAllRecipesInAlphabeticalOrder() async {
    try {
      final result = await recipeService.getAllRecipes();
      return result;
    } catch (e) {
      logger.e('Error fetching recipes: $e');
      return [];
    }
  }

  void _handleDeleteRecipe(Recipe recipe) async {
    try {
      await recipeService.deleteRecipe(recipe);
      // Triggar en rebuild av widget trädet.
      setState(() {});
    } catch (e) {
      logger.e('Error deleting recipe', error: e);
    }
  }

  void _navigateToEditRecipe(Recipe recipe) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditRecipeScreen(
            recipe: recipe,
            isar: widget.isar,
          ),
        ),
      );
      if (result == true) {
        setState(() {
          getAllRecipesInAlphabeticalOrder();
        });
      }
    } catch (e) {
      logger.e('Error navigating:', error: e);
      _showSnackBar(
          'An error occurred while trying to navigate. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.backgroundimage),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              'Recipes',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: getAllRecipesInAlphabeticalOrder(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildRecipeList([], 'Indicator');
                  } else if (snapshot.hasError) {
                    return _buildRecipeList([], 'Error fetching recipes.');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildRecipeList([], 'No recipes found.');
                  } else {
                    final recipes = snapshot.data!;

                    return _buildRecipeList(recipes, '');
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            AppConstants.buildElevatedFunctionButton(
                context: context,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Go back'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes, String message) {
    return AppConstants.buildListCard(
      context: context,
      child: Column(
        children: [
          Expanded(
            child: recipes.isNotEmpty
                ? ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return ListTile(
                        title: Text(
                            style: const TextStyle(color: Colors.white),
                            recipe.title), // Display recipe title
                        subtitle: Text(
                            style: const TextStyle(color: Colors.white),
                            'Duration: ${recipe.duration} mins, Difficulty: ${recipe.difficulty}'),
                        onTap: () {
                          // Navigate to recipe details (if needed)
                          print('Selected Recipe: ${recipe.title}');
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.greenAccent),
                              onPressed: () {
                                _navigateToEditRecipe(recipe);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                _handleDeleteRecipe(recipe);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: message.startsWith('Indicator')
                        ? CircularProgressIndicator(
                            color: AppConstants.primaryTextColor,
                          )
                        : Text(message),
                  ),
          ),
        ],
      ),
    );
  }
}
