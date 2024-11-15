import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/workout.dart';
import 'package:nes_for_gains/database/collections/exercise.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';

class DisplayWorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;

  const DisplayWorkoutDetailsScreen({super.key, required this.workout});

  @override
  State<DisplayWorkoutDetailsScreen> createState() =>
      _DisplayWorkoutDetailsState();
}

class _DisplayWorkoutDetailsState extends State<DisplayWorkoutDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.appbackgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const CustomAppbar(
              title: 'Workout Details',
            ),
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: CustomCards.buildListCard(
                context: context,
                child: SingleChildScrollView(
                  child: _buildWorkoutDetails(widget.workout),
                ),
              ),
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

  Widget _buildWorkoutDetails(Workout workout) {
    final exercises = workout.exercise.map((e) => e).toList();
    return Column(
      children: [
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  exercise.exercise.toString(),
                  style: const TextStyle(fontSize: 14.0),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
