import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
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
      print('Error submitting: $e');
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Add new dish',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Dish name:',
                    hintText: 'Dish name',
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
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      _submitNewDish();
                    },
                    child: const Text('Submit new dish')),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/nutritionScreen');
                    },
                    child: const Text('Go back')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
