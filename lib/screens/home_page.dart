import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Recipe>> featuredRecipes;
  late Future<List<Recipe>> recommendedRecipes;

  @override
  void initState() {
    super.initState();
    featuredRecipes = ApiService().fetchFeaturedRecipes();
    recommendedRecipes = ApiService().fetchRecommendedRecipes();
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(recipe.imageUrl, height: 100, width: 160, fit: BoxFit.cover)),
          const SizedBox(height: 8),
          Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildRecipeGridCard(Recipe recipe) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 28,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(recipe.imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover)),
          const SizedBox(height: 8),
          Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forktune'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'), // Replace with dynamic later
              radius: 16,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Featured Recipes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: FutureBuilder<List<Recipe>>(
                future: featuredRecipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  final recipes = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) => _buildRecipeCard(recipes[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('Personalized Recommendations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            FutureBuilder<List<Recipe>>(
              future: recommendedRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                final recipes = snapshot.data!;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: recipes.map((recipe) => _buildRecipeGridCard(recipe)).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Quick Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                QuickAccessItem(icon: Icons.calendar_today, label: 'Meal Plan'),
                QuickAccessItem(icon: Icons.search, label: 'Discover'),
                QuickAccessItem(icon: Icons.bookmark_border, label: 'Saved'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickAccessItem({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(child: Icon(icon, color: Colors.white), backgroundColor: Colors.deepPurple),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
