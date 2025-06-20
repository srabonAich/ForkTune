// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? userProfile;
//   bool isLoading = true;
//   String error = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//   }
//
//   Future<void> fetchUserProfile() async {
//     try {
//       final data = await ApiService.fetchUserProfile('user123'); // Replace with actual user ID or auth logic
//       setState(() {
//         userProfile = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//           ? Center(child: Text('Error: $error'))
//           : userProfile == null
//           ? const Center(child: Text('No user data'))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Card(
//               color: Color(0xFFF9F9F9),
//               elevation: 0,
//               margin: EdgeInsets.only(bottom: 24),
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Your Profile Details',
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     SizedBox(height: 4),
//                     Text(
//                       'View your information and preferences to personalize your recipe experience.',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Text('Basic Information',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 12),
//             _infoTile('Username', userProfile!['username'] ?? 'N/A'),
//             const SizedBox(height: 16),
//             _infoTile('Email Address', userProfile!['email'] ?? 'N/A'),
//             const SizedBox(height: 24),
//             const Text('Cooking Preferences',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 12),
//             _infoTile('Dietary Restrictions', userProfile!['dietary'] ?? 'N/A'),
//             const SizedBox(height: 16),
//             _infoTile('Allergies', userProfile!['allergy'] ?? 'N/A'),
//             const SizedBox(height: 16),
//             _infoTile('Cuisine Preferences', userProfile!['cuisine'] ?? 'N/A'),
//             const SizedBox(height: 24),
//             const Text('Skill Level',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 12),
//             _infoTile('Cooking Skill Level', userProfile!['skillLevel'] ?? 'N/A'),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/edit-profile');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurpleAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoTile(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey)),
//         const SizedBox(height: 4),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(value, style: const TextStyle(fontSize: 16)),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
// /*import 'package:flutter/material.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Mock data (replace with dynamic data as needed)
//     const String username = 'Alice Smith';
//     const String email = 'alice.smith@example.com';
//     const String dietary = 'Vegetarian';
//     const String allergy = 'None';
//     const String cuisine = 'Italian';
//     const String skillLevel = 'Intermediate';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Card(
//               color: Color(0xFFF9F9F9),
//               elevation: 0,
//               margin: EdgeInsets.only(bottom: 24),
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Your Profile Details',
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     SizedBox(height: 4),
//                     Text(
//                       'View your information and preferences to personalize your recipe experience.',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Text('Basic Information',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 12),
//             _infoTile('Username', username),
//             const SizedBox(height: 16),
//             _infoTile('Email Address', email),
//             const SizedBox(height: 24),
//             const Text('Cooking Preferences',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 12),
//             _infoTile('Dietary Restrictions', dietary),
//             const SizedBox(height: 16),
//             _infoTile('Allergies', allergy),
//             const SizedBox(height: 16),
//             _infoTile('Cuisine Preferences', cuisine),
//             const SizedBox(height: 24),
//             const Text('Skill Level',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 12),
//             _infoTile('Cooking Skill Level', skillLevel),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/edit-profile');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurpleAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoTile(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey)),
//         const SizedBox(height: 4),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(value, style: const TextStyle(fontSize: 16)),
//         ),
//       ],
//     );
//   }
// }
// */


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
