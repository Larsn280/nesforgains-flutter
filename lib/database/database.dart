import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> setupIsar() async {
  // Get the application document directory
  final dir = await getApplicationDocumentsDirectory();

  // Open Isar instance and pass collection schemas
  final isar = await Isar.open(
    [
      AppUserSchema,
      DishSchema,
      DailyNutritionSchema
    ], // Pass your collection schemas here
    directory: dir.path,
  );

  return isar;
}
