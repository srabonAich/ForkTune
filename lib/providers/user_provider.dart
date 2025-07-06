import 'package:flutter/foundation.dart';
import 'package:my_first_app/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart'; //for media type

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with test user for development
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
      );
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
      // Replace with your actual API endpoint
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

        // Save to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', json.encode(_currentUser!.toJson()));

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
      // Replace with your actual API endpoint
      final response = await http.put(
        Uri.parse('https://your-api.com/users/${updatedUser.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        _currentUser = updatedUser;

        // Update shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', json.encode(_currentUser!.toJson()));

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
      // Clear local storage
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
      // Replace with your actual API endpoint
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

        // Save to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', json.encode(_currentUser!.toJson()));

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

    try{
      // create multipart request
      final uri = Uri.parse('https://my-api.com/users/${_currentUser!.id}/profile-image');
      var request = http.MultipartRequest('POST', uri);

      // add file to request
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

      //add authorization token if needed
      // request.headers['Authorization'] = 'Bearer your_token_here';

      //send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final parsedResponse = json.decode(responseData);

      if(response.statusCode == 200) {
        final imageUrl = parsedResponse['imageUrl'] as String;

        //update local user with new img url
        _currentUser = _currentUser!.copyWith(
          profileImageUrl: imageUrl,
          localProfileImage: null, // clear local file reference
        );

        //update shared preference
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUser', json.encode(_currentUser!.toJson()));

        _error = null;
        return imageUrl;
      } else{
        throw Exception('Failed to upload image: ${parsedResponse['message'] ?? 'Unknown error'}');
      }
    } catch(e) {
      _error = 'Failed to upload profile image';
      if (kDebugMode){
        print('Profile image upload error: $e');
      }
      rethrow;
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}