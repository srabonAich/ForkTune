/*
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final data = await ApiService.fetchUserProfile('user123'); // Replace with actual user ID or auth logic
      setState(() {
        userProfile = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text('Error: $error'))
          : userProfile == null
          ? const Center(child: Text('No user data'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              color: Color(0xFFF9F9F9),
              elevation: 0,
              margin: EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Profile Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(
                      'View your information and preferences to personalize your recipe experience.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const Text('Basic Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _infoTile('Username', userProfile!['username'] ?? 'N/A'),
            const SizedBox(height: 16),
            _infoTile('Email Address', userProfile!['email'] ?? 'N/A'),
            const SizedBox(height: 24),
            const Text('Cooking Preferences',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _infoTile('Dietary Restrictions', userProfile!['dietary'] ?? 'N/A'),
            const SizedBox(height: 16),
            _infoTile('Allergies', userProfile!['allergy'] ?? 'N/A'),
            const SizedBox(height: 16),
            _infoTile('Cuisine Preferences', userProfile!['cuisine'] ?? 'N/A'),
            const SizedBox(height: 24),
            const Text('Skill Level',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _infoTile('Cooking Skill Level', userProfile!['skillLevel'] ?? 'N/A'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

*/

/*
 import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data (replace with dynamic data as needed)
    const String username = 'Alice Smith';
    const String email = 'alice.smith@example.com';
    const String dietary = 'Vegetarian';
    const String allergy = 'None';
    const String cuisine = 'Italian';
    const String skillLevel = 'Intermediate';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              color: Color(0xFFF9F9F9),
              elevation: 0,
              margin: EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Profile Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(
                      'View your information and preferences to personalize your recipe experience.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const Text('Basic Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _infoTile('Username', username),
            const SizedBox(height: 16),
            _infoTile('Email Address', email),
            const SizedBox(height: 24),
            const Text('Cooking Preferences',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _infoTile('Dietary Restrictions', dietary),
            const SizedBox(height: 16),
            _infoTile('Allergies', allergy),
            const SizedBox(height: 16),
            _infoTile('Cuisine Preferences', cuisine),
            const SizedBox(height: 24),
            const Text('Skill Level',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _infoTile('Cooking Skill Level', skillLevel),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
*/

/*
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // original values (could come from backend later)
  final String originalDietary = "Vegetarian";
  final String originalAllergy = "None";
  final String originalCuisine = "Italian";
  final String originalSkill = "Intermediate";

  // current selected values
  late String dietary;
  late String allergy;
  late String cuisine;
  late String skill;

  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    // Initialize values
    dietary = originalDietary;
    allergy = originalAllergy;
    cuisine = originalCuisine;
    skill = originalSkill;
  }

  void _checkChanges() {
    setState(() {
      isChanged = dietary != originalDietary ||
          allergy != originalAllergy ||
          cuisine != originalCuisine ||
          skill != originalSkill;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Profile Details",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  Text(
                    "Update your information and preferences to personalize your recipe experience.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text("Basic Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            const Text("Username"),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: "Alice Smith",
              enabled: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            const Text("Email Address"),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: "alice.smith@example.com",
              enabled: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Cooking Preferences",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            _buildDropdownField(
              label: "Dietary Restrictions",
              value: dietary,
              options: ["None", "Vegetarian", "Vegan", "Pescatarian", "Halal", "Kosher"],
              onChanged: (val) {
                dietary = val!;
                _checkChanges();
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Allergies",
              value: allergy,
              options: ["None", "Peanuts", "Gluten", "Dairy", "Shellfish", "Soy"],
              onChanged: (val) {
                allergy = val!;
                _checkChanges();
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Cuisine Preferences",
              value: cuisine,
              options: ["Italian", "Chinese", "Indian", "Mexican", "Thai", "American"],
              onChanged: (val) {
                cuisine = val!;
                _checkChanges();
              },
            ),

            const SizedBox(height: 24),
            const Text("Skill Level",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            _buildDropdownField(
              label: "Cooking Skill Level",
              value: skill,
              options: ["Beginner", "Intermediate", "Advanced", "Professional"],
              onChanged: (val) {
                skill = val!;
                _checkChanges();
              },
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isChanged
                    ? () {
                  // Handle update submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated")),
                  );
                }
                    : null,
                child: const Text("Update Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isChanged ? const Color(0xFF7F56D9) : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
*/

//new

