import 'package:NESForGains/constants.dart';
import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final Isar isar;
  /* Ignorerar varningen */
  // ignore: use_super_parameters
  const ProfileScreen({Key? key, required this.isar}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _consumedController = TextEditingController();

  late NutritionService nutritionService;

  int calories = 0;
  int proteine = 0;
  int carbs = 0;
  int fat = 0;

  List<String> foodItems = [];

  @override
  void initState() {
    nutritionService = NutritionService(widget.isar);
    super.initState();
    fetchFoodItems();
  }

  void fetchFoodItems() async {
    List<String> fetchedFoodItems =
        await nutritionService.fetchDishItems(AuthProvider.of(context).id);
    setState(() {
      foodItems = fetchedFoodItems;
    });
  }

  @override
  void dispose() {
    _consumedController.dispose();
    super.dispose();
  }

  String? valueChoose;
  List listItem = ['First', 'Second', 'Third'];

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<AuthState>(context).username;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
              'Profile Screen',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text('Welcome $username!', style: const TextStyle(fontSize: 16.0)),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppConstants.primaryTextColor, width: 1.0),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  hint: const Text('Select Items: '),
                  dropdownColor: Colors.black,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 36,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: TextStyle(
                      color: AppConstants.primaryTextColor, fontSize: 22),
                  value: valueChoose,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue.toString();
                    });
                  },
                  items: listItem.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      NutritionData processedFoodList =
                          nutritionService.handleFoodSubmitted(
                              _consumedController.text.toString());
                      setState(() {
                        calories = processedFoodList.calories.toInt();
                        proteine = processedFoodList.protein.toInt();
                        carbs = processedFoodList.carbohydrates.toInt();
                        fat = processedFoodList.fat.toInt();
                      });
                    },
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Go to Home'),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text('Consumed Today: $calories Calories!'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text('Protein: ${proteine}g'),
                  Text('Carbs: ${carbs}g'),
                  Text('Fat: ${fat}g'),
                  Text('TEST: ${_consumedController.text}')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
