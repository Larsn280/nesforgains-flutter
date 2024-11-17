import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/exercise.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;

  late String name;

  String? date;

  int? userId;

  final exercise = IsarLinks<Exercise>();

  String? markedColor;

  Workout(
      {required this.name,
      required this.date,
      required this.userId,
      this.markedColor});
}
