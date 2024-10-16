import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/models/traininglog_data.dart';
import 'package:nes_for_gains/service/workout_service.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/logger.dart';

class EditWorkoutScreen extends StatefulWidget {
  final Isar isar;
  final TrainingLogData trainingLog; // Pass the log to edit

  const EditWorkoutScreen(
      {super.key, required this.isar, required this.trainingLog});

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late WorkoutService workoutService;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _dateController;
  late TextEditingController _repsController;
  late TextEditingController _setsController;
  late TextEditingController _kgController;

  @override
  void initState() {
    super.initState();
    workoutService = WorkoutService(widget.isar);

    // Initialize controllers with existing values
    _dateController =
        TextEditingController(text: widget.trainingLog.date.toString());
    _repsController =
        TextEditingController(text: widget.trainingLog.reps.toString());
    _setsController =
        TextEditingController(text: widget.trainingLog.sets.toString());
    _kgController =
        TextEditingController(text: widget.trainingLog.kg.toString());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _kgController.dispose();
    super.dispose();
  }

  Future<void> _saveTrainingLog() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userId = AuthProvider.of(context).id;

        // Create updated training log object
        TrainingLogData updatedLog = TrainingLogData(
          date: _dateController.text.toString(),
          reps: int.parse(_repsController.text),
          sets: int.parse(_setsController.text),
          kg: double.parse(_kgController.text),
        );

        // Save to the database
        await workoutService.updateTrainingLog(userId, updatedLog);

        // Show a success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Training log updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        logger.e('Error updating training log', error: e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update training log')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.backgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Edit Training Log',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Date (YYYY-MM-DD)', _dateController),
                    _buildTextField('Reps', _repsController, isNumeric: true),
                    _buildTextField('Sets', _setsController, isNumeric: true),
                    _buildTextField('Weight (kg)', _kgController,
                        isNumeric: true),
                    const SizedBox(height: 16.0),
                    AppConstants.buildElevatedFunctionButton(
                        context: context,
                        onPressed: _saveTrainingLog,
                        text: 'Save'),
                    const SizedBox(height: 8.0),
                    AppConstants.buildElevatedButton(
                        context: context,
                        path: '/trainingScreen',
                        text: 'Cancel'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isNumeric && double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
