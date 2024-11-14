import 'package:isar/isar.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  String? exercise;

  double? kg;

  int? rep;

  int? set;

  Exercise({
    this.exercise,
    this.kg,
    this.rep,
    this.set,
  });
}
