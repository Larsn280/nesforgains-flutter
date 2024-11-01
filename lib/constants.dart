import 'package:flutter/material.dart';

class AppConstants {
  static const String appbackgroundimage = 'assets/the-incredible-hulk.webp';
  static const Color primaryColor = Colors.green;
  static Color primaryTextColor = Colors.white.withOpacity(0.9);

  static const TextStyle headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 26.0,
    color: Colors.white,
  );
  static const TextStyle subheadingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: Colors.white,
  );

  static const ButtonStyle buttonTextColor = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
  );
}
