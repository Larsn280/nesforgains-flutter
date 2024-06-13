import 'package:NESForGains/constants.dart';
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
  final TextEditingController _repController = TextEditingController();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _weigthController = TextEditingController();
  String? selectedReps;
  String? selectedSets;
  String? selectedWeigth;
  final List<String> reps =
      List<String>.generate(50, (index) => (index + 1).toString());
  final List<String> sets =
      List<String>.generate(50, (index) => (index + 1).toString());
  final List<String> weigth =
      List<String>.generate(500, (index) => (index + 1).toString());

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstants.primaryTextColor),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                              border: InputBorder.none,
                            )),
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 17, 17, 17),
                              value: selectedReps,
                              hint: Text(
                                'Reps',
                                style: TextStyle(
                                    color: AppConstants.primaryTextColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              items: reps.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    '$value reps',
                                    style: TextStyle(
                                        color: AppConstants.primaryTextColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedReps = newValue;
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
                        const SizedBox(
                          child: Text(
                            'X',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstants.primaryTextColor),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                              border: InputBorder.none,
                            )),
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 17, 17, 17),
                              value: selectedSets,
                              hint: Text(
                                'Sets',
                                style: TextStyle(
                                    color: AppConstants.primaryTextColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              items: sets.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    '$value sets',
                                    style: TextStyle(
                                        color: AppConstants.primaryTextColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSets = newValue;
                                  _setController.text = newValue ?? '';
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
                        const SizedBox(
                          child: Text(
                            'X',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstants.primaryTextColor),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                              border: InputBorder.none,
                            )),
                            child: DropdownButtonFormField<String>(
                              dropdownColor:
                                  const Color.fromARGB(255, 17, 17, 17),
                              value: selectedWeigth,
                              hint: Text(
                                'Weigth',
                                style: TextStyle(
                                    color: AppConstants.primaryTextColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              items: weigth.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    '$value kg',
                                    style: TextStyle(
                                        color: AppConstants.primaryTextColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedWeigth = newValue;
                                  _weigthController.text = newValue ?? '';
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
