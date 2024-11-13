import 'package:flutter/material.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';

class DisplayWorkoutDetailsScreen extends StatefulWidget {
  final WorkoutData workoutData;

  const DisplayWorkoutDetailsScreen({super.key, required this.workoutData});

  @override
  State<DisplayWorkoutDetailsScreen> createState() =>
      _DisplayWorkoutDetailsState();
}

class _DisplayWorkoutDetailsState extends State<DisplayWorkoutDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
