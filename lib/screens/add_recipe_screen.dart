import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/ingredient.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/database/collections/stage.dart';
import 'package:nes_for_gains/service/recipe_service.dart';

class AddRecipeScreen extends StatefulWidget {
  final Isar isar;

  const AddRecipeScreen({super.key, required this.isar});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  late RecipeService recipeService;

  @override
  void initState() {
    super.initState();
    recipeService = RecipeService(widget.isar);
  }

  Future<void> _saveRecipe() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Create a new Recipe object
      final recipe = Recipe()
        ..title = _titleController.text
        ..description = _descriptionController.text
        ..duration = int.parse(_durationController.text)
        ..difficulty = _difficultyController.text;

      // Create Ingredients and Steps from the text fields
      final ingredientList =
          _ingredientsController.text.split(","); // Input like "Flour, Eggs"
      final stageList = _stepsController.text
          .split("."); // Input like "Boil water. Add pasta."

      // Add ingredients to the recipe
      for (var ingredientText in ingredientList) {
        final ingredient = Ingredient()
          ..name = ingredientText.trim() // Remove any extra spaces
          ..quantity = 1 // Default quantity, you can extend this for user input
          ..unit = "unit"; // Default unit
        recipe.ingredients.add(ingredient);
      }

      // Add steps to the recipe
      for (int i = 0; i < stageList.length; i++) {
        final stage = Stage()
          ..stageNumber = i + 1
          ..instruction = stageList[i].trim();
        recipe.stage.add(stage);
      }

      final result = await recipeService.addRecipeToDatabase(recipe);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message),
      ));

      // Clear the form fields
      _formKey.currentState!.reset();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _difficultyController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Add new Recipe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                const SizedBox(height: 16.0),
                // Title Input
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Recipe Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipe title';
                    }
                    return null;
                  },
                ),

                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),

                // Duration Input
                TextFormField(
                  controller: _durationController,
                  decoration:
                      const InputDecoration(labelText: 'Duration (in minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the duration';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),

                // Difficulty Input
                TextFormField(
                  controller: _difficultyController,
                  decoration: const InputDecoration(labelText: 'Difficulty'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the difficulty';
                    }
                    return null;
                  },
                ),

                // Ingredients Input
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                      labelText: 'Ingredients (comma separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one ingredient';
                    }
                    return null;
                  },
                ),

                // Steps Input
                TextFormField(
                  controller: _stepsController,
                  decoration: const InputDecoration(
                      labelText: 'Steps (period separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the steps';
                    }
                    return null;
                  },
                ),

                // Save Button
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: const Text('Save Recipe'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/displayrecipeScreen');
                  },
                  child: const Text('Display Recipes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
