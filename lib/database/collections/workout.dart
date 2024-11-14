import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/exercise_data.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;

  late String name;

  final exercise = IsarLinks<Exercise>();
}
