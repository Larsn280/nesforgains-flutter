import 'package:nes_for_gains/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.backgroundimage),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'NESForGains!',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 20.0),
            const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Welcome to NESForGains!',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Text(
                      '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.''',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            AppConstants.buildElevatedButton(
                context: context,
                path: '/nutritionScreen',
                text: 'Go to Nutrition'),
            AppConstants.buildElevatedButton(
                context: context,
                path: '/trainingcalculatorScreen',
                text: 'Go to Training'),
            AppConstants.buildElevatedButton(
                context: context,
                path: '/addworkoutScreen',
                text: 'Go to TrainingLog'),
            AppConstants.buildElevatedButton(
                context: context,
                path: '/addrecipeScreen',
                text: 'Go to Recipes'),
            AppConstants.buildElevatedFunctionButton(
                context: context,
                onPressed: () {
                  AuthProvider.of(context).logout();
                },
                text: 'Logout'),
          ],
        ),
      ),
    );
  }
}
