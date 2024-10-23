import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/workout_data.dart';
import 'package:nes_for_gains/models/response_data.dart';

class WorkoutService {
  final Isar _isar;

  WorkoutService(this._isar);

  Future<ResponseData> addWorkout(WorkoutData data) async {
    try {
      List<String> sortedDate = data.date!.split(' ');
      String date = sortedDate[0];
      late ResponseData responseData;

      if (data.date != '') {
        final workouts = await _isar.workoutDatas
            .filter()
            .exerciseEqualTo(data.exercise)
            .repEqualTo(data.rep)
            .setEqualTo(data.set)
            .kgEqualTo(data.kg)
            .dateEqualTo(date)
            .findFirst();
        if (workouts == null) {
          final newWorkout = WorkoutData()
            ..exercise = capitalizeFirstLetter(data.exercise.toString())
            ..date = date.toString()
            ..rep = data.rep
            ..set = data.set
            ..kg = data.kg
            ..userId = data.userId;
          await _isar.writeTxn(() async {
            await _isar.workoutDatas.put(newWorkout);
          });
          responseData = ResponseData(
              checksuccess: true,
              message:
                  'Successfully added workout: ${data.exercise}: ${data.kg}kg X ${data.rep} X ${data.set}');
          return responseData;
        }
      }
      responseData = ResponseData(
          checksuccess: false,
          message:
              'Workout already logged: ${data.exercise}: ${data.kg}kg X ${data.rep} X ${data.set}');
      return responseData;
    } catch (e) {
      throw Exception('Error when trying to add workout $e');
    }
  }

  Future<List<WorkoutData>> fetchAllWorkouts(int userId) async {
    try {
      final logs = await _isar.workoutDatas
          .filter()
          .userIdEqualTo(userId)
          .sortByDateDesc()
          .findAll();

      if (logs.isNotEmpty) {
        return logs;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error when trying to fetch: $e');
    }
  }

  Future<ResponseData> editWorkout(WorkoutData data, int workoutId) async {
    try {
      final workouttoEdit = await _isar.workoutDatas
          .filter()
          .idEqualTo(workoutId)
          .userIdEqualTo(data.userId)
          .findFirst();

      if (workouttoEdit != null) {
        workouttoEdit.exercise =
            capitalizeFirstLetter(data.exercise.toString());
        workouttoEdit.date = data.date;
        workouttoEdit.rep = data.rep;
        workouttoEdit.set = data.set;
        workouttoEdit.kg = data.kg;
        await _isar.writeTxn(() async {
          await _isar.workoutDatas.put(workouttoEdit);
        });
        return ResponseData(
            checksuccess: true, message: 'Workout was successfuly edited');
      }

      return ResponseData(
          checksuccess: true, message: 'Workout does not exist');
    } catch (e) {
      throw Exception('Error when trying to edit: $e');
    }
  }

  Future<ResponseData> deleteWorkout(WorkoutData data) async {
    try {
      late ResponseData responseData;
      final workouttoDelete = await _isar.workoutDatas
          .filter()
          .userIdEqualTo(data.userId)
          .dateEqualTo(data.date)
          .kgEqualTo(data.kg)
          .findFirst();

      if (workouttoDelete != null) {
        await _isar.writeTxn(() async {
          await _isar.workoutDatas.delete(workouttoDelete.id);
        });
        responseData =
            ResponseData(checksuccess: true, message: 'Workout was deleted');
        return responseData;
      }
      responseData =
          ResponseData(checksuccess: false, message: 'Workout does not exist');
      return responseData;
    } catch (e) {
      throw Exception('Error when trying to delete: $e');
    }
  }

  String capitalizeFirstLetter(String str) {
    if (str.isEmpty) return str; // Check for empty string
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }
}
