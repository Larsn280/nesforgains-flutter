import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';
import 'package:nes_for_gains/screens/workoutScreens/edit_workout_screen.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/workout_service.dart';

class DisplayWorkoutScreen extends StatefulWidget {
  final Isar isar;

  const DisplayWorkoutScreen({super.key, required this.isar});

  @override
  State<DisplayWorkoutScreen> createState() => _DisplayWorkScreenState();
}

class _DisplayWorkScreenState extends State<DisplayWorkoutScreen> {
  static const double sizedBoxHeight = 18.0;
  late WorkoutService workoutService;
  late Future<List<WorkoutData>> _futureWorkouts;

  @override
  void initState() {
    super.initState();
    workoutService = WorkoutService(widget.isar);
    _futureWorkouts = _fetchAllWorkouts();
  }

  Future<List<WorkoutData>> _fetchAllWorkouts() async {
    try {
      final userId = AuthProvider.of(context).id;
      final response = await workoutService.fetchAllWorkouts(userId);
      return response;
    } catch (e) {
      logger.e('Error fetching workouts', error: e);
      _showSnackBar(
          'An error occurred while fetching the workouts. Please try again.');
      return [];
    }
  }

  void _navigateToEditWorkout(WorkoutData workout) async {
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
      _showSnackBar(
          'An error occurred while trying to navigate. Please try again.');
    }
  }

  Future<void> _handleDeleteWorkout(WorkoutData data) async {
    try {
      final response = await workoutService.deleteWorkout(data);

      if (response.checksuccess) {
        setState(() {
          _futureWorkouts = _fetchAllWorkouts();
        });
        _showSnackBar(response.message);
      }
    } catch (e) {
      logger.e('Error deleting workout', error: e);
      _showSnackBar(
          'An error occurred while deleting the workout. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.backgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              'Workouts',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<WorkoutData>>(
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
            AppConstants.buildElevatedFunctionButton(
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

  Widget _buildTrainingHeader() {
    return Row(
      children: [
        _buildTrainingColumnHeader('Date', 0.25),
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

  Widget _buildTrainingRow(WorkoutData log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          _buildTrainingColumn(log.date.toString(), 0.25),
          _buildTrainingColumn(log.rep.toString(), 0.10),
          _buildTrainingColumn(log.set.toString(), 0.10),
          _buildTrainingColumn(log.kg.toString(), 0.15),
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
    );
  }

  Widget _buildTrainingColumn(String text, double widthFactor) {
    return SizedBox(
      height: sizedBoxHeight,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: Text(text),
    );
  }

  Widget _buildTrainingList(List<WorkoutData> logs, String message) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: AppConstants.primaryTextColor,
        ),
      ),
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
