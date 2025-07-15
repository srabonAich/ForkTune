import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

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
  final List<String> _dietOptions = ['Vegetarian', 'Vegan', 'Pescatarian', 'Gluten-free', 'Keto', 'Halal', 'Kosher'];
  final List<String> _allergyOptions = ['Peanuts', 'Tree nuts', 'Dairy', 'Egg', 'Wheat', 'Soy', 'Fish', 'Shellfish'];
  final List<String> _cuisineOptions = ['American', 'Italian', 'Mexican', 'Chinese', 'Japanese', 'Indian', 'Thai', 'Mediterranean', 'French'];

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

        mimeType = lookupMimeType(_selectedImage!.path);

        if (mimeType != null) {
          base64Image = 'data:$mimeType;base64,' + base64Image;
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
          'dietaryRestrictions': _currentUserPreferences.dietaryRestrictions ?? [],
          'allergies': _currentUserPreferences.allergies ?? [],
          'cuisinePreferences': _currentUserPreferences.cuisinePreferences ?? [],
          'diabeticFriendly': _currentUserPreferences.diabeticFriendly ?? false,
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

  Future<List<String>> _showMultiSelectDialog({
    required BuildContext context,
    required String title,
    required List<String> options,
    required List<String> initialSelections,
  }) async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (context) => MultiSelectDialog(
        title: title,
        options: options,
        initialSelections: initialSelections,
      ),
    );
    return selected ?? initialSelections;
  }

  Future<bool> _showDiabeticDialog(BuildContext context, bool initialValue) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Diabetic Friendly'),
        content: const Text('Is this user diabetic-friendly?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return result ?? initialValue;
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
                  _buildMultiSelectPreference(
                    icon: Icons.restaurant,
                    title: 'Dietary Restrictions',
                    selectedItems: _currentUserPreferences.dietaryRestrictions ?? [],
                    options: _dietOptions,
                    color: const Color(0xFF7F56D9),
                    onTap: () async {
                      final selected = await _showMultiSelectDialog(
                        context: context,
                        title: 'Dietary Restrictions',
                        options: _dietOptions,
                        initialSelections: _currentUserPreferences.dietaryRestrictions ?? [],
                      );
                      setState(() {
                        _currentUserPreferences.dietaryRestrictions = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMultiSelectPreference(
                    icon: Icons.health_and_safety,
                    title: 'Allergies',
                    selectedItems: _currentUserPreferences.allergies ?? [],
                    options: _allergyOptions,
                    color: Colors.redAccent,
                    onTap: () async {
                      final selected = await _showMultiSelectDialog(
                        context: context,
                        title: 'Allergies',
                        options: _allergyOptions,
                        initialSelections: _currentUserPreferences.allergies ?? [],
                      );
                      setState(() {
                        _currentUserPreferences.allergies = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMultiSelectPreference(
                    icon: Icons.flag,
                    title: 'Cuisine Preferences',
                    selectedItems: _currentUserPreferences.cuisinePreferences ?? [],
                    options: _cuisineOptions,
                    color: Colors.orange,
                    onTap: () async {
                      final selected = await _showMultiSelectDialog(
                        context: context,
                        title: 'Cuisine Preferences',
                        options: _cuisineOptions,
                        initialSelections: _currentUserPreferences.cuisinePreferences ?? [],
                      );
                      setState(() {
                        _currentUserPreferences.cuisinePreferences = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDiabeticPreference(
                    icon: Icons.medical_services,
                    title: 'Diabetic Friendly',
                    value: _currentUserPreferences.diabeticFriendly ?? false,
                    color: Colors.green,
                    onTap: () async {
                      final result = await _showDiabeticDialog(
                        context,
                        _currentUserPreferences.diabeticFriendly ?? false,
                      );
                      setState(() {
                        _currentUserPreferences.diabeticFriendly = result;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                _updateUserDetails();
                _updateUserPreferences();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F56D9),
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

  Widget _buildMultiSelectPreference({
    required IconData icon,
    required String title,
    required List<String> selectedItems,
    required List<String> options,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                    selectedItems.isEmpty ? 'None selected' : selectedItems.join(', '),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildDiabeticPreference({
    required IconData icon,
    required String title,
    required bool value,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                    value ? 'Yes' : 'No',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
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
  List<String>? dietaryRestrictions;
  List<String>? allergies;
  List<String>? cuisinePreferences;
  bool? diabeticFriendly;

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
          : [],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : [],
      cuisinePreferences: json['cuisinePreferences'] != null
          ? List<String>.from(json['cuisinePreferences'])
          : [],
      diabeticFriendly: json['diabeticFriendly'] ?? false,
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> initialSelections;

  const MultiSelectDialog({
    required this.title,
    required this.options,
    required this.initialSelections,
    super.key,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = List.from(widget.initialSelections);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: widget.options.map((option) {
            return CheckboxListTile(
              title: Text(option),
              value: selectedOptions.contains(option),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedOptions),
          child: const Text('Save'),
        ),
      ],
    );
  }
}