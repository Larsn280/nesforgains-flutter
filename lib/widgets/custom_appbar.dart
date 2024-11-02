import 'package:flutter/material.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // This is required to satisfy PreferredSizeWidget

  const CustomAppbar({super.key})
      : preferredSize =
            const Size.fromHeight(60.0); // Adjust the height as needed

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'NESForGains',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.black45,
      shape: Border.all(color: Colors.white, width: 1.0),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.fitness_center,
            color: Colors.white,
          ),
          onPressed: () {
            // Define action when this button is pressed
            CustomSnackbar.showSnackBar(
                message: 'Workout feature coming soon!');
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {
            // Define action for notifications
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          // Open a drawer or menu
          Scaffold.of(context).openDrawer();
        },
      ),
      elevation: 4.0, // Adds a shadow for depth
    );
  }
}
