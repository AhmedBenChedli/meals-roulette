import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../models/meal_model.dart';
import '../providers/meals_provider.dart';
import 'package:flutter_test/flutter_test.dart';

// Create a mock HTTP client using Mockito
class MockClient extends Mock implements http.Client {}

void main() {
  group('MealsProvider', () {
    late MealsProvider provider;
    late MockClient client;

    setUp(() {
      // Create an instance of the MealsProvider
      provider = MealsProvider();

      // Create a mock HTTP client
      client = MockClient();

      // Set the mock client to the provider's client
      provider.client = client;
    });

    test('fetchMeals should return a list of meal models', () async {
      // Define the response JSON
      final responseJson = {
        'meal_roulette_app_meals_aggregate': {
          'nodes': [
            {'id': 1, 'title': 'Meal 1', 'picture': 'image1.jpg'},
            {'id': 2, 'title': 'Meal 2', 'picture': 'image2.jpg'},
            {'id': 3, 'title': 'Meal 3', 'picture': 'image3.jpg'},
          ]
        }
      };

      // Mock the HTTP response
      // ignore: cast_from_null_always_fails
      when(client.get(any as Uri)).thenAnswer(
        (_) async => http.Response(
          jsonEncode(responseJson),
          200,
        ),
      );

      // Call the fetchMeals method
      final meals = await provider.fetchMeals(0);

      // Verify that the method returns a list of MealModel objects
      expect(meals, isA<List<MealModel>>());

      // Verify the contents of the returned list
      expect(meals.length, 3);
      expect(meals[0].id, 1);
      expect(meals[0].title, 'Meal 1');
      expect(meals[0].imgUrl, 'image1.jpg');
      // Verify other meal objects in the list

      // Verify that the HTTP client was called with the correct URL
      verify(client.get(Uri.parse(
          'https://playground.devskills.co/api/rest/meal-roulette-app/meals/limit/4/offset/0')));
    });

    test('checkImageValidity should return true for a valid image URL',
        () async {
      // Define the image URL
      const imageUrl = 'https://example.com/image.jpg';

      // Define the expected URL
      final expectedUrl = Uri.parse(imageUrl);

      // Define the response content type
      const contentType = 'image/jpeg';

      // Mock the HTTP response
      when(client.get(expectedUrl)).thenAnswer(
        (_) async =>
            http.Response('', 200, headers: {'content-type': contentType}),
      );

      // Call the checkImageValidity method
      final result = await provider.checkImageValidity(imageUrl);

      // Verify that the result is true for a valid image URL
      expect(result, true);

      // Verify that the HTTP client was called with the correct URL
      verify(client.get(expectedUrl));
    });

    test('fetchMealDetails should update the meal object with details',
        () async {
      // Define the response JSON
      final responseJson = {
        'meal_roulette_app_meals_by_pk': {
          'description': 'Some description',
          'ingredients': 'Ingredient 1, Ingredient 2'
        }
      };

      // Mock the HTTP response
      // ignore: cast_from_null_always_fails
      when(client.get(any as Uri)).thenAnswer(
        (_) async => http.Response(
          jsonEncode(responseJson),
          200,
        ),
      );

      // Create a meal model for testing
      final meal =
          MealModel(id: 1, title: 'Test Meal', imgUrl: 'meal_image.jpg');

      // Call the fetchMealDetails method
      final updatedMeal = await provider.fetchMealDetails(meal, 1);

      // Verify that the meal object is updated with the details
      expect(updatedMeal.description, 'Some description');
      expect(updatedMeal.ingredients, 'Ingredient 1, Ingredient 2');

      // Verify that the HTTP client was called with the correct URL
      verify(client.get(Uri.parse(
          'https://playground.devskills.co/api/rest/meal-roulette-app/meals/1')));
    });
  });
}
