import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/models/traininglog_data.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:nes_for_gains/service/training_service.dart';

class TrainingScreen extends StatefulWidget {
  final Isar isar;

  const TrainingScreen({super.key, required this.isar});

  @override
  State<TrainingScreen> createState() => _TrainingScreen();
}

class _TrainingScreen extends State<TrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();
  DateTime? _selectedDate;
  late String responseMessage;

  late TrainingService trainingService;

  @override
  void initState() {
    super.initState();
    trainingService = TrainingService(widget.isar);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  void _saveTrainingData() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // Create the TrainingLogData object
      final trainingLogData = TrainingLogData(
        reps: int.tryParse(_repsController.text) ?? 0,
        sets: int.tryParse(_setsController.text) ?? 0,
        kg: double.tryParse(_weightController.text) ?? 0,
        date: _selectedDate.toString(),
      );

      // Send data to the service and wait for response
      final response = await trainingService.inputTrainingData(
        trainingLogData,
        AuthProvider.of(context).id,
      );

      // Consolidate setState and response handling
      setState(() {
        if (response.checksuccess) {
          // Clear fields only on success
          _weightController.clear();
          _repsController.clear();
          _setsController.clear();
          _selectedDate = null;
        }
        responseMessage = response.message;
      });

      // Display the snackbar with the response message
      displaySnackbar(responseMessage);
    } else {
      // Set response message for validation failure
      setState(() {
        responseMessage = 'Please fill in all fields';
      });
      displaySnackbar(responseMessage);
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> displaySnackbar(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Log Workout',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Date Picker
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat('y-MMM-d').format(_selectedDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
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
                    const SizedBox(height: 20),
                    // Submit button
                    AppConstants.buildElevatedFunctionButton(
                        context: context,
                        onPressed: _saveTrainingData,
                        text: 'Save Workout'),
                    AppConstants.buildElevatedButton(
                        context: context,
                        path: '/viewtrainingLog',
                        text: 'View Workouts'),
                    AppConstants.buildElevatedButton(
                        context: context, path: '/', text: 'Go back'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
