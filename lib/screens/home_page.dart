import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ForkTune/screens/meal_planner_page.dart';
import 'package:ForkTune/screens/recipe_screen.dart';
import 'package:ForkTune/screens/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  String? _profileImageBase64;
  UserPreferences? _userPreferences;
  final TextEditingController _searchController = TextEditingController();
  int _unreadNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterRecipes();
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        return recipe.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null || token.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }

      // Load unread notification count first
      await _loadUnreadNotificationCount(token);

      // Load user profile and preferences
      final userDetailsResponse = await http.get(
        Uri.parse('https://forktune-backend-1.onrender.com/user/details'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userDetailsResponse.statusCode == 200) {
        final userDetails = json.decode(userDetailsResponse.body);
        setState(() {
          _profileImageBase64 = userDetails['profileImage'];
        });
      }

      final preferencesResponse = await http.get(
        Uri.parse('https://forktune-backend-1.onrender.com/user/preferences'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (preferencesResponse.statusCode == 200) {
        setState(() {
          _userPreferences = UserPreferences.fromJson(json.decode(preferencesResponse.body));
        });
      }

      // Load recipes
      final recipesResponse = await http.get(
        Uri.parse('https://forktune-backend-1.onrender.com/recipes/user/publish'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (recipesResponse.statusCode == 200 && recipesResponse.body.isNotEmpty) {
        final List<dynamic> data = json.decode(recipesResponse.body);
        setState(() {
          _allRecipes = data.map((json) => Recipe.fromJson(json)).toList();
          // Sort recipes by rating in descending order
          _allRecipes.sort((a, b) {
            final aRating = a.rating ?? 0.0; // Treat null as 0.0
            final bRating = b.rating ?? 0.0; // Treat null as 0.0
            return bRating.compareTo(aRating);
          });
          _filteredRecipes = List.from(_allRecipes);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Get top 10 trending recipes (highest rated)
  List<Recipe> _getTrendingRecipes() {
    return _filteredRecipes.take(10).toList();
  }

  Future<void> _loadUnreadNotificationCount(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://forktune-backend-1.onrender.com/recipes/notifications/unread-count'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _unreadNotificationCount = data['count'] ?? 0;
        });
      }
    } catch (e) {
      // If there's an error, we'll just keep the count at 0
      setState(() {
        _unreadNotificationCount = 0;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) return;

    try {
      await http.post(
        Uri.parse('https://forktune-backend-1.onrender.com/recipes/notifications/mark-all-read'),
        headers: {'Authorization': 'Bearer $token'},
      );

      setState(() {
        _unreadNotificationCount = 0;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('All notifications marked as read')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark all as read')),
      );
    }
  }

  List<Recipe> _getRecipesByMealType(String mealType) {
    return _filteredRecipes.where((recipe) => recipe.mealType == mealType).toList();
  }

  List<Recipe> _getRecommendedRecipes() {
    if (_userPreferences == null) return _filteredRecipes.toList();

    return _filteredRecipes.where((recipe) {
      if (_userPreferences!.allergies != null &&
          _userPreferences!.allergies!.isNotEmpty) {
        if (recipe.ingredients.any((ingredient) =>
            _userPreferences!.allergies!.contains(ingredient['name']))) {
          return false;
        }
      }

      if (_userPreferences!.dietaryRestrictions != null &&
          _userPreferences!.dietaryRestrictions!.isNotEmpty) {
        if (recipe.preferences?['dietaryRestrictions'] == null ||
            !recipe.preferences!['dietaryRestrictions'].any((r) =>
                _userPreferences!.dietaryRestrictions!.contains(r))) {
          return false;
        }
      }

      if (_userPreferences!.cuisinePreferences != null &&
          _userPreferences!.cuisinePreferences!.isNotEmpty) {
        if (recipe.preferences?['cuisinePreferences'] == null ||
            !recipe.preferences!['cuisinePreferences'].any((r) =>
                _userPreferences!.cuisinePreferences!.contains(r)))
        {
          return false;
        }
      }

      if (_userPreferences!.diabeticFriendly == true &&
          recipe.preferences?['diabeticFriendly'] != true) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildTrendingSection() {
    final trendingRecipes = _getTrendingRecipes();
    if (trendingRecipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Trending Now'),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: trendingRecipes.map((recipe) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildFeaturedCard(
                recipe.title,
                recipe.imageUrl,
                '${recipe.prepTime + recipe.cookTime} min',
                '${recipe.rating}',
                recipe,
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMealTypeSection(String mealType) {
    final recipes = _getRecipesByMealType(mealType);
    if (recipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(mealType),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: recipes.map((recipe) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildFeaturedCard(
                recipe.title,
                recipe.imageUrl,
                '${recipe.prepTime + recipe.cookTime} min',
                '${recipe.rating}',
                recipe,
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(
      String title,
      String imagePath,
      String time,
      String rating,
      Recipe recipe,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipe: recipe),
          ),
        );
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
              child: Image.network(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
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
            } else if (index == 2) {
              Navigator.pushNamed(context, '/saved-recipe');
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
              icon: Icon(Icons.restaurant_menu),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'My Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              activeIcon: Icon(Icons.bookmark),
              label: 'Saved',
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
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    _markAllAsRead();
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                if (_unreadNotificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _unreadNotificationCount > 9 ? '9+' : _unreadNotificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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
                child: _profileImageBase64 != null && _profileImageBase64!.isNotEmpty
                    ? CircleAvatar(
                  backgroundImage: MemoryImage(
                    base64Decode(_profileImageBase64!),
                  ),
                )
                    : const CircleAvatar(
                  backgroundColor: Color(0xFFF5F3FF),
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Color(0xFF7F56D9),
                  ),
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
      controller: _searchController,
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
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRecommendationsGrid(BuildContext context) {
    final recommendedRecipes = _getRecommendedRecipes();

    if (recommendedRecipes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No recommendations available based on your preferences',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      children: recommendedRecipes.map((recipe) =>
          _buildRecommendationCard(
            context,
            recipe.title,
            recipe.imageUrl,
            '${recipe.prepTime + recipe.cookTime} min',
            '${recipe.rating}',
            recipe,
          ),
      ).toList(),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context,
      String title,
      String imagePath,
      String time,
      String rating,
      Recipe recipe,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipe: recipe),
          ),
        );
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
              child: Image.network(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),

                  // Trending Section (new addition)
                  _buildTrendingSection(),
                  const SizedBox(height: 24),

                  // Dynamic Meal Type Sections
                  ..._mealTypes.map((mealType) => _buildMealTypeSection(mealType)).toList(),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Recommendations'),
                  const SizedBox(height: 12),
                  _buildRecommendationsGrid(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserPreferences {
  final List<String>? dietaryRestrictions;
  final List<String>? allergies;
  final List<String>? cuisinePreferences;
  final bool? diabeticFriendly;

  UserPreferences({
    this.dietaryRestrictions,
    this.allergies,
    this.cuisinePreferences,
    this.diabeticFriendly,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryRestrictions: json['dietaryRestrictions'] != null
          ? List<String>.from(json['dietaryRestrictions'])
          : null,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      cuisinePreferences: json['cuisinePreferences'] != null
          ? List<String>.from(json['cuisinePreferences'])
          : null,
      diabeticFriendly: json['diabeticFriendly'],
    );
  }
}