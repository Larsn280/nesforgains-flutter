import 'package:NESForGains/database/collections/app_user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> setupIsar() async {
  // Get the application document directory
  final dir = await getApplicationDocumentsDirectory();

  // Open Isar instance and pass collection schemas
  final isar = await Isar.open(
    [AppUserSchema], // Pass your collection schemas here
    directory: dir.path,
  );

  return isar;
}
