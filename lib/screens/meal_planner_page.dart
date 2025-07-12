import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ForkTune/screens/add_recipe_screen.dart';
import 'package:ForkTune/screens/edit_recipe_screen.dart';

class MealPlanningPage extends StatefulWidget {
  const MealPlanningPage({super.key});

  @override
  State<MealPlanningPage> createState() => _MealPlanningPageState();
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final String? imageId;
  final String date;
  final String mealType;
  final int prepTime;
  final int cookTime;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
  final List<Map<String, String>> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageId,
    required this.date,
    required this.mealType,
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
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageId: json['imageId'],
      date: json['date'] ?? DateTime.now().toIso8601String(),
      mealType: json['mealType'] ?? 'Other',
      prepTime: json['prepTime'] is int ? json['prepTime'] : int.tryParse(json['prepTime'].toString()) ?? 0,
      cookTime: json['cookTime'] is int ? json['cookTime'] : int.tryParse(json['cookTime'].toString()) ?? 0,
      calories: json['calories'] is int ? json['calories'] : int.tryParse(json['calories'].toString()) ?? 0,
      protein: json['protein'] is int ? json['protein'] : int.tryParse(json['protein'].toString()) ?? 0,
      fat: json['fat'] is int ? json['fat'] : int.tryParse(json['fat'].toString()) ?? 0,
      carbs: json['carbs'] is int ? json['carbs'] : int.tryParse(json['carbs'].toString()) ?? 0,
      ingredients: List<Map<String, String>>.from(
        (json['ingredients'] as List?)?.map((ing) => {
          'name': ing['name']?.toString() ?? '',
          'quantity': ing['quantity']?.toString() ?? '',
        }) ?? [],
      ),
      instructions: List<String>.from(
        (json['instructions'] as List?)?.map((inst) => inst.toString()) ?? [],
      ),
    );
  }

  String get imageUrl => imageId != null
      ? 'http://localhost:8080/recipes/image/$imageId'
      : 'assets/images/default_recipe.jpg';
}

class _MealPlanningPageState extends State<MealPlanningPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  final Color primaryColor = const Color(0xFF7F56D9);
  final Color secondaryColor = const Color(0xFFF4EBFF);
  bool _isLoading = false;
  List<Recipe> _recipes = [];
  final _secureStorage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserRecipes() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/recipes/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401) {
        await _secureStorage.delete(key: 'token');
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }

      if (response.body.isNotEmpty) {
        try {
          final List<dynamic> data = json.decode(response.body);
          if (mounted) {
            setState(() {
              _recipes = data.map((json) => Recipe.fromJson(json)).where((recipe) {
                try {
                  return _isSameDay(DateTime.parse(recipe.date), _selectedDate);
                } catch (e) {
                  return false;
                }
              }).toList();
            });
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error decoding JSON: ${e.toString()}')),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _recipes = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No recipes found for selected date')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRecipe(String recipeId) async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:8080/recipes/delete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
          body: json.encode({'id':recipeId,}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe deleted successfully')),
          );
          _loadUserRecipes();
        }
      } else {
        throw Exception('Failed to delete recipe: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting recipe: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _confirmDelete(String recipeId, String recipeTitle) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "$recipeTitle"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRecipe(recipeId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _currentMonth = DateTime.now();
                _loadUserRecipes();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserRecipes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildCalendarHeader(),
          _buildCalendarGrid(),
          Expanded(
            child: _recipes.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadUserRecipes,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _recipes.length,
                itemBuilder: (context, index) =>
                    _buildRecipeCard(_recipes[index]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(selectedDate: _selectedDate),
            ),
          );
          await _loadUserRecipes();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 8),
          _buildWeekdaysHeader(),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
              _loadUserRecipes();
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
              _loadUserRecipes();
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeekdaysHeader() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: weekdays.map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startingWeekday = firstDay.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks
      itemBuilder: (context, index) {
        final day = index - startingWeekday + 1;
        final isCurrentMonth = day > 0 && day <= lastDay.day;
        final date = isCurrentMonth
            ? DateTime(_currentMonth.year, _currentMonth.month, day)
            : null;
        final isSelected = date != null && _isSameDay(date, _selectedDate);
        final isToday = date != null && _isSameDay(date, DateTime.now());
        final hasRecipes = date != null && _recipes.any((r) =>
            _isSameDay(DateTime.parse(r.date), date));

        return GestureDetector(
          onTap: isCurrentMonth ? () {
            setState(() {
              _selectedDate = date!;
              _loadUserRecipes();
            });
          } : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : null,
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(
                color: isSelected ? Colors.white : primaryColor,
                width: 2,
              )
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  isCurrentMonth ? day.toString() : '',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isCurrentMonth
                        ? Colors.black
                        : Colors.grey[300],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasRecipes) Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showRecipeDetails(recipe);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal type and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal type and time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                recipe.mealType.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              '${recipe.prepTime + recipe.cookTime} min',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        if (recipe.description.isNotEmpty)
                          Text(
                            recipe.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nutrition info
              _buildNutritionInfo(recipe),

              const SizedBox(height: 16),

              // Ingredients preview
              if (recipe.ingredients.isNotEmpty) ...[
                const Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: recipe.ingredients.take(3).map((ingredient) {
                    return Chip(
                      label: Text(
                        '${ingredient['name']} ${ingredient['quantity']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.grey[100],
                    );
                  }).toList(),
                ),
                if (recipe.ingredients.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+ ${recipe.ingredients.length - 3} more ingredients',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 8),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: primaryColor),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRecipeScreen(recipe: recipe),
                        ),
                      );
                      await _loadUserRecipes();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(recipe.id, recipe.title),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(Recipe recipe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem(Icons.local_fire_department, '${recipe.calories} kcal'),
          _buildNutritionItem(Icons.fitness_center, '${recipe.protein} g'),
          _buildNutritionItem(Icons.grain, '${recipe.carbs} g'),
          _buildNutritionItem(Icons.water_drop, '${recipe.fat} g'),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fastfood,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No recipes for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a recipe',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Recipe header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.fastfood,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              recipe.mealType.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Prep: ${recipe.prepTime} min | Cook: ${recipe.cookTime} min',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRecipeScreen(recipe: recipe),
                          ),
                        );
                        await _loadUserRecipes();
                      },
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmDelete(recipe.id, recipe.title);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Description
                if (recipe.description.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Nutrition info
                _buildDetailedNutritionInfo(recipe),

                const SizedBox(height: 24),

                // Ingredients
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.circle,
                            size: 8, color: primaryColor),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${ingredient['name']} - ${ingredient['quantity']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),

                const SizedBox(height: 24),

                // Instructions
                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...recipe.instructions.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailedNutritionInfo(Recipe recipe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Nutrition Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailedNutritionItem(
                Icons.local_fire_department,
                'Calories',
                '${recipe.calories} kcal',
                primaryColor,
              ),
              _buildDetailedNutritionItem(
                Icons.fitness_center,
                'Protein',
                '${recipe.protein} g',
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailedNutritionItem(
                Icons.grain,
                'Carbs',
                '${recipe.carbs} g',
                Colors.orange,
              ),
              _buildDetailedNutritionItem(
                Icons.water_drop,
                'Fat',
                '${recipe.fat} g',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedNutritionItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}