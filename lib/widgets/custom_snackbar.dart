import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class CustomSnackbar {
  static void showSnackBar({required String message}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Material(
          color: Colors.black45,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black45,
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor:
            Colors.transparent, // Make the default background transparent
      ),
    );
  }
}
