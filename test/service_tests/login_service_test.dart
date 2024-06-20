import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nes_for_gains/database/collections/app_user.dart';
import 'package:nes_for_gains/database/collections/daily_nutrition.dart';
import 'package:nes_for_gains/database/collections/dish.dart';
import 'package:nes_for_gains/service/login_service.dart';

void main() {
  late Isar isarTest;
  late Directory dirTest;
  late LoginService loginserviceTest;

  setUp(() async {
    dirTest = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      isarTest = await Isar.open(
          [DishSchema, DailyNutritionSchema, AppUserSchema],
          directory: dirTest.path, name: 'loginInstance');
    }

    loginserviceTest = LoginService(isarTest);
  });

  test("Open a instance on the Isar database", () async {
    final isOpen = isarTest.isOpen;
    expect(isOpen, true);
  });

  test("Test loginUser method - Valid Login", () async {
    // Create a test user
    final testUser = AppUser()
      ..username = 'testuser'
      ..email = 'testuser@example.com'
      ..password = 'password123';

    await isarTest.writeTxn(() async {
      await isarTest.appUsers.put(testUser);
    });

    // Call loginUser with valid credentials
    final userData =
        await loginserviceTest.loginUser('testuser', 'password123');

    // Verify the returned UserData
    expect(userData.id, isNotNull);
    expect(userData.username, 'testuser');

    await isarTest.writeTxn(() async {
      await isarTest.dishs.clear();
    });
  });

  test("Test loginUser method - Invalid Credentials", () async {
    // Call loginUser with invalid credentials
    try {
      await loginserviceTest.loginUser('invaliduser', 'invalidpassword');
      // If loginUser does not throw an exception, fail the test
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e.toString(), contains('Invalid username/email or password'));
    }
  });

  test("Test loginUser method - Multiple Users Found", () async {
    // Create multiple users with the same username
    final testUser1 = AppUser()
      ..username = 'shareduser'
      ..email = 'user1@example.com'
      ..password = 'password123';

    final testUser2 = AppUser()
      ..username = 'shareduser'
      ..email = 'user2@example.com'
      ..password = 'password456';

    await isarTest.writeTxn(() async {
      await isarTest.appUsers.put(testUser1);
      await isarTest.appUsers.put(testUser2);
    });

    // Call loginUser for a shared username
    try {
      await loginserviceTest.loginUser('shareduser', 'password123');
      // If loginUser does not throw an exception, fail the test
      fail('Multiple users found with the same username/email');
    } catch (e) {
      expect(e.toString(),
          contains('Multiple users found with the same username/email'));
    }

    await isarTest.writeTxn(() async {
      await isarTest.dishs.clear();
    });
  });

  tearDownAll(() async {
    await isarTest.close(deleteFromDisk: true);
    if (dirTest.existsSync()) {
      dirTest.deleteSync(recursive: true);
    }
  });
}
