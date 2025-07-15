/*========latest dynamic code updated by Sagor========*/
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _secureStorage = const FlutterSecureStorage();
  late Future<UserDetails> _userDetailsFuture;
  late Future<UserPreferences> _userPreferencesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _userDetailsFuture = _fetchUserDetails();
      _userPreferencesFuture = _fetchUserPreferences();
    });
  }

  Future<UserDetails> _fetchUserDetails() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('http://localhost:8080/user/details'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  Future<UserPreferences> _fetchUserPreferences() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse('http://localhost:8080/user/preferences'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserPreferences.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user preferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([_userDetailsFuture, _userPreferencesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final userDetails = snapshot.data![0] as UserDetails;
          final userPreferences = snapshot.data![1] as UserPreferences;

          return _buildProfileContent(userDetails, userPreferences);
        },
      ),
    );
  }

  Widget _buildProfileContent(UserDetails userDetails, UserPreferences userPreferences) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Picture and Basic Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (userDetails.imageBase64 != null && userDetails.imageBase64!.isNotEmpty)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(
                      base64Decode(userDetails.imageBase64!),
                    ),
                  )
                else
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF5F3FF),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF7F56D9),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  userDetails.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userDetails.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                if (userDetails.dateOfBirth != null || userDetails.gender != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (userDetails.dateOfBirth != null)
                        Row(
                          children: [
                            const Icon(Icons.cake, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              userDetails.dateOfBirth!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      if (userDetails.dateOfBirth != null && userDetails.gender != null)
                        const SizedBox(width: 16),
                      if (userDetails.gender != null)
                        Row(
                          children: [
                            Icon(
                              userDetails.gender == 'Male'
                                  ? Icons.male
                                  : userDetails.gender == 'Female'
                                  ? Icons.female
                                  : Icons.transgender,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              userDetails.gender!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preferences Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (userPreferences.dietaryRestrictions != null && userPreferences.dietaryRestrictions!.isNotEmpty)
                  _buildPreferenceItem(
                    icon: Icons.restaurant,
                    title: 'Dietary Restrictions',
                    value: userPreferences.dietaryRestrictions!.join(', '),
                    color: const Color(0xFF7F56D9),
                  ),
                const SizedBox(height: 12),
                if (userPreferences.allergies != null && userPreferences.allergies!.isNotEmpty)
                  _buildPreferenceItem(
                    icon: Icons.health_and_safety,
                    title: 'Allergies',
                    value: userPreferences.allergies!.join(', '),
                    color: Colors.redAccent,
                  ),
                const SizedBox(height: 12),
                if (userPreferences.cuisinePreferences != null && userPreferences.cuisinePreferences!.isNotEmpty)
                  _buildPreferenceItem(
                    icon: Icons.flag,
                    title: 'Cuisine Preferences',
                    value: userPreferences.cuisinePreferences!.join(', '),
                    color: Colors.orange,
                  ),
                const SizedBox(height: 12),
                if (userPreferences.diabeticFriendly != null)
                  _buildPreferenceItem(
                    icon: Icons.medical_services,
                    title: 'Diabetic Friendly',
                    value: userPreferences.diabeticFriendly! ? 'Yes' : 'No',
                    color: Colors.green,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F56D9),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.red.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                "Log Out?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _secureStorage.delete(key: 'token');
                        if (!mounted) return;
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Log Out"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetails {
  final String fullName;
  final String email;
  final String? imageBase64;
  final String? dateOfBirth;
  final String? gender;

  UserDetails({
    required this.fullName,
    required this.email,
    this.imageBase64,
    this.dateOfBirth,
    this.gender,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      fullName: json['name'] ?? '',
      email: json['email'] ?? '',
      imageBase64: json['profileImage'],
      dateOfBirth: json['dob'],
      gender: json['gender'],
    );
  }
}

class UserPreferences {
  final List<String>? dietaryRestrictions;
  final List<String>? allergies;
  final List<String>? cuisinePreferences;
  final bool? diabeticFriendly;

  UserPreferences({
    this.dietaryRestrictions,
    this.allergies,
    this.cuisinePreferences,
    this.diabeticFriendly,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryRestrictions: json['dietaryRestrictions'] != null
          ? List<String>.from(json['dietaryRestrictions'])
          : null,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      cuisinePreferences: json['cuisinePreferences'] != null
          ? List<String>.from(json['cuisinePreferences'])
          : null,
      diabeticFriendly: json['diabeticFriendly'],
    );
  }
}