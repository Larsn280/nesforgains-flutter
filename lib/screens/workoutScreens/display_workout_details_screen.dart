import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/workout.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/screens/workoutScreens/edit_workout_screen.dart';
import 'package:nes_for_gains/service/workout_service.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

class DisplayWorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;
  final Isar isar;

  const DisplayWorkoutDetailsScreen(
      {super.key, required this.isar, required this.workout});

  @override
  State<DisplayWorkoutDetailsScreen> createState() =>
      _DisplayWorkoutDetailsState();
}

class _DisplayWorkoutDetailsState extends State<DisplayWorkoutDetailsScreen> {
  late WorkoutService workoutService;
  late Workout workout;

  @override
  void initState() {
    super.initState();
    workout = widget.workout;
    workoutService = WorkoutService(widget.isar);
  }

  Future<void> _fetchWorkout() async {
    try {
      final fetchedWorkout =
          await workoutService.fetchWorkoutById(widget.workout.id);
    } catch (e, stackTrace) {
      logger.e(e, stackTrace: stackTrace);
    }
  }

  void _navigateToEditWorkout(Workout workout) async {
    try {
      final updatedWorkout = await Navigator.push<Workout>(
        context,
        MaterialPageRoute(
          builder: (context) => EditWorkoutScreen(
            workout: workout,
            isar: widget.isar,
          ),
        ),
      );
      if (updatedWorkout != null) {
        setState(() {
          this.workout = updatedWorkout;
        });
      }
    } catch (e) {
      logger.e('Error navigating:', error: e);
      CustomSnackbar.showSnackBar(
          message:
              'An error occurred while trying to navigate. Please try again.');
    }
  }

  Future<void> _handleDeleteWorkout(Workout workout) async {
    try {
      final response = await workoutService.deleteWorkout(workout);

      if (response.checksuccess) {
        if (mounted) {
          Navigator.pop(context, true);
        }
        CustomSnackbar.showSnackBar(message: response.message);
      }
    } catch (e) {
      logger.e('Error deleting workout', error: e);
      CustomSnackbar.showSnackBar(
          message:
              'An error occurred while deleting the workout. Please try again.');
    }
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(
                title: 'Workout Details',
              ),
              const SizedBox(
                height: 40.0,
              ),
              CustomCards.buildListCard(
                context: context,
                child: _buildWorkoutDetails(workout),
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
      ),
    );
  }

  Widget _buildWorkoutDetails(Workout workout) {
    final exercises = workout.exercise.map((e) => e).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              workout.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.greenAccent),
              onPressed: () {
                _navigateToEditWorkout(workout);
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                _handleDeleteWorkout(workout);
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Date: ${workout.date}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20.0),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Exercises',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(
                      '${exercise.exercise}: ${exercise.rep}x${exercise.set}  ${exercise.kg} kg',
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
