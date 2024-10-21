import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/nutrition_service.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/constants.dart';

class DisplayDailyNutritionScreen extends StatefulWidget {
  final Isar isar;

  const DisplayDailyNutritionScreen({super.key, required this.isar});

  @override
  State<DisplayDailyNutritionScreen> createState() =>
      _DisplayDailyNutritionScreenState();
}

class _DisplayDailyNutritionScreenState
    extends State<DisplayDailyNutritionScreen> {
  static const double sizedBoxHeight = 18.0;
  late NutritionService nutritionService;

  @override
  void initState() {
    super.initState();
    nutritionService = NutritionService(widget.isar);
  }

  Future<List<DailyNutrition>> _fetchDailyNutritionItems() async {
    try {
      final response = await nutritionService
          .getNutritionListByUserId(AuthProvider.of(context).id);
      return response;
    } catch (e) {
      logger.e('Error fetching daily nutrition', error: e);
      return [];
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
                'Daily Nutrition List',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<DailyNutrition>>(
                  future: _fetchDailyNutritionItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildDailyNutritionList([], 'Indicator');
                    } else if (snapshot.hasError) {
                      return _buildDailyNutritionList(
                          [], 'Error loading daily nutrition');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildDailyNutritionList(
                          [], 'No daily nutrition available');
                    }

                    final dailyNutrition = snapshot.data!;
                    return _buildDailyNutritionList(dailyNutrition, '');
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              AppConstants.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Go back'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyNutritionHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildNutritionColumnHeader('Date', 0.3),
          _buildNutritionColumnHeader('Calories', 0.15),
          _buildNutritionColumnHeader('Protein', 0.15),
          _buildNutritionColumnHeader('Carbohydrates', 0.15),
          _buildNutritionColumnHeader('Fat', 0.15),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        ],
      ),
    );
  }

  Widget _buildNutritionColumnHeader(String title, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDailyNutritionRow(DailyNutrition dailyNutrition) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildNutritionColumn(
                DateFormat('y-MMM-d').format(dailyNutrition.date!).toString(),
                0.3),
            _buildNutritionColumn(dailyNutrition.calories.toString(), 0.15),
            _buildNutritionColumn(dailyNutrition.protein.toString(), 0.15),
            _buildNutritionColumn(
                dailyNutrition.carbohydrates.toString(), 0.15),
            _buildNutritionColumn(dailyNutrition.fat.toString(), 0.15),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionColumn(String text, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(text),
    );
  }

  Widget _buildDailyNutritionList(
      List<DailyNutrition> dailyNutrition, String message) {
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
          _buildDailyNutritionHeader(),
          const Divider(),
          Expanded(
            child: dailyNutrition.isNotEmpty
                ? ListView.builder(
                    itemCount: dailyNutrition.length,
                    itemBuilder: (context, index) {
                      final item = dailyNutrition[index];
                      return _buildDailyNutritionRow(item);
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
