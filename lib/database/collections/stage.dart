import 'package:isar/isar.dart';

part 'stage.g.dart';

@collection
class Stage {
  Id id = Isar.autoIncrement;
  late int stageNumber; // Step number (e.g., 1, 2, 3)
  late String instruction; // Step description (e.g., "Boil water")
  int?
      duration; // Optional duration for this step in minutes (e.g., 5 minutes for boiling)
}
