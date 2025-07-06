// new

class User {
  final String id;
  final DateTime createdAt;
  DateTime? updatedAt;
  String fullName;
  String email;
  String dietaryRestrictions;
  String allergies;
  String cuisinePreferences;
  String skillLevel;
  String? profileImageUrl;
  String? gender;
  DateTime? dob;
  List<String>? favoriteRecipes;
  List<String>? savedRecipes;
  bool? emailVerified;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.dietaryRestrictions,
    required this.allergies,
    required this.cuisinePreferences,
    required this.skillLevel,
    this.profileImageUrl,
    this.gender,
    this.dob,
    this.favoriteRecipes,
    this.savedRecipes,
    this.emailVerified,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      dietaryRestrictions: json['dietaryRestrictions'] ?? 'None',
      allergies: json['allergies'] ?? 'None',
      cuisinePreferences: json['cuisinePreferences'] ?? 'None',
      skillLevel: json['skillLevel'] ?? 'Beginner',
      profileImageUrl: json['profileImageUrl'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      favoriteRecipes: json['favoriteRecipes'] != null
          ? List<String>.from(json['favoriteRecipes'])
          : null,
      savedRecipes: json['savedRecipes'] != null
          ? List<String>.from(json['savedRecipes'])
          : null,
      emailVerified: json['emailVerified'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

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
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'favoriteRecipes': favoriteRecipes,
      'savedRecipes': savedRecipes,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? fullName,
    String? email,
    String? dietaryRestrictions,
    String? allergies,
    String? cuisinePreferences,
    String? skillLevel,
    String? profileImageUrl,
    String? gender,
    DateTime? dob,
    List<String>? favoriteRecipes,
    List<String>? savedRecipes,
    bool? emailVerified,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergies: allergies ?? this.allergies,
      cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
      skillLevel: skillLevel ?? this.skillLevel,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}


// old
/*
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
*/
