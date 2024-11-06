import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/models/recipe_data.dart';
import 'package:nes_for_gains/service/recipe_service.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

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
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _difficultyController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stagesController;

  @override
  void initState() {
    super.initState();
    recipeService = RecipeService(widget.isar);
    // Initialize controllers with existing recipe values
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController =
        TextEditingController(text: widget.recipe.description);
    _durationController =
        TextEditingController(text: widget.recipe.duration.toString());
    _difficultyController =
        TextEditingController(text: widget.recipe.difficulty);
    _ingredientsController = TextEditingController();
    _stagesController = TextEditingController();
    _sortIsarLinks(widget.recipe);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  void _sortIsarLinks(Recipe recipe) {
    final ingredients = recipe.ingredients.map((i) => i.name).toList();
    final stages = recipe.stage.map((i) => i.instruction).toList();

    StringBuffer allIngredientsBuffer = StringBuffer();
    StringBuffer allStagesBuffer = StringBuffer();

    allIngredientsBuffer.writeAll(ingredients, ', ');
    allStagesBuffer.writeAll(stages, ', ');

    _ingredientsController.text = allIngredientsBuffer.toString();
    _stagesController.text = allStagesBuffer.toString();
  }

  //TODO och Service
  void _editRecipe() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create updated recipe object
        RecipeData updatedRecipe = RecipeData(
          title: _titleController.text,
          description: '',
          duration: int.parse(_durationController.text),
          difficulty: _difficultyController.text,
          ingredients: '',
          stage: '',
        );

        // Update the recipe in the database
        final response = await recipeService.updateRecipe(updatedRecipe);

        if (response.checksuccess == true) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
        CustomSnackbar.showSnackBar(message: response.message);
      } catch (e) {
        CustomSnackbar.showSnackBar(
            message:
                'An error occurred while editing the recipe. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.appbackgroundimage),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(
                title: 'Edit Recipe',
              ),
              const SizedBox(height: 40),
              CustomCards.buildFormCard(
                context: context,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      _buildTextFormField(
                          controller: _titleController,
                          labelText: 'Title',
                          validatorMessage: 'Please enter title'),
                      _buildTextFormField(
                          controller: _descriptionController,
                          labelText: 'Description',
                          validatorMessage: 'Please enter description'),
                      _buildTextFormField(
                        controller: _durationController,
                        labelText: 'Duration (mins)',
                        validatorMessage: 'Please enter duration',
                        isNumeric: true,
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextFormField(
                          controller: _difficultyController,
                          labelText: 'Difficulty',
                          validatorMessage: 'Please enter difficulty'),
                      _buildTextFormField(
                          controller: _ingredientsController,
                          labelText: 'Ingredients (comma separated)',
                          validatorMessage:
                              'Please enter atleast one ingredient'),
                      _buildTextFormField(
                          controller: _stagesController,
                          labelText: 'Steps (period separated)',
                          validatorMessage: 'Please enter stages'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              CustomButtons.buildElevatedFunctionButton(
                  context: context, onPressed: _editRecipe, text: 'Save'),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancle'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    bool isNumeric = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.black54,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        } else if (isNumeric && int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
