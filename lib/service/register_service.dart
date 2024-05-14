import 'package:isar/isar.dart';
import 'package:NESForGains/database/collections/app_user.dart';

class RegisterService {
  final Isar _isar;

  RegisterService(this._isar);

  Future<bool> isUserExists(String email, String password) async {
    // final usersWithEmail = await _isar.users.where().findAll();

    final userWithEmail =
        await _isar.appUsers.filter().nameEqualTo(email).findFirst();
    if (userWithEmail != null && userWithEmail.name == email) {
      return false;
    } else {
      final newUser = AppUser()
        ..name = email.toString()
        ..password = password.toString()
        ..age = 0;
      await _isar.writeTxn(() async {
        await _isar.appUsers.put(newUser);
      });
      return true;
    }
  }

  Future<String> doesUserExist(String name) async {
    final user = await _isar.appUsers.filter().nameEqualTo(name).findFirst();
    if (user != null && user.name != '') {
      final userName = user.name;
      return 'User: $userName exists';
    } else {
      return 'User does not exist';
    }
  }
}