import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/screens/recipeScreens/add_recipe_screen.dart';
import 'package:nes_for_gains/screens/recipeScreens/display_recipe_details_screen.dart';
import 'package:nes_for_gains/service/recipe_service.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';

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

  Future<List<Recipe>> _fetchAllRecipes() async {
    try {
      return await recipeService.getAllRecipesInAlphabeticalOrder();
    } catch (e, stackTrace) {
      logger.e('An error occurred while fetching recipes: $e',
          stackTrace: stackTrace);
      throw Exception(
          'Failed to fetch recipes'); // Throwing an exception so FutureBuilder can handle it
    }
  }

  void _navigateToAddRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipeScreen(
          isar: widget.isar,
        ),
      ),
    );
    if (result == true) {
      setState(() {
        _fetchAllRecipes();
      });
    }
  }

  void _navigateToRecipeDetails(Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayRecipeDetailsScreen(
          isar: widget.isar,
          recipe: recipe,
        ),
      ),
    );
    if (result == true) {
      setState(() {
        _fetchAllRecipes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConstants.appbackgroundimage),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              const CustomAppbar(
                title: 'Recipes',
              ),
              const SizedBox(
                height: 40.0,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<Recipe>>(
                  future: _fetchAllRecipes(),
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
              const SizedBox(height: 8.0),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    _navigateToAddRecipe();
                  },
                  text: 'Add'),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  text: 'Home'),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes, String message) {
    return CustomCards.buildListCard(
      context: context,
      child: Column(
        children: [
          Expanded(
            child: recipes.isNotEmpty
                ? ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return GestureDetector(
                        onTap: () {
                          _navigateToRecipeDetails(recipe);
                        },
                        child: Card(
                          color: Colors.black54,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                  style: const TextStyle(color: Colors.white),
                                  recipe.title), // Display recipe title
                              subtitle: Text(
                                  style: const TextStyle(color: Colors.white),
                                  'Duration: ${recipe.duration} mins, Difficulty: ${recipe.difficulty}'),
                            ),
                          ),
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
