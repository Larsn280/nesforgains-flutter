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
  final String randomGifUrl = "https://i.gifer.com/Chc3.gif";
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = AuthProvider.of(context).username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConstants.appbackgroundimage),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CustomAppbar(title: 'NESForGains!'),
                const SizedBox(
                  height: 12.0,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Card(
                      color: Colors.black54,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.white, width: 1.0),
                      ),
                      child: Image.network(
                        randomGifUrl,
                        fit: BoxFit.contain, // Adjust to fit the container
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Text('Failed to load GIF'),
                      ),
                    ),
                    const Positioned(
                      bottom: 10.0,
                      child: Text(
                        'Benchpress!!!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28.0),
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
                      AuthProvider.of(context).logout();
                    },
                    text: 'Logout'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to Terms of Service page
                      },
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(' | ', style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () {
                        // Navigate to Privacy Policy page
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
