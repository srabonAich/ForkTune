import 'package:flutter/foundation.dart';
import 'package:ForkTune/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../models/recipe.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  List<Recipe> _savedRecipes = [];


  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Recipe> get savedRecipes => _savedRecipes;


  UserProvider() {
    if (kDebugMode) {
      _currentUser = User(
        id: 'test-user-123',
        fullName: 'Test User',
        email: 'test@example.com',
        dietaryRestrictions: 'Vegetarian',
        allergies: 'None',
        cuisinePreferences: 'Italian',
        skillLevel: 'Intermediate',
        savedRecipes: [], // Initialize with empty list
      );
    }
  }

  Future<void> loadSavedRecipes() async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://your-api.com/users/${_currentUser!.id}/saved-recipes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _savedRecipes = data.map((recipe) => Recipe.fromJson(recipe)).toList();
        _error = null;
      } else {
        _error = 'Failed to load saved recipes';
      }
    } catch (e) {
      _error = 'Error loading saved recipes';
      if (kDebugMode) {
        print('Error loading saved recipes: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeSavedRecipe(String recipeId) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('https://your-api.com/users/${_currentUser!.id}/saved-recipes/$recipeId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Remove from local list
        _savedRecipes.removeWhere((recipe) => recipe.id == recipeId);
        // Update user's saved recipes list
        _currentUser = _currentUser!.copyWith(
          savedRecipes: _currentUser!.savedRecipes?.where((id) => id != recipeId).toList(),
        );
        await _saveUser(_currentUser);
        _error = null;
        return true;
      } else {
        _error = 'Failed to remove recipe';
        return false;
      }
    } catch (e) {
      _error = 'Error removing recipe';
      if (kDebugMode) {
        print('Error removing saved recipe: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add this private method to handle user saving
  Future<bool> _saveUser(User? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (user != null) {
        await prefs.setString('currentUser', json.encode(user.toJson()));
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user: $e');
      }
      return false;
    }
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('currentUser');

      if (userJson != null) {
        _currentUser = User.fromJson(json.decode(userJson));
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to load user data';
      if (kDebugMode) {
        print('Error loading user: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://your-api.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = User.fromJson(data['user']);
        await _saveUser(_currentUser);
        _error = null;
      } else {
        _error = 'Invalid email or password';
      }
    } catch (e) {
      _error = 'Login failed. Please try again.';
      if (kDebugMode) {
        print('Login error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('https://your-api.com/users/${updatedUser.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        _currentUser = updatedUser;
        await _saveUser(_currentUser);
        _error = null;
      } else {
        _error = 'Failed to update profile';
      }
    } catch (e) {
      _error = 'Update failed. Please try again.';
      if (kDebugMode) {
        print('Update error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = 'Logout failed';
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? dietaryRestrictions,
    String? allergies,
    String? cuisinePreferences,
    String? skillLevel,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://your-api.com/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'dietaryRestrictions': dietaryRestrictions ?? 'None',
          'allergies': allergies ?? 'None',
          'cuisinePreferences': cuisinePreferences ?? 'None',
          'skillLevel': skillLevel ?? 'Beginner',
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _currentUser = User.fromJson(data['user']);
        await _saveUser(_currentUser);
        _error = null;
      } else {
        _error = 'Registration failed: ${response.body}';
      }
    } catch (e) {
      _error = 'Registration failed. Please try again.';
      if (kDebugMode) {
        print('Registration error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse('https://my-api.com/users/${_currentUser!.id}/profile-image');
      var request = http.MultipartRequest('POST', uri);

      final fileStream = http.ByteStream(imageFile.openRead());
      final fileLength = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: path.basename(imageFile.path),
        contentType: MediaType('image', path.extension(imageFile.path).substring(1)),
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final parsedResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        final imageUrl = parsedResponse['imageUrl'] as String;
        _currentUser = _currentUser!.copyWith(
          profileImageUrl: imageUrl,
        );
        await _saveUser(_currentUser);
        _error = null;
        return imageUrl;
      } else {
        throw Exception('Failed to upload image: ${parsedResponse['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      _error = 'Failed to upload profile image';
      if (kDebugMode) {
        print('Profile image upload error: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addUserRecipe(String recipeId) {
    if (_currentUser == null) return;

    // Create a new list from the existing savedRecipes (ensure it's not null)
    final updatedSavedRecipes = List<String>.from(_currentUser!.savedRecipes ?? []);
    updatedSavedRecipes.add(recipeId);

    _currentUser = _currentUser!.copyWith(
      savedRecipes: updatedSavedRecipes,
    );
    notifyListeners();
    _saveUser(_currentUser);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}