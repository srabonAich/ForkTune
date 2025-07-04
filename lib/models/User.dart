class User {
  final String id;
  String fullName;
  String email;
  String dietaryRestrictions;
  String allergies;
  String cuisinePreferences;
  String skillLevel;
  String? profileImageUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.dietaryRestrictions,
    required this.allergies,
    required this.cuisinePreferences,
    required this.skillLevel,
    this.profileImageUrl,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      dietaryRestrictions: json['dietaryRestrictions'] ?? 'None',
      allergies: json['allergies'] ?? 'None',
      cuisinePreferences: json['cuisinePreferences'] ?? 'None',
      skillLevel: json['skillLevel'] ?? 'Beginner',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  // Convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
      'cuisinePreferences': cuisinePreferences,
      'skillLevel': skillLevel,
      'profileImageUrl': profileImageUrl,
    };
  }
}