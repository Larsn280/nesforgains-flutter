import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/training_data.dart';
import 'package:nes_for_gains/models/response_data.dart';
import 'package:nes_for_gains/models/traininglog_data.dart';

class TrainingService {
  final Isar _isar;

  TrainingService(this._isar);

  Future<ResponseData> inputTrainingData(
      TrainingLogData data, int userId) async {
    List<String> sortedDate = data.date!.split(' ');
    String date = sortedDate[0];
    final ResponseData responseData;
    try {
      if (data.date != '') {
        final trainingLog = await _isar.trainingDatas
            .filter()
            .repEqualTo(data.reps)
            .setEqualTo(data.sets)
            .kgEqualTo(data.kg)
            .dateEqualTo(date)
            .findFirst();
        if (trainingLog == null) {
          final newLog = TrainingData()
            ..date = date.toString()
            ..rep = data.reps
            ..set = data.sets
            ..kg = data.kg
            ..userId = userId;
          await _isar.writeTxn(() async {
            await _isar.trainingDatas.put(newLog);
          });
          responseData = ResponseData(
              checksuccess: true,
              message: 'Successfully logged workout: ${data.kg}');
          return responseData;
        } else {
          responseData = ResponseData(
              checksuccess: false,
              message: 'Workout already logged: ${data.kg}');
          return responseData;
        }
      }
      throw Exception('Something went very wrong!');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ResponseData> updateTrainingLog(
      int userId, TrainingLogData data) async {
    try {
      late ResponseData responseData;
      responseData = ResponseData(checksuccess: true, message: '');

      return responseData;
    } catch (e) {
      throw Exception('Something went wrong editing $e');
    }
  }

  Future<List<TrainingLogData>> fetchTrainingLogs(int userId) async {
    List<TrainingLogData> trainingLog = [];
    try {
      final logs = await _isar.trainingDatas
          .filter()
          .userIdEqualTo(userId) // Filtrera på användar-ID
          .sortByDateDesc() // Sortera datum i fallande ordning (senaste först)
          .findAll(); // Hämta alla loggar

      if (logs.isNotEmpty) {
        for (var workout in logs) {
          final workoutsession = TrainingLogData(
              reps: workout.rep,
              sets: workout.set,
              kg: workout.kg,
              date: workout.date);
          trainingLog.add(workoutsession);
        }
      }

      return trainingLog;
    } catch (e) {
      throw Exception('Failed to fetch training logs: $e');
    }
  }
}
