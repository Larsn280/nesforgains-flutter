import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/dish_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';

class EditDishScreen extends StatefulWidget {
  final Isar isar;
  final NutritionData nutritionData;

  const EditDishScreen(
      {super.key, required this.isar, required this.nutritionData});

  @override
  State<EditDishScreen> createState() => _EditDishScreenState();
}

class _EditDishScreenState extends State<EditDishScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _calorieController;
  late TextEditingController _proteinController;
  late TextEditingController _carbController;
  late TextEditingController _fatController;
  String olddishname = '';

  late DishService nutritionService;
  late NutritionData newNutritionData;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data
    _nameController = TextEditingController(text: widget.nutritionData.dish);
    setState(() {
      olddishname = widget.nutritionData.dish.toString();
    });
    _calorieController =
        TextEditingController(text: widget.nutritionData.calories.toString());
    _proteinController =
        TextEditingController(text: widget.nutritionData.protein.toString());
    _carbController = TextEditingController(
        text: widget.nutritionData.carbohydrates.toString());
    _fatController =
        TextEditingController(text: widget.nutritionData.fat.toString());

    nutritionService = DishService(widget.isar);
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _nameController.dispose();
    _calorieController.dispose();
    _proteinController.dispose();
    _carbController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _editDish() async {
    try {
      if (_formKey.currentState!.validate()) {
        newNutritionData = NutritionData(
            dish: _nameController.text,
            calories: int.tryParse(_calorieController.text) ?? 0,
            protein: int.tryParse(_proteinController.text) ?? 0,
            carbohydrates: int.tryParse(_carbController.text) ?? 0,
            fat: int.tryParse(_fatController.text) ?? 0);
        final response = await nutritionService.editDish(
            newNutritionData, olddishname, AuthProvider.of(context).id);

        if (response.checksuccess == true) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
        _showSnackBar(response.message);
      }
    } catch (e) {
      logger.e('Error editing', error: e);
      _showSnackBar(
          'An error occurred while editing the dish. Please try again.');
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
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.appbackgroundimage),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              CustomCards.buildFormCard(
                context: context,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Edit Dish',
                        style: AppConstants.headingStyle,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _calorieController,
                        decoration:
                            const InputDecoration(labelText: 'Calories'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of calories';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _proteinController,
                        decoration: const InputDecoration(labelText: 'Protein'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of protein';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _carbController,
                        decoration:
                            const InputDecoration(labelText: 'Carbohydrates'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of carbohydrates';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _fatController,
                        decoration: const InputDecoration(labelText: 'Fat'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of fat';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              CustomButtons.buildElevatedFunctionButton(
                  context: context, onPressed: _editDish, text: 'Save'),
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
}
