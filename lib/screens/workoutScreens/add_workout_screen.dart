import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/exercise.dart';
import 'package:nes_for_gains/database/collections/workout.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/workout_service.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

class AddWorkoutScreen extends StatefulWidget {
  final Isar isar;

  const AddWorkoutScreen({super.key, required this.isar});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreen();
}

class _AddWorkoutScreen extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workoutController = TextEditingController();
  final _exerciseController = TextEditingController();
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
    _workoutController.dispose();
    _exerciseController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  void _saveTrainingData() async {
    try {
      final List<Exercise> exerciseList = [];
      if (_formKey.currentState!.validate() && _selectedDate != null) {
        final workoutValue = _workoutController.text.toString();
        final splitExerciseList = _exerciseController.text.split(',');
        final splitKgList = _weightController.text.split(',');
        final splitRepList = _repsController.text.split(',');
        final splitSetList = _setsController.text.split(',');

        // Validate matching lengths of lists
        if (splitExerciseList.length != splitKgList.length ||
            splitExerciseList.length != splitRepList.length ||
            splitExerciseList.length != splitSetList.length) {
          setState(() {
            responseMessage =
                'Please ensure all fields have the same number of entries.';
          });
          CustomSnackbar.showSnackBar(message: responseMessage);
          return;
        }

        final userIdValue = AuthProvider.of(context).id;

        final workout = Workout(
            name: workoutValue,
            date: _selectedDate.toString(),
            userId: userIdValue);

        for (int i = 0; i < splitExerciseList.length; i++) {
          final exercise = Exercise(
            exercise: splitExerciseList[i].trim(),
            kg: double.tryParse(splitKgList[i].trim()),
            rep: int.tryParse(splitRepList[i].trim()),
            set: int.tryParse(splitSetList[i].trim()),
          );
          exerciseList.add(exercise);
        }

        final response = await workoutService.addWorkout(workout, exerciseList);

        setState(() {
          if (response.checksuccess) {
            _workoutController.clear();
            _exerciseController.clear();
            _weightController.clear();
            _repsController.clear();
            _setsController.clear();
            _selectedDate = null;
          }
          responseMessage = response.message;
        });

        CustomSnackbar.showSnackBar(message: responseMessage);
      } else {
        setState(() {
          responseMessage = 'Please fill in all fields';
        });

        CustomSnackbar.showSnackBar(message: responseMessage);
      }
    } catch (e) {
      logger.e('Error adding workout', error: e);
      CustomSnackbar.showSnackBar(
          message:
              'An error occurred while adding the workout. Please try again.');
    }
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
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(
                title: 'Log Workout',
              ),
              const SizedBox(height: 40.0),
              CustomCards.buildFormCard(
                context: context,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16.0),
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

                      TextFormField(
                        controller: _workoutController,
                        decoration: const InputDecoration(
                          labelText: 'Workout (eg: Chest, Legs, Bak)',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter workout eg: Legs...';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _exerciseController,
                        decoration: const InputDecoration(
                          labelText:
                              'Exercises eg: (Benchpress, comma separated)',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter exercise eg: Benchpress';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // Weight input
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg, comma separated)',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black54,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight in kg';
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reps (comma separated)';
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter sets (comma separated)';
                          }

                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8.0),
              // Submit button
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: _saveTrainingData,
                  text: 'Save Workout'),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: 'Back')
            ],
          ),
        ),
      ),
    );
  }
}
