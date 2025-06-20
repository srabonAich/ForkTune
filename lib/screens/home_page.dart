// import 'package:flutter/material.dart';
// import '../models/recipe.dart';
// import '../services/api_service.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late Future<List<Recipe>> featuredRecipes;
//   late Future<List<Recipe>> recommendedRecipes;
//
//   @override
//   void initState() {
//     super.initState();
//     featuredRecipes = ApiService().fetchFeaturedRecipes();
//     recommendedRecipes = ApiService().fetchRecommendedRecipes();
//   }
//
//   Widget _buildRecipeCard(Recipe recipe) {
//     return Container(
//       width: 160,
//       margin: const EdgeInsets.only(right: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(recipe.imageUrl, height: 100, width: 160, fit: BoxFit.cover)),
//           const SizedBox(height: 8),
//           Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecipeGridCard(Recipe recipe) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 2 - 28,
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(recipe.imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover)),
//           const SizedBox(height: 8),
//           Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forktune'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {},
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(context, '/profile');
//             },
//             child: const CircleAvatar(
//               backgroundImage: AssetImage('assets/profile.jpg'), // Replace with dynamic later
//               radius: 16,
//             ),
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: ListView(
//           children: [
//             const SizedBox(height: 12),
//             const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search for recipes...',
//                 prefixIcon: Icon(Icons.search),
//                 filled: true,
//                 fillColor: Color(0xFFF0F0F0),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                     borderSide: BorderSide.none),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text('Featured Recipes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             const SizedBox(height: 12),
//             SizedBox(
//               height: 180,
//               child: FutureBuilder<List<Recipe>>(
//                 future: featuredRecipes,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
//                   if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//                   final recipes = snapshot.data!;
//                   return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: recipes.length,
//                     itemBuilder: (context, index) => _buildRecipeCard(recipes[index]),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text('Personalized Recommendations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             const SizedBox(height: 12),
//             FutureBuilder<List<Recipe>>(
//               future: recommendedRecipes,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
//                 if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//                 final recipes = snapshot.data!;
//                 return Wrap(
//                   spacing: 12,
//                   runSpacing: 12,
//                   children: recipes.map((recipe) => _buildRecipeGridCard(recipe)).toList(),
//                 );
//               },
//             ),
//             const SizedBox(height: 24),
//             const Text('Quick Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: const [
//                 QuickAccessItem(icon: Icons.calendar_today, label: 'Meal Plan'),
//                 QuickAccessItem(icon: Icons.search, label: 'Discover'),
//                 QuickAccessItem(icon: Icons.bookmark_border, label: 'Saved'),
//               ],
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class QuickAccessItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//
//   const QuickAccessItem({required this.icon, required this.label, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(child: Icon(icon, color: Colors.white), backgroundColor: Colors.deepPurple),
//         const SizedBox(height: 6),
//         Text(label),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if(index == 1){
            Navigator.pushNamed(context, '/meal-planning');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Meal Planning'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Forktune',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children:  [
                        const Icon(Icons.notifications_none),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/user.png'),
                            radius: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for recipes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 24),

                // Featured Recipes
                const Text('Featured Recipes',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFeaturedCard(
                        context,
                        'Classic Pasta Carbonara',
                        'assets/food1.jpg',
                      ),
                      _buildFeaturedCard(
                        context,
                        'Healthy Greens',
                        'assets/food2.jpg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Personalized Recommendations
                const Text('Personalized Recommendations',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildRecommendationCard(
                        context,'Fresh Salad Bowl', 'assets/salad.jpg'),
                    _buildRecommendationCard(
                        context,'Decadent Chocolate Cake', 'assets/cake.jpg'),
                    _buildRecommendationCard(
                        context,'Grilled Salmon with Asparagus', 'assets/salmon.jpg'),
                    _buildRecommendationCard(
                        context,'Chicken Curry with Rice', 'assets/curry.jpg'),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Access
                const Text('Quick Access',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAccessCard(Icons.calendar_today, 'Meal Plan'),
                    _buildQuickAccessCard(Icons.explore, 'Discover'),
                    _buildQuickAccessCard(Icons.bookmark_border, 'Saved'),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(
      BuildContext context, String title, String imagePath) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            bottom: 32,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)]),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recipe');
              },
              child: const Text("View Recipe"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context,String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/recipe');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      )
    ) ;

  }

  Widget _buildQuickAccessCard(IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate based on label
        },
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
