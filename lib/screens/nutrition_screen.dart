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
  List<String> _allDishes = ['Pizza', 'Pasta', 'Salad', 'Soup', 'Sandwich'];
  List<String> _filteredDishes = [];
  String? _selectedDish;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDishes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDishes);
    _searchController.dispose();
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
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Dish',
                      hintText: 'Enter dish',
                    ),
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
                                color: Colors.grey[200],
                                child: Text(dish),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
