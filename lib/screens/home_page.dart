/*
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
*/

// old

/*
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           if(index == 1){
//             Navigator.pushNamed(context, '/meal-planning');
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Meal Planning'),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top Bar
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Forktune',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     Row(
//                       children:  [
//                         const Icon(Icons.notifications_none),
//                         const SizedBox(width: 12),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/profile');
//                           },
//                           child: const CircleAvatar(
//                             backgroundImage: AssetImage('assets/user.png'),
//                             radius: 16,
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Search Bar
//                 TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search for recipes...',
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 const Text('Featured Recipes',
//                     style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   height: 180,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       _buildFeaturedCard(
//                         context,
//                         'Classic Pasta Carbonara',
//                         'assets/food1.jpg',
//                       ),
//                       _buildFeaturedCard(
//                         context,
//                         'Healthy Greens',
//                         'assets/food2.jpg',
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 const Text('Personalized Recommendations',
//                     style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//                 GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     _buildRecommendationCard(
//                         context,'Fresh Salad Bowl', 'assets/salad.jpg'),
//                     _buildRecommendationCard(
//                         context,'Decadent Chocolate Cake', 'assets/cake.jpg'),
//                     _buildRecommendationCard(
//                         context,'Grilled Salmon with Asparagus', 'assets/salmon.jpg'),
//                     _buildRecommendationCard(
//                         context,'Chicken Curry with Rice', 'assets/curry.jpg'),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Quick Access
//                 const Text('Quick Access',
//                     style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildQuickAccessCard(Icons.calendar_today, 'Meal Plan'),
//                     _buildQuickAccessCard(Icons.explore, 'Discover'),
//                     _buildQuickAccessCard(Icons.bookmark_border, 'Saved'),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeaturedCard(
//       BuildContext context, String title, String imagePath) {
//     return Container(
//       width: 200,
//       margin: const EdgeInsets.only(right: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image: DecorationImage(
//           image: AssetImage(imagePath),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             left: 12,
//             bottom: 32,
//             child: Text(
//               title,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   shadows: [Shadow(blurRadius: 4, color: Colors.black)]),
//             ),
//           ),
//           Positioned(
//             left: 12,
//             bottom: 12,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/recipe');
//               },
//               child: const Text("View Recipe"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecommendationCard(BuildContext context,String title, String imagePath) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, '/recipe');
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(12)),
//               child: Image.asset(
//                 imagePath,
//                 height: 100,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
//               child: Text(title,
//                   style: const TextStyle(
//                       fontSize: 14, fontWeight: FontWeight.w600)),
//             ),
//           ],
//         ),
//       )
//     ) ;
//
//   }
//
//   Widget _buildQuickAccessCard(IconData icon, String label) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           // Navigate based on label
//         },
//         child: Container(
//           height: 80,
//           padding: const EdgeInsets.all(12),
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon),
//               const SizedBox(height: 6),
//               Text(label,
//                   style: const TextStyle(fontSize: 12),
//                   textAlign: TextAlign.center),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

 */

