import 'package:isar/isar.dart';

part 'exercise_data.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  String? exercise;

  String? date;

  double? kg;

  int? rep;

  int? set;

  int? userId;

  Exercise({
    this.exercise,
    this.date,
    this.kg,
    this.rep,
    this.set,
    this.userId,
  });
}
