import 'package:flutter/material.dart';

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
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor:
              WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.grey; // Color when pressed
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey;
            }
            return Colors.black45;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Border radius
              side: const BorderSide(
                color: Colors.white, // Border color
                width: 1.0, // Border width
              ),
            ),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  static const TextStyle popupMenuItemStyle = TextStyle(
      color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold);

  static Widget popupMenuButton(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Set the font size to scale with screen width (adjust the multiplier as needed)
    double fontSize = screenWidth * 0.028; // For example, 5% of screen width

    return PopupMenuButton<String>(
      onSelected: (String route) {
        Navigator.pushNamed(context, route);
      },
      itemBuilder: (BuildContext context) => [
        buildPopupMenuItemCard(
          context: context,
          value: '/nutritionScreen',
          name: 'Nutrition',
          icon: Icons.food_bank,
        ),
        buildPopupMenuItemCard(
            context: context,
            value: '/addworkoutScreen',
            name: 'Workout',
            icon: Icons.fitness_center),
        buildPopupMenuItemCard(
            context: context,
            value: '/addrecipeScreen',
            name: 'Recipes',
            icon: Icons.book_online),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(0),
      color: Colors.black87, // Background color of popup menu
      elevation: 8,
      icon: Row(
        children: [
          const Icon(
            Icons.more_vert,
            color: Colors.white, // Change icon color
          ),
          Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  static PopupMenuEntry<String> buildPopupMenuItemCard({
    required BuildContext context,
    required String value,
    required String name,
    required IconData icon,
  }) {
    return PopupMenuItem(
      value: value,
      child: Card(
        color: Colors.black54,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.white, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                name,
                style: popupMenuItemStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
