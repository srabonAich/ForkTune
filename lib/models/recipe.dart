class Recipe {
  final String id;
  final String title;
  final String description;
  final String image;
  final double rating;
  final int reviewCount;
  final int prepTime;
  final int cookTime;
  final String calories;
  final String protein;
  final String fat;
  final String carbs;
  final List<List<String>> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.prepTime,
    required this.cookTime,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? 'assets/images/default_recipe.png',
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      prepTime: json['prepTime'] ?? 0,
      cookTime: json['cookTime'] ?? 0,
      calories: json['calories'] ?? '',
      protein: json['protein'] ?? '',
      fat: json['fat'] ?? '',
      carbs: json['carbs'] ?? '',
      ingredients: json['ingredients'] != null
          ? List<List<String>>.from(
          json['ingredients'].map((i) => List<String>.from(i)))
          : [],
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }
}