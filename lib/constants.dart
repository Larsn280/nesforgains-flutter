import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryColor = Colors.green;
  static Color primaryTextColor = Colors.white.withOpacity(0.9);
  static const String backgroundimage = 'assets/the-incredible-hulk.webp';

  static const TextStyle headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 26.0,
    // color: Colors.black87,
    color: Colors.white,
  );
  static const TextStyle subheadingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: Colors.green,
  );

  static const ButtonStyle buttonTextColor = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
  );

  static Widget buildElevatedButton(
      {required BuildContext context,
      required String path,
      required String text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, path);
        },
        style: buttonTextColor,
        child: Text(text),
      ),
    );
  }

  static Widget buildElevatedFunctionButton({
    required BuildContext context,
    required Function() onPressed,
    required String text,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.50,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: buttonTextColor,
        child: Text(text),
      ),
    );
  }

  static Widget buildFormCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Card(
        color: Colors.black54,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ));
  }

  static Widget buildListCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Card(
      color: Colors.black54,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }
}
