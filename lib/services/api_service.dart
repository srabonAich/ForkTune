//old
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


//old

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
*/



//latest

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/User.dart';
import '../models/recipe.dart';
import 'package:http_parser/http_parser.dart';


class ApiService {
  static const String _baseUrl = 'http://your-backend-url.com/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/recipes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add recipe');
    }
  }

  Future<List<Recipe>> getSavedRecipes(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId/saved-recipes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load saved recipes');
    }
  }

  Future<bool> removeSavedRecipe(String userId, String recipeId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$userId/saved-recipes/$recipeId'),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send password reset email');
    }
  }

  Future<User> getUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/users/$userId/profile-image'),
    );

    final extension = imageFile.path.split('.').last.toLowerCase();

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', extension),
    ));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData)['imageUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
