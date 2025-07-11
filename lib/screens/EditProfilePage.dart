/*========latest dynamic code updated by Sagor========*/

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart'; // For MIME type detection

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _secureStorage = const FlutterSecureStorage();
  late UserDetails _currentUserDetails;
  late UserPreferences _currentUserPreferences;
  File? _selectedImage;
  bool _isLoading = true;
  bool _isSavingDetails = false;
  bool _isSavingPreferences = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _dietOptions = ['None', 'Vegetarian', 'Vegan', 'Pescatarian', 'Gluten-free', 'Keto', 'Halal', 'Kosher'];
  final List<String> _allergyOptions = ['None', 'Peanuts', 'Tree nuts', 'Dairy', 'Egg', 'Wheat', 'Soy', 'Fish', 'Shellfish'];
  final List<String> _cuisineOptions = ['None', 'American', 'Italian', 'Mexican', 'Chinese', 'Japanese', 'Indian', 'Thai', 'Mediterranean', 'French'];
  final List<String> _skillOptions = ['Beginner', 'Intermediate', 'Advanced', 'Professional'];

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final detailsResponse = await http.get(
        Uri.parse('http://localhost:8080/user/details'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final preferencesResponse = await http.get(
        Uri.parse('http://localhost:8080/user/preferences'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (detailsResponse.statusCode == 200 && preferencesResponse.statusCode == 200) {
        final detailsJson = json.decode(detailsResponse.body);
        final preferencesJson = json.decode(preferencesResponse.body);

        setState(() {
          _currentUserDetails = UserDetails.fromJson(detailsJson);
          _currentUserPreferences = UserPreferences.fromJson(preferencesJson);
          _nameController.text = _currentUserDetails.fullName;
          _dobController.text = _currentUserDetails.dateOfBirth ?? '';
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Method to change profile picture
  Future<void> _changeProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to select date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentUserDetails.dateOfBirth != null && _currentUserDetails.dateOfBirth!.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(_currentUserDetails.dateOfBirth!)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Method to update user details only when Save button is clicked
  Future<void> _updateUserDetails() async {
    setState(() => _isSavingDetails = true);

    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      String base64Image = "";
      String? mimeType;

      if (_selectedImage != null) {
        List<int> imageBytes = await _selectedImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);

        mimeType = lookupMimeType(_selectedImage!.path); // Example: "image/png", "image/jpeg"

        if (mimeType != null) {
          base64Image = 'data:$mimeType;base64,' + base64Image; // Dynamically prepend MIME type
        } else {
          throw Exception("Unable to determine MIME type for the image.");
        }
      }

      final response = await http.post(
        Uri.parse('http://localhost:8080/user/update-details'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'gender': _currentUserDetails.gender ?? 'Prefer not to say',
          'dob': _dobController.text,
          'profileImage': base64Image.isNotEmpty ? base64Image : null,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile details updated'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update details: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update details: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingDetails = false);
      }
    }
  }

  // Method to update preferences
  Future<void> _updateUserPreferences() async {
    setState(() => _isSavingPreferences = true);

    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse('http://localhost:8080/user/update-preferences'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'dietaryRestrictions': _currentUserPreferences.dietaryRestrictions ?? 'None',
          'allergies': _currentUserPreferences.allergies ?? 'None',
          'cuisinePreferences': _currentUserPreferences.cuisinePreferences ?? 'None',
          'skillLevel': _currentUserPreferences.skillLevel ?? 'Beginner',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences updated'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update preferences: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update preferences: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingPreferences = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
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
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF7F56D9).withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: _selectedImage != null
                        ? CircleAvatar(
                      radius: 58,
                      backgroundImage: FileImage(_selectedImage!),
                    )
                        : _currentUserDetails.imageBase64 != null &&
                        _currentUserDetails.imageBase64!.isNotEmpty &&
                        _isValidBase64(_currentUserDetails.imageBase64!)
                        ? CircleAvatar(
                      radius: 58,
                      backgroundImage: MemoryImage(
                        base64Decode(_currentUserDetails.imageBase64!),
                      ),
                    )
                        : const CircleAvatar(
                      radius: 58,
                      backgroundColor: Color(0xFFF5F3FF),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF7F56D9),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeProfilePicture,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7F56D9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // User Details Section
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
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEditableField(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  _buildDatePickerField(
                    icon: Icons.calendar_today,
                    label: 'Date of Birth',
                    controller: _dobController,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    icon: Icons.transgender,
                    label: 'Gender',
                    value: _currentUserDetails.gender ?? 'Prefer not to say',
                    options: _genderOptions,
                    onChanged: (value) {
                      setState(() {
                        _currentUserDetails.gender = value!;
                      });
                    },
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
                  _buildPreferenceDropdown(
                    icon: Icons.restaurant,
                    title: 'Dietary Restrictions',
                    value: _currentUserPreferences.dietaryRestrictions ?? 'None',
                    options: _dietOptions,
                    onChanged: (value) {
                      setState(() {
                        _currentUserPreferences.dietaryRestrictions = value ?? 'None';
                      });
                    },
                    color: const Color(0xFF7F56D9),
                    isLoading: _isSavingPreferences,
                  ),
                  const SizedBox(height: 12),
                  _buildPreferenceDropdown(
                    icon: Icons.health_and_safety,
                    title: 'Allergies',
                    value: _currentUserPreferences.allergies ?? 'None',
                    options: _allergyOptions,
                    onChanged: (value) {
                      setState(() {
                        _currentUserPreferences.allergies = value ?? 'None';
                      });
                    },
                    color: Colors.redAccent,
                    isLoading: _isSavingPreferences,
                  ),
                  const SizedBox(height: 12),
                  _buildPreferenceDropdown(
                    icon: Icons.flag,
                    title: 'Cuisine Preferences',
                    value: _currentUserPreferences.cuisinePreferences ?? 'None',
                    options: _cuisineOptions,
                    onChanged: (value) {
                      setState(() {
                        _currentUserPreferences.cuisinePreferences = value ?? 'None';
                      });
                    },
                    color: Colors.orange,
                    isLoading: _isSavingPreferences,
                  ),
                  const SizedBox(height: 12),
                  _buildPreferenceDropdown(
                    icon: Icons.star,
                    title: 'Skill Level',
                    value: _currentUserPreferences.skillLevel ?? 'Beginner',
                    options: _skillOptions,
                    onChanged: (value) {
                      setState(() {
                        _currentUserPreferences.skillLevel = value ?? 'Beginner';
                      });
                    },
                    color: Colors.amber,
                    isLoading: _isSavingPreferences,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save/Update Button
            ElevatedButton(
              onPressed: () {
                _updateUserDetails();
                _updateUserPreferences();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F56D9), // Use `backgroundColor` instead of `primary`
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '  Save Changes  ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  bool _isValidBase64(String? str) {
    if (str == null || str.isEmpty) return false;
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required Function() onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.calendar_today, size: 18),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String label,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: value,
                onChanged: onChanged,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                icon: const Icon(Icons.arrow_drop_down),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceDropdown({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required Function(String?) onChanged,
    required Color color,
    required bool isLoading,
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
                DropdownButtonFormField<String>(
                  value: value,
                  onChanged: onChanged,
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: Colors.white,
                ),
              ],
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }
}

class UserDetails {
  String fullName;
  String email;
  String? imageBase64;
  String? dateOfBirth;
  String? gender;

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
  String? dietaryRestrictions;
  String? allergies;
  String? cuisinePreferences;
  String? skillLevel;

  UserPreferences({
    this.dietaryRestrictions,
    this.allergies,
    this.cuisinePreferences,
    this.skillLevel,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryRestrictions: json['dietaryRestrictions'] ?? 'None',
      allergies: json['allergies'] ?? 'None',
      cuisinePreferences: json['cuisinePreferences'] ?? 'None',
      skillLevel: json['skillLevel'] ?? 'Beginner',
    );
  }
}
