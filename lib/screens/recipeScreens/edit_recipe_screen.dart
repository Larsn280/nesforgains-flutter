import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/models/recipe_data.dart';
import 'package:nes_for_gains/service/recipe_service.dart';

class EditRecipeScreen extends StatefulWidget {
  final Isar isar;
  final Recipe recipe; // The recipe to edit

  const EditRecipeScreen({super.key, required this.isar, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late RecipeService recipeService;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late TextEditingController _difficultyController;

  @override
  void initState() {
    super.initState();
    recipeService = RecipeService(widget.isar);

    // Initialize controllers with existing recipe values
    _titleController = TextEditingController(text: widget.recipe.title);
    _durationController =
        TextEditingController(text: widget.recipe.duration.toString());
    _difficultyController =
        TextEditingController(text: widget.recipe.difficulty);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create updated recipe object
        RecipeData updatedRecipe = RecipeData(
          title: _titleController.text,
          duration: int.parse(_durationController.text),
          difficulty: _difficultyController.text,
        );

        // Update the recipe in the database
        await recipeService.updateRecipe(updatedRecipe);

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update recipe')),
        );
      }
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
            const SizedBox(height: 32),
            const Text(
              'Edit Recipe',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Title', _titleController),
                  _buildTextField('Duration (mins)', _durationController,
                      isNumeric: true),
                  _buildTextField('Difficulty', _difficultyController),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveRecipe,
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 8.0),
                  AppConstants.buildElevatedButton(
                      context: context, path: '/recipeScreen', text: 'Cancel'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isNumeric && int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
