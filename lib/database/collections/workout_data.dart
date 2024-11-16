import 'package:isar/isar.dart';

part 'workout_data.g.dart';

@collection
class WorkoutData {
  Id id = Isar.autoIncrement;

  String? exercise;

  String? date;

  int? rep;

  int? set;

  double? kg;

  int? userId;

  WorkoutData(
      {this.exercise, this.date, this.rep, this.set, this.kg, this.userId});
}
