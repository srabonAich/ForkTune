/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/user/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000'; // or your backend IP

  Future<List<Recipe>> fetchFeaturedRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipes/featured'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load featured recipes');
    }
  }

  Future<List<Recipe>> fetchRecommendedRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipes/recommended'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recommended recipes');
    }
  }
}
