import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isar/isar.dart';

class EditDishScreen extends StatefulWidget {
  final Isar isar;
  final NutritionData nutritionData;

  const EditDishScreen(
      {Key? key, required this.isar, required this.nutritionData})
      : super(key: key);

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

  late NutritionService nutritionService;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data
    _nameController = TextEditingController(text: widget.nutritionData.dish);
    _calorieController =
        TextEditingController(text: widget.nutritionData.calories.toString());
    _proteinController =
        TextEditingController(text: widget.nutritionData.protein.toString());
    _carbController = TextEditingController(
        text: widget.nutritionData.carbohydrates.toString());
    _fatController =
        TextEditingController(text: widget.nutritionData.fat.toString());

    nutritionService = NutritionService(widget.isar);
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

  void _updatedishData(NutritionData newnutritionData) async {
    try {
      final respose = await nutritionService.editDish(
          newnutritionData, AuthProvider.of(context).id);
      print(respose.checksuccess);
    } catch (e) {
      throw Exception('Something went wrong');
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _calorieController,
                decoration: InputDecoration(labelText: 'Calories'),
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
                decoration: InputDecoration(labelText: 'Protein'),
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
                decoration: InputDecoration(labelText: 'Carbohydrates'),
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
                decoration: InputDecoration(labelText: 'Fat'),
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
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newnutritionData = NutritionData(
                          dish: _nameController.text,
                          calories: int.parse(_calorieController.text),
                          protein: int.parse(_proteinController.text),
                          carbohydrates: int.parse(_carbController.text),
                          fat: int.parse(_fatController.text));
                      _updatedishData(newnutritionData);
                    }
                  },
                  child: const Text('Save')),
              const SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/viewdishesScreen');
                },
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
