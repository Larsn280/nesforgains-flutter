import 'package:NESForGains/models/nutrition_data.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:NESForGains/service/nutrition_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  /* Ignorerar varningen */
  // ignore: use_super_parameters
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _consumedController = TextEditingController();
  FoodService foodService = FoodService();

  int calories = 0;
  int proteine = 0;
  int carbs = 0;
  int fat = 0;

  @override
  void dispose() {
    _consumedController.dispose();
    super.dispose();
  }

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
            image: AssetImage('assets/moon-2048727_1280.jpg'),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter food'),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _consumedController,
                    decoration: const InputDecoration(
                      // labelText: 'Consumed',
                      hintText: 'Enter Consumed',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      NutritionData processedFoodList =
                          foodService.handleFoodSubmitted(
                              _consumedController.text.toString());
                      setState(() {
                        calories = processedFoodList.calories.toInt();
                        proteine = processedFoodList.protein.toInt();
                        carbs = processedFoodList.carbohydrates.toInt();
                        fat = processedFoodList.fat.toInt();
                      });

                      // print(foodService
                      //     .handleFoodSubmitted(
                      //         _consumedController.text.toString())
                      //     .calories);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
