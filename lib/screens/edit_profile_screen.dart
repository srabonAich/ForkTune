import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController(text: 'Alice Smith');
  final _emailController = TextEditingController(text: 'alice.smith@example.com');

  String? _dietaryRestriction = 'Vegetarian';
  String? _allergy = 'None';
  String? _cuisine = 'Italian';
  String? _skillLevel = 'Intermediate';

  final List<String> dietaryOptions = ['None', 'Vegetarian', 'Vegan', 'Gluten-Free'];
  final List<String> allergyOptions = ['None', 'Peanuts', 'Dairy', 'Shellfish'];
  final List<String> cuisineOptions = ['Italian', 'Chinese', 'Mexican', 'Indian'];
  final List<String> skillLevels = ['Beginner', 'Intermediate', 'Advanced'];

  void _updateProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
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
              margin: EdgeInsets.only(bottom: 24),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Profile Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(
                      'Update your information and preferences to personalize your recipe experience.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const Text('Basic Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email Address'),
            const SizedBox(height: 24),
            const Text('Cooking Preferences',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildDropdown('Dietary Restrictions', _dietaryRestriction, dietaryOptions,
                    (value) => setState(() => _dietaryRestriction = value)),
            const SizedBox(height: 16),
            _buildDropdown('Allergies', _allergy, allergyOptions,
                    (value) => setState(() => _allergy = value)),
            const SizedBox(height: 16),
            _buildDropdown('Cuisine Preferences', _cuisine, cuisineOptions,
                    (value) => setState(() => _cuisine = value)),
            const SizedBox(height: 24),
            const Text('Skill Level',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildDropdown('Cooking Skill Level', _skillLevel, skillLevels,
                    (value) => setState(() => _skillLevel = value)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Update Profile', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: options
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
