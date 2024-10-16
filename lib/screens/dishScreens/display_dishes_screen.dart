import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/screens/dishScreens/edit_dish_screen.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/logger.dart';

class DisplayDishesScreen extends StatefulWidget {
  final Isar isar;

  const DisplayDishesScreen({super.key, required this.isar});

  @override
  State<DisplayDishesScreen> createState() => _DisplayDishesScreenState();
}

class _DisplayDishesScreenState extends State<DisplayDishesScreen> {
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
      logger.e('Error fetching dishes', error: e);
      return [];
    }
  }

  void _handleDeleteDish(String name, int userId) async {
    try {
      await nutritionService.deleteDish(name, userId);
      // Triggar en rebuild av widget trädet.
      setState(() {});
    } catch (e) {
      logger.e('Error deleting dish', error: e);
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
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Dishlist',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<NutritionData>>(
                  future: _fetchAllDishItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildDishList([], 'Indicator');
                    } else if (snapshot.hasError) {
                      return _buildDishList([], 'Error loading dishes');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildDishList([], 'No dishes available');
                    }

                    final dishes = snapshot.data!;
                    return _buildDishList(dishes, '');
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              AppConstants.buildElevatedButton(
                  context: context, path: '/nutritionScreen', text: 'Go back'),
            ],
          ),
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

  Widget _buildDishList(List<NutritionData> dishes, String message) {
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
            child: dishes.isNotEmpty
                ? ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return _buildDishRow(dish);
                    },
                  )
                : Center(
                    child: message.startsWith('Indicator')
                        ? CircularProgressIndicator(
                            color: AppConstants.primaryTextColor,
                          )
                        : Text(message),
                  ),
          )
        ],
      ),
    );
  }
}
