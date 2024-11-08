import 'package:nes_for_gains/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';

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
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.appbackgroundimage),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(title: 'NESForGains!'),
              const SizedBox(height: 40.0),
              Card(
                color: Colors.black54,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.white, width: 1.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0),
                      Text('Welcome to NESForGains!',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text(
                        'NESForGains is your personal companion on the journey to better health and fitness. '
                        'Track your workouts, monitor your nutrition, and discover new recipes—all in one place. '
                        'With NESForGains, you can effortlessly log your progress, helping you stay focused and motivated every step of the way.\n\n'
                        'Add your latest workout to build strength over time, keep tabs on your meals to balance your nutrition, '
                        'or explore new recipes to fuel your goals. NESForGains makes it easy to see your achievements and plan for tomorrow’s gains.\n\n'
                        'Let’s keep leveling up—one rep, one meal, and one day at a time!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pushNamed(context, '/addworkoutScreen');
                  },
                  text: 'Go to Workouts'),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pushNamed(context, '/addrecipeScreen');
                  },
                  text: 'Go to Recipes'),

              // AppConstants.buildElevatedButton(
              //     context: context,
              //     path: '/trainingcalculatorScreen',
              //     text: 'Go to Calculator'),

              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    AuthProvider.of(context).logout();
                  },
                  text: 'Logout'),
            ],
          ),
        ),
      ),
    );
  }
}
