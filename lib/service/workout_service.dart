import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/exercise.dart';
import 'package:nes_for_gains/database/collections/workout.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';
import 'package:nes_for_gains/logger.dart';
import 'package:nes_for_gains/models/response_data.dart';

class WorkoutService {
  final Isar _isar;

  WorkoutService(this._isar);

  Future<ResponseData> addWorkout(
      Workout workout, List<Exercise> exercise) async {
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

          await _isar.exercises.putAll(exercise);

          workout.exercise.addAll(exercise);

          await _isar.workouts.put(workout);

          await workout.exercise.save();
        });
        return ResponseData(
            checksuccess: true,
            message:
                'Successfully added workout: ${workout.name}: ${workout.date}');
      }

      // If workout already exists, respond accordingly
      return ResponseData(
          checksuccess: false,
          message: 'Workout already logged: ${workout.name}: ${workout.date}');
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

  Future<ResponseData> editWorkout(Workout workoutToEdit,
      List<Exercise> exerciseListToEdit, int workoutId) async {
    try {
      // Attempt to find the workout by ID and user ID
      final checkWorkoutForEdit =
          await _isar.workouts.filter().idEqualTo(workoutId).findFirst();

      // If workout is found, proceed with edits
      if (checkWorkoutForEdit != null) {
        await _isar.writeTxn(() async {
          await checkWorkoutForEdit.exercise.load();
          final listToEdit =
              checkWorkoutForEdit.exercise.map((e) => e).toList();

          if (listToEdit.length != exerciseListToEdit.length) {
            await _isar.exercises.deleteAll(
                checkWorkoutForEdit.exercise.map((e) => e.id).toList());
            checkWorkoutForEdit.exercise.reset();
            await _isar.exercises.putAll(exerciseListToEdit);
            checkWorkoutForEdit.exercise.clear();
            checkWorkoutForEdit.exercise.addAll(exerciseListToEdit);
            await checkWorkoutForEdit.exercise.save();
            await _isar.workouts.put(checkWorkoutForEdit);
          } else {
            for (int i = 0; i < exerciseListToEdit.length; i++) {
              if (listToEdit[i] != exerciseListToEdit[i]) {
                listToEdit[i].exercise = exerciseListToEdit[i].exercise;
                listToEdit[i].rep = exerciseListToEdit[i].rep;
                listToEdit[i].set = exerciseListToEdit[i].set;
                listToEdit[i].kg = exerciseListToEdit[i].kg;
              }
            }
            await _isar.exercises.putAll(listToEdit);

            checkWorkoutForEdit.exercise.clear();
            checkWorkoutForEdit.exercise.addAll(listToEdit);
            await checkWorkoutForEdit.exercise.save();
            await _isar.workouts.put(checkWorkoutForEdit);
          }
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

  Future<void> migrateWorkoutData() async {
    try {
      // Fetch all existing records from the old table
      final oldWorkouts = await _isar.workoutDatas.where().findAll();

      if (oldWorkouts.isNotEmpty) {
        // Perform migration
        await _isar.writeTxn(() async {
          for (var workout in oldWorkouts) {
            // Create a new Workout
            final newWorkout = Workout(
              name: 'Workout for ${workout.date ?? 'Unknown Date'}',
              date: workout.date,
              userId: workout.userId,
            );

            // Save the new Workout to attach it to Isar
            final workoutId = await _isar.workouts.put(newWorkout);

            // Fetch the saved Workout (attached to Isar)
            final savedWorkout = await _isar.workouts.get(workoutId);

            if (savedWorkout != null) {
              // Create a new Exercise and add it to the Workout's link
              final newExercise = Exercise(
                exercise: workout.exercise ?? 'Unknown Exercise',
                rep: workout.rep ?? 0,
                set: workout.set ?? 0,
                kg: workout.kg ?? 0.0,
              );

              // Save the Exercise explicitly
              final exerciseId = await _isar.exercises.put(newExercise);

              // Link the Exercise to the Workout
              final savedExercise = await _isar.exercises.get(exerciseId);
              if (savedExercise != null) {
                savedWorkout.exercise.add(savedExercise);
                savedWorkout.exercise.save();
                // Save the updated Workout with the linked Exercise
                await _isar.workouts.put(savedWorkout);
              }
            }
          }
          await _isar.workoutDatas
              .deleteAll(oldWorkouts.map((o) => o.id).toList());
        });
      } else {
        logger.e('Nothing in database');
      }
    } catch (e) {
      logger.e('Data migration failed: $e');
      throw Exception(e);
    }
  }
}
