import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/workout_service.dart';

class AddWorkoutScreen extends StatefulWidget {
  final Isar isar;

  const AddWorkoutScreen({super.key, required this.isar});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreen();
}

class _AddWorkoutScreen extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();
  DateTime? _selectedDate;
  late String responseMessage;

  late WorkoutService workoutService;

  @override
  void initState() {
    super.initState();
    workoutService = WorkoutService(widget.isar);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  void _saveTrainingData() async {
    try {
      if (_formKey.currentState!.validate() && _selectedDate != null) {
        final kgValue = double.tryParse(_weightController.text);
        final repValue = int.tryParse(_repsController.text);
        final setValue = int.tryParse(_setsController.text);
        final userIdValue = AuthProvider.of(context).id;

        final workoutData = WorkoutData(
          date: _selectedDate.toString(),
          kg: kgValue,
          rep: repValue,
          set: setValue,
          userId: userIdValue,
        );

        final response = await workoutService.addWorkout(
          workoutData,
        );

        setState(() {
          if (response.checksuccess) {
            _weightController.clear();
            _repsController.clear();
            _setsController.clear();
            _selectedDate = null;
          }
          responseMessage = response.message;
        });

        _showSnackBar(responseMessage);
      } else {
        setState(() {
          responseMessage = 'Please fill in all fields';
        });
        _showSnackBar(responseMessage);
      }
    } catch (e) {
      logger.e('Error adding workout', error: e);
      _showSnackBar(
          'An error occurred while adding the workout. Please try again.');
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstants.backgroundimage),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            const Text(
              'Log Workout',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.white)),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Date Picker
                      Row(
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat('y-MMM-d').format(_selectedDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.white),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Weight input
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight in kg';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // Reps input
                      TextFormField(
                        controller: _repsController,
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reps';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // Sets input
                      TextFormField(
                        controller: _setsController,
                        decoration: const InputDecoration(
                          labelText: 'Sets',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter sets';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Submit button
            AppConstants.buildElevatedFunctionButton(
                context: context,
                onPressed: _saveTrainingData,
                text: 'Save Workout'),
            AppConstants.buildElevatedButton(
                context: context,
                path: '/displayworkoutScreen',
                text: 'View Workouts'),
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
}
