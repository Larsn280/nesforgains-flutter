import 'package:flutter/material.dart';
import 'package:nes_for_gains/constants.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';
import 'package:nes_for_gains/service/workout_service.dart';
import 'package:nes_for_gains/service/auth_service.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/widgets/custom_appbar.dart';
import 'package:nes_for_gains/widgets/custom_buttons.dart';
import 'package:nes_for_gains/widgets/custom_cards.dart';
import 'package:nes_for_gains/widgets/custom_snackbar.dart';

class EditWorkoutScreen extends StatefulWidget {
  final Isar isar;
  final WorkoutData workout; // Pass the log to edit

  const EditWorkoutScreen(
      {super.key, required this.isar, required this.workout});

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late WorkoutService workoutService;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _exerciseController;
  late TextEditingController _dateController;
  late TextEditingController _repsController;
  late TextEditingController _setsController;
  late TextEditingController _kgController;

  @override
  void initState() {
    super.initState();
    workoutService = WorkoutService(widget.isar);
    _exerciseController =
        TextEditingController(text: widget.workout.exercise.toString());
    _dateController =
        TextEditingController(text: widget.workout.date.toString());
    _repsController =
        TextEditingController(text: widget.workout.rep.toString());
    _setsController =
        TextEditingController(text: widget.workout.set.toString());
    _kgController = TextEditingController(text: widget.workout.kg.toString());
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _dateController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _kgController.dispose();
    super.dispose();
  }

  Future<void> _handleEditWorkout() async {
    try {
      if (_formKey.currentState!.validate()) {
        WorkoutData updatedWorkout = WorkoutData(
          exercise: _exerciseController.text.toString(),
          date: _dateController.text.toString(),
          rep: int.parse(_repsController.text),
          set: int.parse(_setsController.text),
          kg: double.parse(_kgController.text),
          userId: AuthProvider.of(context).id,
        );

        final response =
            await workoutService.editWorkout(updatedWorkout, widget.workout.id);

        if (response.checksuccess == true) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
        CustomSnackbar.showSnackBar(message: response.message);
      }
    } catch (e) {
      logger.e('Error editing workout:', error: e);
      CustomSnackbar.showSnackBar(
          message:
              'An error occurred while editing the workout. Please try again.');
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
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(
                title: 'Edit Workout',
              ),
              const SizedBox(
                height: 40.0,
              ),
              CustomCards.buildFormCard(
                context: context,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          'Exercise (eg: Benchpress)', _exerciseController),
                      _buildTextField('Date (YYYY-MM-DD)', _dateController),
                      _buildTextField('Reps', _repsController, isNumeric: true),
                      _buildTextField('Sets', _setsController, isNumeric: true),
                      _buildTextField('Weight (kg)', _kgController,
                          isNumeric: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: _handleEditWorkout,
                  text: 'Save'),
              CustomButtons.buildElevatedFunctionButton(
                  context: context,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancle'),
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
