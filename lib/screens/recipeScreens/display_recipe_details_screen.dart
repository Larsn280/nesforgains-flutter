import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/recipe.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';

class DisplayRecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;
  const DisplayRecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<DisplayRecipeDetailsScreen> createState() =>
      _DisplayRecipeScreenState();
}

class _DisplayRecipeScreenState extends State<DisplayRecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.appbackgroundimage),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const CustomAppbar(title: 'Recipe Details'),
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: CustomCards.buildListCard(
                  context: context,
                  child: SingleChildScrollView(
                    child: _buildRecipeDetails(widget.recipe),
                  )),
            ),
            const SizedBox(height: 8.0),
            CustomButtons.buildElevatedFunctionButton(
                context: context,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Go back'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeDetails(Recipe recipe) {
    final ingredients = recipe.ingredients.map((i) => i).toList();
    final stages = recipe.stage.map((i) => i.instruction).toList();
    return Column(
      children: [
        Text(
          widget.recipe.title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Duration: ${widget.recipe.duration} min'),
            Text('Difficulty: ${widget.recipe.difficulty}'),
          ],
        ),
        const SizedBox(
          height: 30.0,
        ),
        ingredients.isNotEmpty
            ? SizedBox(
                child: ListView.builder(
                  shrinkWrap: true, // Helps to avoid layout overflow
                  padding: const EdgeInsets.all(0),
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents nested scroll issues
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${ingredient.name}: ${ingredient.quantity} ${ingredient.unit}',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    );
                  },
                ),
              )
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    child: Text(
                      'No ingredients to show...',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
        const SizedBox(
          height: 10.0,
        ),
        stages.isNotEmpty
            ? SizedBox(
                child: ListView.builder(
                  shrinkWrap: true, // Helps to avoid layout overflow
                  padding: const EdgeInsets.all(0),
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents nested scroll issues
                  itemCount: stages.length,
                  itemBuilder: (context, index) {
                    final stage = stages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Steg ${index + 1}: $stage',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    );
                  },
                ),
              )
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    child: Text(
                      'No stages to show...',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
