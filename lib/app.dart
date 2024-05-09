import 'package:flutter/material.dart';
// import 'package:myflutterapp/widgets/background_container.dart';
import 'constants.dart';
import 'screens/home_screen.dart';
import 'service/myapipage.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NESForGains',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppConstants.primaryTextColor,
            selectionColor: AppConstants.primaryTextColor,
            selectionHandleColor: AppConstants.primaryTextColor),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppConstants.primaryTextColor),
          labelStyle: TextStyle(color: AppConstants.primaryTextColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.primaryTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.primaryTextColor),
          ),
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: AppConstants.primaryTextColor),
          bodyMedium: TextStyle(color: AppConstants.primaryTextColor),
          bodyLarge: TextStyle(color: AppConstants.primaryTextColor),
        ),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/myApiPage': (context) => MyApiPage(),
        '/loginPage': (context) => const LoginPage(),
        '/registerPage': (context) => const RegisterPage(),
      },
    );
  }
}
