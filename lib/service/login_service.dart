import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/models/user_data.dart';
import 'package:isar/isar.dart';

class LoginService {
  final Isar _isar;

  LoginService(this._isar);

  Future<UserData> loginUser(String usernameOrEmail, String password) async {
    try {
      final users = await _isar.appUsers
          .filter()
          .group((q) => q
              .usernameEqualTo(usernameOrEmail.toLowerCase())
              .or()
              .emailEqualTo(usernameOrEmail.toLowerCase()))
          .findAll();

      // Filter users by password
      final matchingUsers = users
          .where((user) => user.password == password)
          .map((user) =>
              UserData(id: user.id, username: user.username.toString()))
          .toList();

      if (matchingUsers.isEmpty) {
        throw Exception('Invalid username/email or password.');
      } else if (matchingUsers.length == 1) {
        return matchingUsers.first;
      } else {
        throw Exception('Multiple users found with the same username/email.');
      }
    } catch (e) {
      throw Exception('Error logging in user: $e');
    }
  }
}
