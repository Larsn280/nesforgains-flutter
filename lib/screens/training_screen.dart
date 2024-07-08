import 'package:nes_for_gains/constants.dart';
import 'package:flutter/material.dart';

import 'package:isar/isar.dart';

class TrainingScreen extends StatefulWidget {
  final Isar isar;

  const TrainingScreen({super.key, required this.isar});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  final ExerciseControllers _controllers = ExerciseControllers();
  final List<String> reps =
      List<String>.generate(50, (index) => (index + 1).toString());
  final List<String> sets =
      List<String>.generate(50, (index) => (index + 1).toString());
  final List<String> weigth =
      List<String>.generate(500, (index) => (index + 1).toString());

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _submitTrainingdata() async {
    try {
      if (_formKey.currentState!.validate()) {
        print('success');
      } else {
        print('fail');
      }
    } catch (e) {
      print('Error updating $e');
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
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Training Screen',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    'Your one rep max : 125 kg',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Form(
                    key: _formKey,
                    child: _buildSelect(),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitTrainingdata();
                    },
                    child: const Text('Submit trainingdata'),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelect() {
    TextStyle textStyleX =
        const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

    Container container1 = Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.primaryTextColor),
      ),
      child: _buildDropdown(_controllers.repController, reps, 'Reps', 'reps'),
    );

    Container container2 = Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.primaryTextColor),
      ),
      child: _buildDropdown(_controllers.setController, reps, 'Sets', 'sets'),
    );

    Container container3 = Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.primaryTextColor),
      ),
      child:
          _buildDropdown(_controllers.weightController, weigth, 'Weigth', 'kg'),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        container1,
        Text('X', style: textStyleX),
        container2,
        Text('X', style: textStyleX),
        container3,
      ],
    );
  }

  Widget _buildDropdown(TextEditingController controller, List<String> list,
      String hint, String text) {
    String? selected;

    DropdownButtonFormField<dynamic> dropdownButtonFormField =
        DropdownButtonFormField<String>(
      dropdownColor: const Color.fromARGB(255, 17, 17, 17),
      value: selected,
      hint: Text(
        hint,
        style: TextStyle(
            color: AppConstants.primaryTextColor,
            fontSize: 14.0,
            fontWeight: FontWeight.bold),
      ),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            '$value $text',
            style: TextStyle(color: AppConstants.primaryTextColor),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selected = newValue;
          controller.text = newValue ?? '';
        });
      },
      isExpanded: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),

      menuMaxHeight: 200, // Set the maximum height for the dropdown menu
    );

    return dropdownButtonFormField;
  }
}

class ExerciseControllers {
  final TextEditingController repController = TextEditingController();
  final TextEditingController setController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  void dispose() {
    repController.dispose();
    setController.dispose();
    weightController.dispose();
  }
}
