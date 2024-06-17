// test/database_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Import Mockito for mocking dependencies
import 'package:isar/isar.dart';
import 'package:nes_for_gains/models/nutrition_data.dart';
import 'package:nes_for_gains/service/nutrition_service.dart'; // Adjust path as per your project
import 'package:nes_for_gains/database/collections/dish.dart'; // Adjust path as per your project

// Mock database service using Mockito
class MockIsarDatabase extends Mock implements Isar {
  Future<List<Dish>> findAll() async {
    // Simulate database response
    return [
      Dish(
        name: 'Dish 1',
        calories: 100,
        protein: 10,
        carbohydrates: 20,
        fat: 5,
        userId: 1,
      ),
      Dish(
        name: 'Dish 2',
        calories: 150,
        protein: 12,
        carbohydrates: 25,
        fat: 8,
        userId: 1,
      ),
    ];
  }
}

void main() {
  group('getAllDishesById', () {
    test('returns list of NutritionData when dishes found', () async {
      // Arrange
      const int userId = 1;
      final mockIsar = MockIsarDatabase();
      final nutritionService = NutritionService(mockIsar);

      // Act
      final result = await nutritionService.getAllDishesById(userId);

      // Assert
      expect(result, isA<List<NutritionData>>());
      expect(result!.length, 2); // Assuming mock database returns 2 dishes
      expect(result[0].dish, 'Dish 1');
      expect(result[0].calories, 100);
      // Add more assertions for other fields as needed

      // Additional verification: Ensure findAll() was called on mockIsar
      verify(mockIsar.findAll())
          .called(1); // Adjust if findAll() should be called more than once
    });

    // Other test cases as previously discussed...
  });
}
