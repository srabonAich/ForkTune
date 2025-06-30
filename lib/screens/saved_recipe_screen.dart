import 'package:flutter/material.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65, // aspect ratio
          ),
          itemCount: 6, // Static count for demo
          itemBuilder: (context, index) {
            return _buildSavedRecipeCard(
              context,
              title: _sampleRecipes[index]['title']!,
              imagePath: _sampleRecipes[index]['image']!,
              prepTime: _sampleRecipes[index]['time']!,
              rating: _sampleRecipes[index]['rating']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSavedRecipeCard(
      BuildContext context, {
        required String title,
        required String imagePath,
        required String prepTime,
        required String rating,
      }) {
    return GestureDetector(
      onTap: () {
        // Navigate to recipe details
        Navigator.pushNamed(context, '/recipe');
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        prepTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Remove from saved
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sample data for static implementation
  static const List<Map<String, String>> _sampleRecipes = [
    {
      'title': 'Spicy Thai Green Curry',
      'image': 'assets/greencurry.jpg',
      'time': '45 mins',
      'rating': '4.8',
    },
    {
      'title': 'Classic Pasta Carbonara',
      'image': 'assets/pizza.png',
      'time': '30 mins',
      'rating': '4.6',
    },
    {
      'title': 'Avocado Toast',
      'image': 'assets/avocado_toast.png',
      'time': '15 mins',
      'rating': '4.2',
    },
    {
      'title': 'Chocolate Chip Cookies',
      'image': 'assets/cake.jpg',
      'time': '25 mins',
      'rating': '4.9',
    },
    {
      'title': 'Vegetable Stir Fry',
      'image': 'assets/stirfry.jpg',
      'time': '20 mins',
      'rating': '4.3',
    },
    {
      'title': 'Berry Smoothie Bowl',
      'image': 'assets/yogurt.png',
      'time': '10 mins',
      'rating': '4.5',
    },
  ];
}