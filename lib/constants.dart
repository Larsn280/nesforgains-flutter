import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryColor = Colors.green;
  static Color primaryTextColor = Colors.white.withOpacity(0.9);
  static const String backgroundimage = 'assets/the-incredible-hulk.webp';

  static Widget buildElevatedButton(
      {required BuildContext context,
      required String path,
      required String text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, path);
        },
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
      width: MediaQuery.of(context).size.width * 0.25,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(text),
      ),
    );
  }
}
