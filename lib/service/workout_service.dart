import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/response_data.dart';

class WorkoutService {
  final Isar _isar;

  WorkoutService(this._isar);

  Future<ResponseData> addWorkout(WorkoutData data) async {
    try {
      String parseDate(String dateTime) => dateTime.split(' ')[0];

      if (data.date == '') {
        return ResponseData(
            checksuccess: false,
            message:
                'Invalid date. Please provide a valid date for the workout.');
      }

      final String date = parseDate(data.date!);

      // Check for existing workout
      final existingWorkout = await _isar.workoutDatas
          .filter()
          .exerciseEqualTo(data.exercise)
          .repEqualTo(data.rep)
          .setEqualTo(data.set)
          .kgEqualTo(data.kg)
          .dateEqualTo(date)
          .findFirst();

      // If no existing workout, create a new one
      if (existingWorkout == null) {
        final newWorkout = WorkoutData()
          ..exercise = capitalizeFirstLetter(data.exercise.toString())
          ..date = date
          ..rep = data.rep
          ..set = data.set
          ..kg = data.kg
          ..userId = data.userId;

        await _isar
            .writeTxn(() async => await _isar.workoutDatas.put(newWorkout));

        return ResponseData(
            checksuccess: true,
            message:
                'Successfully added workout: ${data.exercise}: ${data.kg}kg X ${data.rep} X ${data.set}');
      }

      // If workout already exists, respond accordingly
      return ResponseData(
          checksuccess: false,
          message:
              'Workout already logged: ${data.exercise}: ${data.kg}kg X ${data.rep} X ${data.set}');
    } catch (e) {
      return ResponseData(
          checksuccess: false,
          message:
              'An error occurred while trying to add the workout: ${e.toString()}');
    }
  }

  Future<List<WorkoutData>> fetchAllWorkouts(int userId) async {
    try {
      final logs = await _isar.workoutDatas
          .filter()
          .userIdEqualTo(userId)
          .sortByDateDesc()
          .findAll();

      return logs; // Empty list if no records found
    } catch (e) {
      // Log the error or handle it externally
      logger.e('Error when trying to fetch workouts: $e');
      return []; // Return an empty list on error
    }
  }

  Future<ResponseData> editWorkout(WorkoutData data, int workoutId) async {
    try {
      // Attempt to find the workout by ID and user ID
      final workoutToEdit = await _isar.workoutDatas
          .filter()
          .idEqualTo(workoutId)
          .userIdEqualTo(data.userId)
          .findFirst();

      // If workout is found, proceed with edits
      if (workoutToEdit != null) {
        workoutToEdit
          ..exercise = capitalizeFirstLetter(data.exercise.toString())
          ..date = data.date
          ..rep = data.rep
          ..set = data.set
          ..kg = data.kg;

        // Save changes within a transaction
        await _isar.writeTxn(() async {
          await _isar.workoutDatas.put(workoutToEdit);
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

  Future<ResponseData> deleteWorkout(WorkoutData data) async {
    try {
      // Find the workout to delete based on the given data
      final workoutToDelete = await _isar.workoutDatas
          .filter()
          .userIdEqualTo(data.userId)
          .dateEqualTo(data.date)
          .kgEqualTo(data.kg)
          .findFirst();

      // If the workout is found, proceed with deletion
      if (workoutToDelete != null) {
        await _isar.writeTxn(() async {
          await _isar.workoutDatas.delete(workoutToDelete.id);
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
