import 'package:isar/isar.dart';
import 'package:NESForGains/database/collections/app_user.dart';

class RegisterService {
  final Isar _isar;

  RegisterService(this._isar);

  // Kollar om email redan finns i databasen.
  Future<bool> checkIfUserExists(String email) async {
    final userWithEmail =
        await _isar.appUsers.filter().emailEqualTo(email).findFirst();

    if (userWithEmail != null && userWithEmail.email == email) {
      return true;
    } else {
      return false;
    }
  }

  // Regular expression för att validera standard email.
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Om användaren inte finns så skapar vi den här.
  Future<String> createNewUser(String email, String password) async {
    try {
      if (!isValidEmail(email)) {
        return '$email is invalid email format';
      }

      final userExists = await checkIfUserExists(email);

      if (userExists) {
        return 'User with email: $email already exists!';
      } else {
        List<String> parts = email.split('@');
        String newUsername = parts[0];

        final newUser = AppUser()
          ..email = email.toLowerCase().toString()
          ..username = newUsername.toLowerCase().toString()
          ..password = password.toString()
          ..age = 0;
        await _isar.writeTxn(() async {
          await _isar.appUsers.put(newUser);
        });
        return '$email was created!';
      }
    } catch (e) {
      throw Exception('Error creating new user: $e');
    }
  }
}
