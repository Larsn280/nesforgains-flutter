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
        for (var dish in response) {
          alldishes.add(dish);
        }
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
            Text('Dishlist'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Calories',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Protein',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Carbohydrates',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Fat',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(dish.dish.toString()),
                                        Text(dish.calories.toString()),
                                        Text(dish.protein.toString()),
                                        Text(dish.carbohydrates.toString()),
                                        Text(dish.fat.toString()),
                                      ],
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
