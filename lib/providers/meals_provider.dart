import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class MealsProvider extends ChangeNotifier {
  MealsProvider({http.Client? httpClient})
      : client = httpClient ?? http.Client();
  List<dynamic> cashedMeals = [];
  List<dynamic> mealsToDisplay = [];
  List<MealModel> _meals = [];
  get fetchedMeals => _meals;
  var client = http.Client();

  Future<bool> checkImageValidity(String imgUrl) async {
    var url = Uri.parse(imgUrl);
    bool valid = false;
    final response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        valid = true;
      }
    } catch (e) {
      valid = false;
    }
    return valid;
  }

  Future<MealModel> fetchMealDetails(MealModel meal, int id) async {
    final url = Uri.parse(
        'https://playground.devskills.co/api/rest/meal-roulette-app/meals/$id');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      dynamic mealDetails = data['meal_roulette_app_meals_by_pk'];
      meal.description = mealDetails['description'];
      meal.ingredients = mealDetails['ingredients'];
    } else {
      debugPrint('Failed to fetch meals. Error code: ${response.statusCode}');
    }
    return meal;
  }

  Future<List<MealModel>> fetchMeals(int startingIndex) async {
    try {
      final data = await _fetchMealData(startingIndex);
      final meals = _transformMealData(data);
      return meals;
    } catch (e) {
      debugPrint('Failed to fetch meals. Error: $e');
      return [];
    }
  }

  Future<dynamic> _fetchMealData(int startingIndex) async {
    final url = Uri.parse(
        'https://playground.devskills.co/api/rest/meal-roulette-app/meals/limit/4/offset/$startingIndex');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch meals. Error code: ${response.statusCode}');
    }
  }

  List<MealModel> _transformMealData(dynamic data) {
    List<dynamic> meals = data['meal_roulette_app_meals_aggregate']['nodes'];
    List<MealModel> transformedMeals = [];
    // Transform meals into MealModel objects
    for (var meal in meals) {
      final mealName = meal['title'];
      final mealImgUrl = meal['picture'];
      final id = meal['id'];
      transformedMeals
          .add(MealModel(id: id, title: mealName, imgUrl: mealImgUrl));
      _meals = transformedMeals;
    }
    return transformedMeals;
  }
}
