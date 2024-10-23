import 'package:isar/isar.dart';

part 'workout_data.g.dart';

@collection
class WorkoutData {
  Id id = Isar.autoIncrement;

  String? exercise;

  String? date;

  double? kg;

  int? rep;

  int? set;

  int? userId;

  WorkoutData({
    this.exercise,
    this.date,
    this.kg,
    this.rep,
    this.set,
    this.userId,
  });
}
