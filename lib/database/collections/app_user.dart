import 'package:isar/isar.dart';

part 'app_user.g.dart';

@collection
class AppUser {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? name;

  String? password;

  int? age;
}
