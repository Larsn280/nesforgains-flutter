import 'package:NESForGains/database/collections/app_user.dart';
import 'package:NESForGains/models/user_data.dart';
import 'package:isar/isar.dart';

class LoginService {
  final Isar _isar;

  LoginService(this._isar);

  Future<UserData> loginUser(String usernameOrEmail, String password) async {
    final usersWithUsername = await _isar.appUsers
        .filter()
        .usernameEqualTo(usernameOrEmail)
        .findAll();
    final usersWithEmail =
        await _isar.appUsers.filter().emailEqualTo(usernameOrEmail).findAll();

    List<UserData> matchingUsers = [];

    for (final user in usersWithUsername) {
      if (user.password == password) {
        matchingUsers
            .add(UserData(id: user.id, username: user.username.toString()));
      }
    }

    for (final user in usersWithEmail) {
      if (user.password == password) {
        matchingUsers
            .add(UserData(id: user.id, username: user.username.toString()));
      }
    }

    if (matchingUsers.isEmpty) {
      throw Exception('Invalid username/email or password.');
    } else if (matchingUsers.length == 1) {
      return matchingUsers.first;
    } else {
      throw Exception('Multiple users found with the same username/email.');
    }
  }
}
