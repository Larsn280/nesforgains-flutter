import 'package:NESForGains/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:isar/isar.dart';

class TrainingScreen extends StatefulWidget {
  final Isar isar;

  const TrainingScreen({super.key, required this.isar});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _repController = TextEditingController();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _weigthController = TextEditingController();
  String? selectedNumber;
  final List<String> numbers =
      List<String>.generate(50, (index) => (index + 1).toString());

  @override
  void dispose() {
    _repController.dispose();
    _setController.dispose();
    _weigthController.dispose();
    super.dispose();
  }

  void _inputTrainingData() async {
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
                    'Traning Screen',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConstants.primaryTextColor),
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 17, 17, 17),
                              value: selectedNumber,
                              hint: Text(
                                'Select Reps',
                                style: TextStyle(
                                    color: AppConstants.primaryTextColor),
                              ),
                              items: numbers.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: AppConstants.primaryTextColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedNumber = newValue;
                                  _repController.text = newValue ?? '';
                                });
                              },
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              menuMaxHeight:
                                  200, // Set the maximum height for the dropdown menu
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConstants.primaryTextColor),
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 17, 17, 17),
                              value: selectedNumber,
                              hint: Text(
                                'Select Sets',
                                style: TextStyle(
                                    color: AppConstants.primaryTextColor),
                              ),
                              items: numbers.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: AppConstants.primaryTextColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedNumber = newValue;
                                  _repController.text = newValue ?? '';
                                });
                              },
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              menuMaxHeight:
                                  200, // Set the maximum height for the dropdown menu
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConstants.primaryTextColor),
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 17, 17, 17),
                              value: selectedNumber,
                              hint: Text(
                                'Select Weigth',
                                style: TextStyle(
                                    color: AppConstants.primaryTextColor),
                              ),
                              items: numbers.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: AppConstants.primaryTextColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedNumber = newValue;
                                  _repController.text = newValue ?? '';
                                });
                              },
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              menuMaxHeight:
                                  200, // Set the maximum height for the dropdown menu
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _inputTrainingData();
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
}
