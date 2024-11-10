import 'package:flutter/material.dart';

class CustomNavigationMenu extends StatefulWidget {
  const CustomNavigationMenu({super.key});
  @override
  CustomNavigationMenuState createState() => CustomNavigationMenuState();
}

class CustomNavigationMenuState extends State<CustomNavigationMenu> {
  OverlayEntry? _overlayEntry;
  late bool _isNutritionOpen = false;
  late bool _isWorkoutOpen = false;
  late bool _isRecipeOpen = false;
  final Color subColor = Colors.blueGrey;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: 200, // Set width of the overlay menu
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildMenuOption(
                icon: Icons.home,
                label: 'Home',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                  _removeOverlay();
                },
              ),
              buildMenuOption(
                icon: Icons.dining,
                label: 'Nutrition',
                onPressed: () {
                  setState(
                    () {
                      if (_isNutritionOpen == false) {
                        _isNutritionOpen = true;
                      } else {
                        _isNutritionOpen = false;
                      }
                      _removeOverlay();
                      _showOverlay();
                    },
                  );
                },
                hasSubcategories: true,
                isOpen: _isNutritionOpen,
              ),
              _isNutritionOpen == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildMenuOption(
                          icon: Icons.calculate,
                          label: 'Nutrition Calculator',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/nutritionScreen');
                            _removeOverlay();
                          },
                          color: subColor,
                        ),
                        buildMenuOption(
                            icon: Icons.list,
                            label: 'Display Nutrition',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/displaynutritionScreen');
                              _removeOverlay();
                            },
                            color: subColor),
                      ],
                    )
                  : const Column(),
              buildMenuOption(
                icon: Icons.bar_chart,
                label: 'Workouts',
                onPressed: () {
                  setState(() {
                    if (_isWorkoutOpen == false) {
                      _isWorkoutOpen = true;
                    } else {
                      _isWorkoutOpen = false;
                    }
                    _removeOverlay();
                    _showOverlay();
                  });
                },
                hasSubcategories: true,
                isOpen: _isWorkoutOpen,
              ),
              _isWorkoutOpen == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildMenuOption(
                          icon: Icons.fitness_center,
                          label: 'Add Workout',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/addworkoutScreen');
                            _removeOverlay();
                          },
                          color: subColor,
                        ),
                        buildMenuOption(
                          icon: Icons.list,
                          label: 'Display Workouts',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/displayworkoutScreen');
                            _removeOverlay();
                          },
                          color: subColor,
                        ),
                      ],
                    )
                  : const Column(),
              buildMenuOption(
                icon: Icons.receipt,
                label: 'Recipes',
                onPressed: () {
                  setState(() {
                    if (_isRecipeOpen == false) {
                      _isRecipeOpen = true;
                    } else {
                      _isRecipeOpen = false;
                    }
                    _removeOverlay();
                    _showOverlay();
                  });
                },
                hasSubcategories: true,
                isOpen: _isRecipeOpen,
              ),
              _isRecipeOpen == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildMenuOption(
                            icon: Icons.food_bank,
                            label: 'Add Recipe',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/addrecipeScreen');
                              _removeOverlay();
                            },
                            color: subColor),
                        buildMenuOption(
                            icon: Icons.list,
                            label: 'Recipelist',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/displayrecipeScreen');
                              _removeOverlay();
                            },
                            color: subColor),
                      ],
                    )
                  : const Column(),
              buildMenuOption(
                icon: Icons.book_sharp,
                label: 'Book of Exuses',
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/bookofexusesScreen');
                  _removeOverlay();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color color = Colors.black,
    bool hasSubcategories = false,
    bool isOpen = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.white)),
              ],
            ),
            if (hasSubcategories)
              Icon(
                isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white),
      onPressed: _toggleOverlay,
    );
  }
}
