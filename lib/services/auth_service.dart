import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL of your backend API
  static const String _baseUrl = 'http://your-api-url.com/api'; // Replace with your actual URL

  // Headers for JSON content
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Login method
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  // Forgot password method
  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: _headers,
      body: jsonEncode({'email': email}),
    );

    _handleResponse(response);
  }

  // Helper method to handle API responses
  static dynamic _handleResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 400:
        throw Exception(responseBody['message'] ?? 'Invalid request');
      case 401:
        throw Exception(responseBody['message'] ?? 'Unauthorized');
      case 404:
        throw Exception(responseBody['message'] ?? 'Resource not found');
      case 500:
        throw Exception(responseBody['message'] ?? 'Server error');
      default:
        throw Exception('Failed with status code: ${response.statusCode}');
    }
  }
}