import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';

class NutritionScreen extends StatefulWidget {
  final Isar isar;

  const NutritionScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  // List<String> _allDishes = ['Pizza', 'Pasta', 'Salad', 'Soup', 'Sandwich'];
  List<String> _allDishes = [];
  List<String> _filteredDishes = [];
  String? _selectedDish;
  String display = '';
  int calories = 0;
  int proteine = 0;
  int carbohydrates = 0;
  int fat = 0;

  late NutritionService nutritionService;

  void _submitNutritionData() async {
    final nutritionData = NutritionData(
      dish: _nameController.text,
      calories: int.tryParse(_caloriesController.text) ?? 0,
      protein: int.tryParse(_proteinController.text) ?? 0,
      carbohydrates: int.tryParse(_carbsController.text) ?? 0,
      fat: int.tryParse(_fatController.text) ?? 0,
    );

    final response = await nutritionService.addfoodItem(
        nutritionData, AuthProvider.of(context).id);
    print(response);
  }

  void _fetchFoodItems() async {
    final dishList =
        await nutritionService.fetchFoodItems(AuthProvider.of(context).id);
    setState(() {
      _allDishes = dishList;
    });
  }

  void _fetchDailyIntake() async {
    final intake = await nutritionService
        .getDailyNutritionById(AuthProvider.of(context).id);
    print(intake.calories);
    setState(() {
      calories = intake.calories;
      proteine = intake.protein;
      carbohydrates = intake.carbohydrates;
      fat = intake.fat;
    });
  }

  void _postDailyDish(dish) async {
    final response =
        await nutritionService.postDailyDish(dish, AuthProvider.of(context).id);
    print(response);
  }

  @override
  void initState() {
    super.initState();
    nutritionService = NutritionService(widget.isar);
    _fetchFoodItems();
    _fetchDailyIntake();
    _searchController.addListener(_filterDishes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDishes);
    _searchController.dispose();
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _filterDishes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isNotEmpty) {
        _filteredDishes = _allDishes;
        _filteredDishes = _allDishes.where((dish) {
          return dish.toLowerCase().startsWith(query);
        }).toList();
      } else {
        _filteredDishes.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/moon-2048727_1280.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: display.isEmpty
                  ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0,
                                  color: AppConstants.primaryTextColor)),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Total calories today: $calories'),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Protein: $proteine'),
                                  Text('Carbohydrates: $carbohydrates'),
                                  Text('Fat: $fat'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Dish',
                            hintText: 'Enter dish',
                          ),
                          onSubmitted: (value) => {
                            _postDailyDish(value),
                          },
                        ),
                        _filteredDishes.isEmpty
                            ? Container() // No dishes to show
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _filteredDishes.map((String dish) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedDish = dish;
                                        _searchController.text = dish;
                                        _filteredDishes.clear();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      color:
                                          const Color.fromARGB(255, 17, 17, 17),
                                      child: Text(dish),
                                    ),
                                  );
                                }).toList(),
                              ),
                        SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                display = 'true';
                              });
                            },
                            child: Text('Add new dish')),
                      ],
                    )
                  : Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Dish name:',
                            hintText: 'Dish name',
                          ),
                        ),
                        TextField(
                          controller: _caloriesController,
                          decoration: const InputDecoration(
                            labelText: 'Calories:',
                            hintText: 'Calories',
                          ),
                        ),
                        TextField(
                          controller: _proteinController,
                          decoration: const InputDecoration(
                            labelText: 'Protein:',
                            hintText: 'Protein',
                          ),
                        ),
                        TextField(
                          controller: _carbsController,
                          decoration: const InputDecoration(
                            labelText: 'Carbohydrates:',
                            hintText: 'Carbohydrates',
                          ),
                        ),
                        TextField(
                          controller: _fatController,
                          decoration: const InputDecoration(
                            labelText: 'Fat:',
                            hintText: 'Fat',
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _submitNutritionData();
                            },
                            child: Text('Submit new food')),
                        SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                display = '';
                              });
                            },
                            child: Text('Go back')),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
