import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
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
      print('Error fetching recipes: $e');
      return [];
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
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: getAllRecipesInAlphabeticalOrder(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching recipes.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recipes found.'));
                  } else {
                    final recipes = snapshot.data!;

                    // Display the recipes in a ListView
                    return Column(
                      children: [
                        const Text(
                          'Recipes',
                          style: AppConstants.headingStyle,
                        ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.white)),
                            child: ListView.builder(
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];

                                return ListTile(
                                  title: Text(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      recipe.title), // Display recipe title
                                  subtitle: Text(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      'Duration: ${recipe.duration} mins, Difficulty: ${recipe.difficulty}'),
                                  onTap: () {
                                    // Navigate to recipe details (if needed)
                                    print('Selected Recipe: ${recipe.title}');
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            AppConstants.buildElevatedButton(
                context: context, path: '/addrecipeScreen', text: 'Go back'),
          ],
        ),
      ),
    );
  }
}
