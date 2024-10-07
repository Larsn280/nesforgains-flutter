import 'package:isar/isar.dart';

part 'training_data.g.dart';

@collection
class TrainingData {
  Id id = Isar.autoIncrement;

  DateTime? date;

  int? kg;

  int? rep;

  int? set;

  int? userId;
}
