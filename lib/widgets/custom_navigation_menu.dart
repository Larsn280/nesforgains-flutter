import 'package:flutter/material.dart';

class CustomNavigationMenu extends StatefulWidget {
  @override
  _CustomNavigationMenuState createState() => _CustomNavigationMenuState();
}

class _CustomNavigationMenuState extends State<CustomNavigationMenu> {
  OverlayEntry? _overlayEntry;

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
    Overlay.of(context)?.insert(_overlayEntry!);
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
          color: Colors.blue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildMenuOption(
                icon: Icons.dining,
                label: 'Nutrition',
                onPressed: () {
                  Navigator.pushNamed(context, '/nutritionScreen');
                  _removeOverlay();
                },
              ),
              buildMenuOption(
                icon: Icons.fitness_center,
                label: 'Fitness',
                onPressed: () {
                  Navigator.pushNamed(context, '/fitnessScreen');
                  _removeOverlay();
                },
              ),
              buildMenuOption(
                icon: Icons.health_and_safety,
                label: 'Wellness',
                onPressed: () {
                  Navigator.pushNamed(context, '/wellnessScreen');
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
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.black54,
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu, color: Colors.white),
      onPressed: _toggleOverlay,
    );
  }
}
