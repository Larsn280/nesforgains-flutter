import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class AddDishScreen extends StatefulWidget {
  final Isar isar;

  const AddDishScreen({super.key, required this.isar});

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  late NutritionService nutritionService;

  @override
  void initState() {
    super.initState();
    nutritionService = NutritionService(widget.isar);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _submitNewDish() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final nutritionData = NutritionData(
          dish: _nameController.text,
          calories: int.tryParse(_caloriesController.text) ?? 0,
          protein: int.tryParse(_proteinController.text) ?? 0,
          carbohydrates: int.tryParse(_carbsController.text) ?? 0,
          fat: int.tryParse(_fatController.text) ?? 0,
        );

        final response = await nutritionService.addDishItem(
            nutritionData, AuthProvider.of(context).id);

        if (response.checksuccess == true) {
          _nameController.clear();
          _caloriesController.clear();
          _proteinController.clear();
          _carbsController.clear();
          _fatController.clear();

          if (mounted) {
            Navigator.pop(context, '${response.message},green');
          }
        } else {
          _nameController.clear();
          _caloriesController.clear();
          _proteinController.clear();
          _carbsController.clear();
          _fatController.clear();

          if (mounted) {
            Navigator.pop(context, '${response.message},red');
          }
        }
      }
    } catch (e) {
      logger.e('Error submitting', error: e);
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
              image: AssetImage(AppConstants.backgroundimage),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              const Text(
                'Add dish',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.white)),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Dish name:',
                          hintText: 'Dish name',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a dish name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _caloriesController,
                        decoration: const InputDecoration(
                          labelText: 'Calories:',
                          hintText: 'Calories',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter calories';
                          }
                          final n = int.tryParse(value);
                          if (n == null || n < 0) {
                            return 'Please enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _proteinController,
                        decoration: const InputDecoration(
                          labelText: 'Protein:',
                          hintText: 'Protein',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter protein';
                          }
                          final n = int.tryParse(value);
                          if (n == null || n < 0) {
                            return 'Please enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _carbsController,
                        decoration: const InputDecoration(
                          labelText: 'Carbohydrates:',
                          hintText: 'Carbohydrates',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter carbohydrates';
                          }
                          final n = int.tryParse(value);
                          if (n == null || n < 0) {
                            return 'Please enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _fatController,
                        decoration: const InputDecoration(
                          labelText: 'Fat:',
                          hintText: 'Fat',
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter fat';
                          }
                          final n = int.tryParse(value);
                          if (n == null || n < 0) {
                            return 'Please enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              AppConstants.buildElevatedFunctionButton(
                  context: context,
                  onPressed: _submitNewDish,
                  text: 'Submit new dish'),
              AppConstants.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Go back'),
            ],
          ),
        ),
      ),
    );
  }
}
