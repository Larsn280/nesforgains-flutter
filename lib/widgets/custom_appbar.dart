import 'package:flutter/material.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // This is required to satisfy PreferredSizeWidget
  final String title;

  const CustomAppbar({super.key, required this.title})
      : preferredSize =
            const Size.fromHeight(60.0); // Adjust the height as needed

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.black45,
      shape: const Border(
        bottom: BorderSide(color: Colors.white, width: 1.0),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.book_outlined,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/bookofexusesScreen');
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {
            CustomSnackbar.showSnackBar(
                message: 'Notification feature coming soon!');
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          CustomSnackbar.showSnackBar(message: 'Menu feature coming soon!');
          // Scaffold.of(context).openDrawer();
        },
      ),
      elevation: 4.0, // Adds a shadow for depth
    );
  }
}
