import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/screens/edit_dish_screen.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class ViewDishesScreen extends StatefulWidget {
  final Isar isar;

  const ViewDishesScreen({super.key, required this.isar});

  @override
  State<ViewDishesScreen> createState() => _ViewDishesScreenState();
}

class _ViewDishesScreenState extends State<ViewDishesScreen> {
  static const double sizedBoxHeight = 18.0;
  late NutritionService nutritionService;

  @override
  void initState() {
    super.initState();
    nutritionService = NutritionService(widget.isar);
  }

  Future<List<NutritionData>> _fetchAllDishItems() async {
    try {
      final response =
          await nutritionService.getAllDishesById(AuthProvider.of(context).id);

      return response ?? [];
    } catch (e) {
      print('Error fetching dishes: $e');
      return [];
    }
  }

  void _handleDeleteDish(String name, int userId) async {
    try {
      await nutritionService.deleteDish(name, userId);
      // Triggar en rebuild av widget trädet.
      setState(() {});
    } catch (e) {
      print('Error deleting dish: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.backgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Dishlist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<NutritionData>>(
                future: _fetchAllDishItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading dishes'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No dishes available'));
                  }

                  final dishes = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: AppConstants.primaryTextColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDishHeader(),
                        const Divider(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: dishes.length,
                            itemBuilder: (context, index) {
                              final dish = dishes[index];
                              return _buildDishRow(dish);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildDishColumnHeader('Name', 0.3),
          _buildDishColumnHeader('Calories', 0.15),
          _buildDishColumnHeader('Protein', 0.15),
          _buildDishColumnHeader('Carbohydrates', 0.15),
          _buildDishColumnHeader('Fat', 0.15),
        ],
      ),
    );
  }

  Widget _buildDishColumnHeader(String title, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDishRow(NutritionData dish) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildDishColumn(dish.dish.toString(), 0.3),
            _buildDishColumn(dish.calories.toString(), 0.15),
            _buildDishColumn(dish.protein.toString(), 0.15),
            _buildDishColumn(dish.carbohydrates.toString(), 0.15),
            _buildDishColumn(dish.fat.toString(), 0.15),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.greenAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDishScreen(
                      isar: widget.isar,
                      nutritionData: dish,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                _handleDeleteDish(dish.dish!, AuthProvider.of(context).id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishColumn(String text, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(text),
    );
  }
}
