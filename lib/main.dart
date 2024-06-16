import 'package:nes_for_gains/database/database.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  // ignore: unused_local_variable
  final isar = await setupIsar();

  // Check if Isar initialization was successful
  // ignore: unnecessary_null_comparison
  if (isar != null) {
    // ignore: avoid_print
    print('Isar initialization successful!');
  } else {
    // ignore: avoid_print
    print('Failed to initialize Isar.');
  }

  runApp(App(isar: isar));
}
