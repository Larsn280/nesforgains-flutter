import 'package:isar/isar.dart';

part 'training_data.g.dart';

@collection
class TrainingData {
  Id id = Isar.autoIncrement;

  String? date;

  double? kg;

  int? rep;

  int? set;

  int? userId;
}
