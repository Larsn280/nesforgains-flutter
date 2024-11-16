import 'package:nes_for_gains/database/database.dart';
import 'package:flutter/material.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/service/workout_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final isar = await setupIsar();

    final workoutService = WorkoutService(isar);
    await workoutService.migrateWorkoutData();

    runApp(App(isar: isar));
  } catch (e, traceStack) {
    logger.e(e, stackTrace: traceStack);
  }
}
