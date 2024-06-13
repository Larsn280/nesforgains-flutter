import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';

class NutritionScreen extends StatefulWidget {
  final Isar isar;

  /* Ignorerar varningen */
  // ignore: use_super_parameters
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
  List<String> _allDishes = [];
  List<String> _filteredDishes = [];
  String display = '';
  int calories = 0;
  int proteine = 0;
  int carbohydrates = 0;
  int fat = 0;
  String message = 'Choose a dish or add a new one!';
  Color _textmessageColor = Colors.yellowAccent;

  late NutritionService nutritionService;

  @override
  void initState() {
    super.initState();
    nutritionService = NutritionService(widget.isar);
    _fetchDishItems();
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

  void _fetchDishItems() async {
    try {
      final dishList =
          await nutritionService.fetchDishItems(AuthProvider.of(context).id);
      setState(() {
        _allDishes = dishList;
      });
    } catch (e) {
      print('Error fetching: $e');
    }
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
          _fetchDishItems();
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
          _fetchDishItems();
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
    } catch (e) {
      print('Error submitting: $e');
    }
  }

  void _fetchDailyIntake() async {
    try {
      final intake = await nutritionService
          .getDailyNutritionById(AuthProvider.of(context).id);
      setState(() {
        calories = intake.calories;
        proteine = intake.protein;
        carbohydrates = intake.carbohydrates;
        fat = intake.fat;
      });
    } catch (e) {
      print('Error fetching intake: $e');
    }
  }

  void _postDailyDish(dish) async {
    try {
      final response = await nutritionService.postDailyDish(
          dish, AuthProvider.of(context).id);
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
    } catch (e) {
      print('Error posting: $e');
    }
  }

  void _putDailyDish(dish) async {
    try {
      final response = await nutritionService.putDailyDish(
          dish, AuthProvider.of(context).id);
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
    } catch (e) {
      print('Error posting: $e');
    }
  }

  void _filterDishes() {
    try {
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
    } catch (e) {
      print('Error filtering $e');
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: display.isEmpty
                      ? Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(8.0),
                              // decoration: BoxDecoration(
                              //     border: Border.all(
                              //         width: 1.0,
                              //         color: AppConstants.primaryTextColor)),
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total calories today: $calories g',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Protein: $proteine g',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      Text(
                                        'Carbohydrates: $carbohydrates g',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                      Text(
                                        'Fat: $fat g',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 18.0,
                            ),
                            message.isNotEmpty
                                ? Text(
                                    message,
                                    style: TextStyle(color: _textmessageColor),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                labelText: 'Dish',
                                hintText: 'Enter dish',
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 45.0,
                                  height: 45.0,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      // Define the action to be taken when the button is pressed
                                      _postDailyDish(_searchController.text);
                                    },
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.green,
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        display = 'true';
                                      });
                                    },
                                    child: const Text('Add new dish')),
                                SizedBox(
                                  width: 45.0,
                                  height: 45.0,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      // Define the action to be taken when the button is pressed
                                      _putDailyDish(_searchController.text);
                                    },
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    child: const Icon(Icons.remove),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/viewdishesScreen');
                                },
                                child: const Text('Go to Dishlist')),
                            const SizedBox(
                              height: 8.0,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: const Text('Go back')),
                          ],
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Add new dish',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
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
            if (_filteredDishes.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                top: 302, // Adjust this value based on your layout
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  color: Colors.white.withOpacity(0.9),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _filteredDishes.map((String dish) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.text = dish;
                              _filteredDishes.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(255, 17, 17, 17),
                            child: Text(dish,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
