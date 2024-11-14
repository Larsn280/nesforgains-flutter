import 'dart:math';

import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/exercise.dart';
import 'package:nes_for_gains/database/collections/workout.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/response_data.dart';

class WorkoutService {
  final Isar _isar;

  WorkoutService(this._isar);

  Future<ResponseData> addWorkout(Workout workout, Exercise exercise) async {
    try {
      String parseDate(String dateTime) => dateTime.split(' ')[0];

      if (workout.date == '') {
        return ResponseData(
            checksuccess: false,
            message:
                'Invalid date. Please provide a valid date for the workout.');
      }

      final String date = parseDate(workout.date!);

      final existingWorkout = await _isar.workouts
          .filter()
          .nameEqualTo(workout.name)
          .userIdEqualTo(workout.userId)
          .dateEqualTo(date)
          .findFirst();

      if (existingWorkout == null) {
        await _isar.writeTxn(() async {
          workout.date = date;

          await _isar.exercises.put(exercise);

          workout.exercise.add(exercise);

          await _isar.workouts.put(workout);

          await workout.exercise.save();
        });
        return ResponseData(
            checksuccess: true,
            message:
                'Successfully added workout: ${exercise.exercise}: ${exercise.kg}kg X ${exercise.rep} X ${exercise.set}');
      }

      // If workout already exists, respond accordingly
      return ResponseData(
          checksuccess: false,
          message:
              'Workout already logged: ${exercise.exercise}: ${exercise.kg}kg X ${exercise.rep} X ${exercise.set}');
    } catch (e) {
      return ResponseData(
          checksuccess: false,
          message:
              'An error occurred while trying to add the workout: ${e.toString()}');
    }
  }

  Future<List<Workout>> fetchAllWorkouts(int userId) async {
    try {
      final logs = await _isar.workouts
          .filter()
          .userIdEqualTo(userId)
          .sortByDateDesc()
          .findAll();
      for (var log in logs) {
        log.exercise.load();
      }
      return logs; // Empty list if no records found
    } catch (e) {
      // Log the error or handle it externally
      logger.e('Error when trying to fetch workouts: $e');
      return []; // Return an empty list on error
    }
  }

  Future<ResponseData> editWorkout(
      Workout workoutToEdit, Exercise exercise, int workoutId) async {
    try {
      // Attempt to find the workout by ID and user ID
      final checkWorkoutForEdit = await _isar.workouts
          .filter()
          .idEqualTo(workoutId)
          .userIdEqualTo(workoutToEdit.userId)
          .findFirst();

      // If workout is found, proceed with edits
      if (checkWorkoutForEdit != null) {
        await _isar.writeTxn(() async {
          await checkWorkoutForEdit.exercise.load();

          final checkExercisesForEdit =
              workoutToEdit.exercise.map((e) => e).toList();

          for (var checkExercise in checkExercisesForEdit) {
            if (checkExercise.id == exercise.id) {
              checkExercise == exercise;
            }
          }

          if (checkWorkoutForEdit.exercise.isNotEmpty) {
            await _isar.exercises.deleteAll(
                checkWorkoutForEdit.exercise.map((e) => e.id).toList());
          }

          checkWorkoutForEdit.exercise.reset();
          checkWorkoutForEdit.exercise.save();

          await _isar.exercises.putAll(checkExercisesForEdit);
          checkWorkoutForEdit.exercise.addAll(checkExercisesForEdit);

          await _isar.workouts.put(checkWorkoutForEdit);

          checkWorkoutForEdit.exercise.save();
        });

        return ResponseData(
          checksuccess: true,
          message: 'Workout was successfully edited',
        );
      }

      // If workout not found, return an error message
      return ResponseData(
        checksuccess: false,
        message: 'Workout with ID $workoutId does not exist',
      );
    } catch (e) {
      return ResponseData(
        checksuccess: false,
        message: 'Error when trying to edit workout: ${e.toString()}',
      );
    }
  }

  Future<ResponseData> deleteWorkout(Workout workout) async {
    try {
      // Find the workout to delete based on the given data
      final workoutToDelete = await _isar.workouts
          .filter()
          .userIdEqualTo(workout.userId)
          .dateEqualTo(workout.date)
          .findFirst();

      // If the workout is found, proceed with deletion
      if (workoutToDelete != null && workoutToDelete.exercise.isNotEmpty) {
        await _isar.writeTxn(() async {
          await workoutToDelete.exercise.load();
          await _isar.exercises
              .deleteAll(workoutToDelete.exercise.map((e) => e.id).toList());
          workoutToDelete.exercise.reset();
          workoutToDelete.exercise.save();
          await _isar.workouts.delete(workoutToDelete.id);
        });
        return ResponseData(
            checksuccess: true, message: 'Workout was successfully deleted.');
      }

      // Workout was not found
      return ResponseData(
          checksuccess: false,
          message: 'Workout does not exist and cannot be deleted.');
    } catch (e) {
      return ResponseData(
          checksuccess: false,
          message: 'Error when trying to delete workout: ${e.toString()}');
    }
  }

  String capitalizeFirstLetter(String str) {
    if (str.isEmpty) return str; // Check for empty string
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }
}