//new

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildSectionHeader('Featured Recipes'),
                const SizedBox(height: 12),
                _buildFeaturedRecipes(context),
                const SizedBox(height: 24),
                _buildSectionHeader('Recommendations'),
                const SizedBox(height: 12),
                _buildRecommendationsGrid(context),
                const SizedBox(height: 24),
                _buildSectionHeader('Quick Access'),
                const SizedBox(height: 12),
                _buildQuickAccessRow(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/meal-planning');
            }
          },
          selectedItemColor: const Color(0xFF6A6CFF),
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Meal Plan',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              'Forktune',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/user.png'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for recipes...',
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        suffixIcon: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF6A6CFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              color: Color(0xFF6A6CFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedRecipes(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildFeaturedCard(
            context,
            'Classic Pasta Carbonara',
            'assets/food1.jpg',
            '25 min',
            '4.8',
          ),
          _buildFeaturedCard(
            context,
            'Healthy Greens',
            'assets/food2.jpg',
            '15 min',
            '4.5',
          ),
          _buildFeaturedCard(
            context,
            'Homemade Pizza',
            'assets/pizza.png',
            '40 min',
            '4.9',
          ),
        ].map((card) => Padding(
          padding: const EdgeInsets.only(right: 16),
          child: card,
        )).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard(
      BuildContext context,
      String title,
      String imagePath,
      String time,
      String rating,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/recipe');
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      children: [
        _buildRecommendationCard(
          context,
          'Fresh Salad Bowl',
          'assets/salad.jpg',
          '15 min',
          '4.3',
        ),
        _buildRecommendationCard(
          context,
          'Decadent Chocolate Cake',
          'assets/cake.jpg',
          '60 min',
          '4.8',
        ),
        _buildRecommendationCard(
          context,
          'Grilled Salmon with Asparagus',
          'assets/salmon.jpg',
          '25 min',
          '4.7',
        ),
        _buildRecommendationCard(
          context,
          'Chicken Curry with Rice',
          'assets/curry.jpg',
          '35 min',
          '4.6',
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context,
      String title,
      String imagePath,
      String time,
      String rating,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/recipe');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 120,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickAccessCard(Icons.calendar_today, 'Meal Plan', () {
          Navigator.pushNamed(context, '/meal-planning');
        }),
        _buildQuickAccessCard(Icons.explore, 'Discover', () {
          Navigator.pushNamed(context, '/discover');
        }),
        _buildQuickAccessCard(Icons.bookmark_border, 'Saved', () {
          Navigator.pushNamed(context, '/saved');
        }),
      ],
    );
  }

  Widget _buildQuickAccessCard(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A6CFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF6A6CFF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//=========dynamic=========//
/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String featuredRecipesUrl = 'http://backend-url/api/recipes/featured';
  final String recommendationsUrl = 'http://backend-url/api/recipes/recommendations';

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> allFeaturedRecipes = [];
  List<dynamic> filteredFeaturedRecipes = [];
  List<dynamic> allRecommendations = [];
  List<dynamic> filteredRecommendations = [];

  Future<List<dynamic>> _fetchFeaturedRecipes() async {
    final response = await http.get(Uri.parse(featuredRecipesUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load featured recipes');
    }
  }

  Future<List<dynamic>> _fetchRecommendations() async {
    final response = await http.get(Uri.parse(recommendationsUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      filteredFeaturedRecipes = allFeaturedRecipes
          .where((recipe) => recipe['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredRecommendations = allRecommendations
          .where((recipe) => recipe['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchFeaturedRecipes().then((recipes) {
      setState(() {
        allFeaturedRecipes = recipes;
        filteredFeaturedRecipes = recipes;
      });
    });

    _fetchRecommendations().then((recommendations) {
      setState(() {
        allRecommendations = recommendations;
        filteredRecommendations = recommendations;
      });
    });

    _searchController.addListener(() {
      _filterSearchResults(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Forktune',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
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

                TextField(
                  controller: _searchController,
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

                const Text('Featured Recipes',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                filteredFeaturedRecipes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: filteredFeaturedRecipes.map<Widget>((recipe) {
                            return _buildFeaturedCard(
                              context,
                              recipe['title'],
                              recipe['imageUrl'],
                              recipe['description'], // Add description to pass
                              recipe['ingredients'],  // Add ingredients
                              recipe['instructions'], // Add instructions
                            );
                          }).toList(),
                        ),
                      ),
                const SizedBox(height: 24),

                const Text('Personalized Recommendations',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                filteredRecommendations.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredRecommendations.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecommendations[index];
                          return _buildRecommendationCard(
                            context,
                            recipe['title'],
                            recipe['imageUrl'],
                            recipe['description'], // Add description to pass
                            recipe['ingredients'],  // Add ingredients
                            recipe['instructions'], // Add instructions
                          );
                        },
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

  Widget _buildFeaturedCard(BuildContext context, String title, String imagePath, String description, List ingredients, List instructions) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe',
          arguments: {
            'title': title,
            'image': imagePath,
            'description': description,
            'ingredients': ingredients,
            'instructions': instructions,
          }
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imagePath),
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
                  Navigator.pushNamed(
                    context,
                    '/recipe',
                    arguments: {
                      'title': title,
                      'image': imagePath,
                      'description': description,
                      'ingredients': ingredients,
                      'instructions': instructions,
                    }
                  );
                },
                child: const Text("View Recipe"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String title, String imagePath, String description, List ingredients, List instructions) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe',
          arguments: {
            'title': title,
            'image': imagePath,
            'description': description,
            'ingredients': ingredients,
            'instructions': instructions,
          }
        );
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
              child: Image.network(
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
      ),
    );
  }

  // Quick Access Card
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



 */