import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/service/register_service.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;
  late RegisterService registerServiceTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open([AppUserSchema],
          directory: dirTest.path, name: 'registerInstance');
    }

    registerServiceTest = RegisterService(isarTest);
  });

  tearDown(() async {
    await isarTest.close();
    dirTest.deleteSync(recursive: true);
  });

  test("Check if a user with an existing email exists", () async {
    final testUser = AppUser()
      ..email = 'existinguser@example.com'
      ..password = 'password123';

    await isarTest.writeTxn(() async {
      await isarTest.appUsers.put(testUser);
    });

    final userExists =
        await registerServiceTest.checkIfUserExists('existinguser@example.com');
    expect(userExists, true);

    final userDoesNotExist = await registerServiceTest
        .checkIfUserExists('nonexistentuser@example.com');
    expect(userDoesNotExist, false);
  });

  test("Validate email format", () {
    expect(registerServiceTest.isValidEmail('valid.email@example.com'), true);
    expect(registerServiceTest.isValidEmail('invalid-email'), false);
  });

  test("Create a new user with a valid and unique email", () async {
    final response = await registerServiceTest.createNewUser(
        'newuser@example.com', 'newpassword123');

    expect(response, 'newuser@example.com was created!');

    final userInDb = await isarTest.appUsers
        .filter()
        .emailEqualTo('newuser@example.com')
        .findFirst();
    expect(userInDb, isNotNull);
    expect(userInDb!.username, 'newuser');
  });

  test("Try creating a user with an invalid email", () async {
    final response = await registerServiceTest.createNewUser(
        'invalid-email', 'newpassword123');

    expect(response, 'invalid-email is invalid email format');
  });

  test("Try creating a user with an existing email", () async {
    final testUser = AppUser()
      ..email = 'existinguser@example.com'
      ..password = 'password123';

    await isarTest.writeTxn(() async {
      await isarTest.appUsers.put(testUser);
    });

    final response = await registerServiceTest.createNewUser(
        'existinguser@example.com', 'newpassword123');

    expect(
        response, 'User with email: existinguser@example.com already exists!');
  });
}
