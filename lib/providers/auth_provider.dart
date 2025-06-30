import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  int? _userId;
  String? _email;
  String? _name;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  int? get userId => _userId;
  String? get email => _email;
  String? get name => _name;

  Future<void> login(String email, String password) async {
    final response = await AuthService.login(email, password);
    _token = response['token'];
    _userId = response['userId'];
    _email = response['email'];
    _name = response['name'];
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _email = null;
    _name = null;
    notifyListeners();
  }
}