import 'package:flutter/material.dart';

class CustomCards {
  static Widget buildFormCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Card(
        color: Colors.black54,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
