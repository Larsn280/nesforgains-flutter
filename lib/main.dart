import 'package:nes_for_gains/database/database.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await setupIsar();

  runApp(App(isar: isar));
}