import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // original values (could come from backend later)
  final String originalDietary = "Vegetarian";
  final String originalAllergy = "None";
  final String originalCuisine = "Italian";
  final String originalSkill = "Intermediate";

  // current selected values
  late String dietary;
  late String allergy;
  late String cuisine;
  late String skill;

  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    // Initialize values
    dietary = originalDietary;
    allergy = originalAllergy;
    cuisine = originalCuisine;
    skill = originalSkill;
  }

  void _checkChanges() {
    setState(() {
      isChanged = dietary != originalDietary ||
          allergy != originalAllergy ||
          cuisine != originalCuisine ||
          skill != originalSkill;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isChanged)
            TextButton(
              onPressed: () {
                // Handle update submission
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Profile updated successfully"),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: const Text(
                "SAVE",
                style: TextStyle(
                  color: Color(0xFF7F56D9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: const CircleAvatar(
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Basic Information
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Basic Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildReadOnlyField(
              label: "Username",
              value: "Alice Smith",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            _buildReadOnlyField(
              label: "Email Address",
              value: "alice.smith@example.com",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Cooking Preferences",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildDropdownField(
              label: "Dietary Restrictions",
              value: dietary,
              icon: Icons.restaurant,
              options: ["None", "Vegetarian", "Vegan", "Pescatarian", "Halal", "Kosher"],
              onChanged: (val) {
                setState(() {
                  dietary = val!;
                  _checkChanges();
                });
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Allergies",
              value: allergy,
              icon: Icons.health_and_safety,
              options: ["None", "Peanuts", "Gluten", "Dairy", "Shellfish", "Soy"],
              onChanged: (val) {
                setState(() {
                  allergy = val!;
                  _checkChanges();
                });
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Cuisine Preferences",
              value: cuisine,
              icon: Icons.flag,
              options: ["Italian", "Chinese", "Indian", "Mexican", "Thai", "American"],
              onChanged: (val) {
                setState(() {
                  cuisine = val!;
                  _checkChanges();
                });
              },
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Skill Level",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildDropdownField(
              label: "Cooking Skill Level",
              value: skill,
              icon: Icons.star,
              options: ["Beginner", "Intermediate", "Advanced", "Professional"],
              onChanged: (val) {
                setState(() {
                  skill = val!;
                  _checkChanges();
                });
              },
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isChanged
                    ? () {
                  // Handle update submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Profile updated successfully"),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isChanged ? const Color(0xFF7F56D9) : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "UPDATE PROFILE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
    required String label,
    required String value,
    required IconData icon,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: value,
              onChanged: onChanged,
              items: options
                  .map((opt) => DropdownMenuItem(
                value: opt,
                child: Text(
                  opt,
                  style: const TextStyle(fontSize: 16),
                ),
              ))
                  .toList(),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: Colors.grey),
              ),
              icon: const Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

//=========dynamic=========//

// new: user provider
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/models/user.dart';
import 'package:my_first_app/providers/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User _currentUser;
  late User _editedUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _currentUser = userProvider.currentUser!;
    _editedUser = User(
      id: _currentUser.id,
      fullName: _currentUser.fullName,
      email: _currentUser.email,
      dietaryRestrictions: _currentUser.dietaryRestrictions,
      allergies: _currentUser.allergies,
      cuisinePreferences: _currentUser.cuisinePreferences,
      skillLevel: _currentUser.skillLevel,
      profileImageUrl: _currentUser.profileImageUrl,
      gender: _currentUser.gender,
      dob: _currentUser.dob,
    );
  }

  bool get _hasChanges {
    return _editedUser.dietaryRestrictions != _currentUser.dietaryRestrictions ||
        _editedUser.allergies != _currentUser.allergies ||
        _editedUser.cuisinePreferences != _currentUser.cuisinePreferences ||
        _editedUser.skillLevel != _currentUser.skillLevel;
  }

  Future<void> _updateProfile() async {
    if (!_hasChanges) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUser(_editedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Profile updated successfully"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF7F56D9),
                      ),
                    )
                  : const Text(
                      "SAVE",
                      style: TextStyle(
                        color: Color(0xFF7F56D9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: _currentUser.profileImageUrl != null
                        ? CircleAvatar(
                            radius: 58,
                            backgroundImage: NetworkImage(_currentUser.profileImageUrl!),
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
                      onTap: () => _changeProfilePicture(),
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

            // Basic Information
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Basic Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildReadOnlyField(
              label: "Username",
              value: _currentUser.fullName,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            _buildReadOnlyField(
              label: "Email Address",
              value: _currentUser.email,
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Cooking Preferences",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildDropdownField(
              label: "Dietary Restrictions",
              value: _editedUser.dietaryRestrictions,
              icon: Icons.restaurant,
              options: const ["None", "Vegetarian", "Vegan", "Pescatarian", "Halal", "Kosher"],
              onChanged: (val) {
                setState(() {
                  _editedUser.dietaryRestrictions = val ?? "None";
                });
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Allergies",
              value: _editedUser.allergies,
              icon: Icons.health_and_safety,
              options: const ["None", "Peanuts", "Gluten", "Dairy", "Shellfish", "Soy"],
              onChanged: (val) {
                setState(() {
                  _editedUser.allergies = val ?? "None";
                });
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Cuisine Preferences",
              value: _editedUser.cuisinePreferences,
              icon: Icons.flag,
              options: const ["None", "Italian", "Chinese", "Indian", "Mexican", "Thai", "American"],
              onChanged: (val) {
                setState(() {
                  _editedUser.cuisinePreferences = val ?? "None";
                });
              },
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Skill Level",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildDropdownField(
              label: "Cooking Skill Level",
              value: _editedUser.skillLevel,
              icon: Icons.star,
              options: const ["Beginner", "Intermediate", "Advanced", "Professional"],
              onChanged: (val) {
                setState(() {
                  _editedUser.skillLevel = val ?? "Beginner";
                });
              },
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hasChanges && !_isLoading ? _updateProfile : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasChanges
                      ? const Color(0xFF7F56D9)
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "UPDATE PROFILE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeProfilePicture() async {
    // Implement image picking logic here
    // This would typically use image_picker package
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile picture change functionality coming soon")),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
    required String label,
    required String value,
    required IconData icon,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: value,
              onChanged: onChanged,
              items: options
                  .map((opt) => DropdownMenuItem(
                        value: opt,
                        child: Text(
                          opt,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: Colors.grey),
              ),
              icon: const Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
 */