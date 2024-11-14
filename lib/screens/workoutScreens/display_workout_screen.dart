import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/exercise.dart';
import 'package:nes_for_gains/database/collections/workout.dart';
import 'package:nes_for_gains/screens/workoutScreens/display_workout_details_screen.dart';
import 'package:nes_for_gains/screens/workoutScreens/edit_workout_screen.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/workout_service.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

class DisplayWorkoutScreen extends StatefulWidget {
  final Isar isar;

  const DisplayWorkoutScreen({super.key, required this.isar});

  @override
  State<DisplayWorkoutScreen> createState() => _DisplayWorkScreenState();
}

class _DisplayWorkScreenState extends State<DisplayWorkoutScreen> {
  static const double sizedBoxHeight = 18.0;
  late WorkoutService workoutService;
  late Future<List<Workout>> _futureWorkouts;

  @override
  void initState() {
    super.initState();
    workoutService = WorkoutService(widget.isar);
    _futureWorkouts = _fetchAllWorkouts();
  }

  Future<List<Workout>> _fetchAllWorkouts() async {
    try {
      final userId = AuthProvider.of(context).id;
      final response = await workoutService.fetchAllWorkouts(userId);
      return response;
    } catch (e) {
      logger.e('Error fetching workouts', error: e);
      CustomSnackbar.showSnackBar(
          message:
              'An error occurred while fetching the workouts. Please try again.');

      return [];
    }
  }

  void _navigateToEditWorkout(Workout workout) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditWorkoutScreen(
            workout: workout,
            isar: widget.isar,
          ),
        ),
      );
      if (result == true) {
        setState(() {
          _futureWorkouts = _fetchAllWorkouts();
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
        setState(() {
          _futureWorkouts = _fetchAllWorkouts();
        });
        CustomSnackbar.showSnackBar(message: response.message);
      }
    } catch (e) {
      logger.e('Error deleting workout', error: e);
      CustomSnackbar.showSnackBar(
          message:
              'An error occurred while deleting the workout. Please try again.');
    }
  }

  void _navigateToWorkoutDetails(Workout workout) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayWorkoutDetailsScreen(
          workout: workout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.appbackgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomAppbar(
              title: 'Workouts',
            ),
            const SizedBox(
              height: 40.0,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Workout>>(
                future: _futureWorkouts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildTrainingList([], 'Indicator');
                  } else if (snapshot.hasError) {
                    return _buildTrainingList([], 'Error loading logs');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildTrainingList([], 'No training logs available');
                  }

                  final logs = snapshot.data!;
                  return _buildTrainingList(logs, '');
                },
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingHeader() {
    return Row(
      children: [
        _buildTrainingColumnHeader('Exercise', 0.25),
        _buildTrainingColumnHeader('Reps', 0.10),
        _buildTrainingColumnHeader('Sets', 0.10),
        _buildTrainingColumnHeader('Weight (kg)', 0.15),
        const Flexible(child: SizedBox()),
      ],
    );
  }

  Widget _buildTrainingColumnHeader(String title, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTrainingRow(Workout log) {
    return GestureDetector(
      onTap: () {
        _navigateToWorkoutDetails(log);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.name),
                  Text(log.date.toString()),
                ],
              ),
            ),
            _buildTrainingColumn(
                log.exercise.map((e) => e.rep).toString(), 0.10),
            _buildTrainingColumn(
                log.exercise.map((e) => e.set).toString(), 0.10),
            _buildTrainingColumn(
                '${log.exercise.map((e) => e.kg).toString()} kg', 0.15),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.greenAccent),
                    onPressed: () {
                      _navigateToEditWorkout(log);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      _handleDeleteWorkout(log);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingColumn(String text, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(text),
    );
  }

  Widget _buildTrainingList(List<Workout> logs, String message) {
    return CustomCards.buildListCard(
      context: context,
      child: Column(
        children: [
          _buildTrainingHeader(),
          const Divider(),
          Expanded(
            child: logs.isNotEmpty
                ? ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _buildTrainingRow(log);
                    },
                  )
                : Center(
                    child: message.startsWith('Indicator')
                        ? CircularProgressIndicator(
                            color: AppConstants.primaryTextColor,
                          )
                        : Text(message),
                  ),
          )
        ],
      ),
    );
  }
}
