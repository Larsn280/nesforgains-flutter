class IngredientData {
  final String name; // Ingredient name (e.g., "Flour", "Eggs")
  final String unit; // Unit (e.g., "grams", "ml", "pieces")
  final double quantity; // Quantity of the ingredient (e.g., "200 grams")
  final String note; // Optional note (e.g., "chopped finely")

  IngredientData({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.note,
  });
}
