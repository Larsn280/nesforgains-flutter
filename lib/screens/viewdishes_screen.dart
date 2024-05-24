import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class ViewDishesScreen extends StatefulWidget {
  final Isar isar;

  const ViewDishesScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<ViewDishesScreen> createState() => _ViewDishesScreenState();
}

class _ViewDishesScreenState extends State<ViewDishesScreen> {
  late NutritionService nutritionService;
  final List<NutritionData> alldishes = [];

  @override
  void initState() {
    super.initState();
    nutritionService = NutritionService(widget.isar);
    fetchAllDishItems();
  }

  void fetchAllDishItems() async {
    try {
      final response =
          await nutritionService.getAllDishesById(AuthProvider.of(context).id);
      if (response != null) {
        setState(() {
          alldishes.addAll(response);
        });
      }
    } catch (e) {
      throw Exception('message: $e');
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
              image: AssetImage('assets/moon-2048727_1280.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dishlist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.0, color: AppConstants.primaryTextColor),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('Calories',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('Protein',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text('Carbohydrates',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('Fat',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SingleChildScrollView(
                      child: Container(
                        height: 400,
                        child: alldishes.isNotEmpty
                            ? ListView.builder(
                                itemCount: alldishes.length,
                                itemBuilder: (context, index) {
                                  final dish = alldishes[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Text(dish.dish.toString()),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child:
                                                Text(dish.calories.toString()),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child:
                                                Text(dish.protein.toString()),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Text(
                                                dish.carbohydrates.toString()),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Text(dish.fat.toString()),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.greenAccent,
                                            ),
                                            onPressed: () {
                                              // Handle edit action
                                              // For example, navigate to a new screen for editing the item
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         EditDishScreen(
                                              //             dish: dish),
                                              //   ),
                                              // );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {
                                              // Handle delete action
                                              setState(() {
                                                alldishes.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('Go back')),
          ],
        ),
      ),
    );
  }
}
