import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/ingredient.dart';
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
    // TODO: implement build
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
                    child: Column(
                      children: [
                        Text(
                          widget.recipe.title,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Duration: ${widget.recipe.duration} min'),
                            Text('Difficulty: ${widget.recipe.difficulty}'),
                          ],
                        ),
                        _buildIngredientList(widget.recipe.ingredients
                            .map((i) => i.name)
                            .toList()),
                      ],
                    ),
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

  Widget _buildIngredientList(List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ingredients.isNotEmpty
            ? SizedBox(
                // height: 200.0, // Adjust this height as needed
                child: ListView.builder(
                  shrinkWrap: true, // Helps to avoid layout overflow
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents nested scroll issues
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        ingredient,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    );
                  },
                ),
              )
            : const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: SizedBox(
                    child: Text('No ingredients to show...'),
                  ),
                ),
              ),
      ],
    );
  }
}
