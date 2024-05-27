import 'dart:ffi';

import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/models/response_data.dart';
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
  final _formKey = GlobalKey<FormState>();
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
  String message = 'Choose a dish or add a new one!';
  Color _textmessageColor = Colors.yellowAccent;

  late NutritionService nutritionService;

  void _submitNutritionData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final nutritionData = NutritionData(
        dish: _nameController.text,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        protein: int.tryParse(_proteinController.text) ?? 0,
        carbohydrates: int.tryParse(_carbsController.text) ?? 0,
        fat: int.tryParse(_fatController.text) ?? 0,
      );

      final response = await nutritionService.addfoodItem(
          nutritionData, AuthProvider.of(context).id);

      if (response.checksuccess == true) {
        _fetchFoodItems();
        setState(() {
          display = '';
          message = response.message;
          _textmessageColor = Colors.greenAccent;
        });

        _nameController.clear();
        _caloriesController.clear();
        _proteinController.clear();
        _carbsController.clear();
        _fatController.clear();
      } else {
        _fetchFoodItems();
        setState(() {
          display = '';
          message = response.message;
          _textmessageColor = Colors.redAccent;
        });

        _nameController.clear();
        _caloriesController.clear();
        _proteinController.clear();
        _carbsController.clear();
        _fatController.clear();
      }
    }
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
    if (response.checksuccess == true) {
      setState(() {
        message = response.message;
        _textmessageColor = Colors.greenAccent;
      });
    } else {
      setState(() {
        message = response.message;
        _textmessageColor = Colors.redAccent;
      });
    }
    _searchController.clear();
    _fetchDailyIntake();
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
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.backgroundimage),
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
                          padding: const EdgeInsets.all(8.0),
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
                          height: 15.0,
                        ),
                        message.isNotEmpty
                            ? Text(
                                message,
                                style: TextStyle(color: _textmessageColor),
                              )
                            : Container(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Dish',
                            hintText: 'Enter dish',
                          ),
                          // onSubmitted: (value) => {
                          //   _postDailyDish(value),
                          // },
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
                                      padding: const EdgeInsets.all(10.0),
                                      color:
                                          const Color.fromARGB(255, 17, 17, 17),
                                      child: Text(dish),
                                    ),
                                  );
                                }).toList(),
                              ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _postDailyDish(_searchController.text);
                          },
                          child: const Text('Submit dish'),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                display = 'true';
                              });
                            },
                            child: const Text('Add new dish')),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/viewdishesScreen');
                            },
                            child: const Text('Go to Dishlist')),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                            },
                            child: const Text('Go to back')),
                      ],
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                                _submitNutritionData();
                              },
                              child: const Text('Submit new dish')),
                          const SizedBox(
                            height: 8.0,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  display = '';
                                });
                              },
                              child: const Text('Go back')),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
