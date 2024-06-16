import 'package:NESForGains/screens/nutrition_screen.dart';
import 'package:NESForGains/screens/viewdishes_screen.dart';
import 'package:NESForGains/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
// import 'package:myflutterapp/widgets/background_container.dart';
import 'constants.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'package:NESForGains/screens/training_screen.dart';

class App extends StatelessWidget {
  final Isar isar;
  const App({super.key, required this.isar});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child: MaterialApp(
        title: 'NESForGains',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppConstants.primaryTextColor,
              selectionColor: AppConstants.primaryTextColor,
              selectionHandleColor: AppConstants.primaryTextColor),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: AppConstants.primaryTextColor),
            labelStyle: TextStyle(color: AppConstants.primaryTextColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppConstants.primaryTextColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppConstants.primaryTextColor),
            ),
          ),
          textTheme: TextTheme(
            bodySmall: TextStyle(color: AppConstants.primaryTextColor),
            bodyMedium: TextStyle(color: AppConstants.primaryTextColor),
            bodyLarge: TextStyle(color: AppConstants.primaryTextColor),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final isLoggedIn =
                Provider.of<AuthState>(context).checkLoginStatus();
            return isLoggedIn ? const HomeScreen() : LoginScreen(isar: isar);
          },
          '/homeScreen': (context) => const HomeScreen(),
          '/registerScreen': (context) => RegisterScreen(isar: isar),
          '/profileScreen': (context) => ProfileScreen(isar: isar),
          '/nutritionScreen': (context) => NutritionScreen(isar: isar),
          '/viewdishesScreen': (context) => ViewDishesScreen(isar: isar),
          '/trainingScreen': (context) => TrainingScreen(isar: isar),
        },
      ),
    );
  }
}
