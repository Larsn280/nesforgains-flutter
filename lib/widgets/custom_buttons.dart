import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';

class CustomButtons {
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
        style: AppConstants.buttonTextColor,
        child: Text(text),
      ),
    );
  }
}
