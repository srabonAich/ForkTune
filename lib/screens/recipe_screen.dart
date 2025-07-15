import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ForkTune/screens/meal_planner_page.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isSaved = false;
  late List<bool> _ingredientChecked;
  int _servings = 2;
  final Color _primaryColor = const Color(0xFF7F56D9);

  @override
  void initState() {
    super.initState();
    _ingredientChecked = List.filled(widget.recipe.ingredients.length, false);
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    setState(() => _isLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8080/recipes/is-saved/${widget.recipe.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSaved = json.decode(response.body)['isSaved'];
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSaveRecipe() async {
    setState(() => _isLoading = true);
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.post(
        Uri.parse('http://localhost:8080/recipes/toggle-save'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': widget.recipe.id}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSaved = !_isSaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSaved ? "Recipe saved!" : "Recipe unsaved"),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update saved status")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: _isLoading
                ? const CircularProgressIndicator()
                : Icon(
              _isSaved ? Icons.favorite : Icons.favorite_border,
              color: _isSaved ? Colors.red : null,
            ),
            onPressed: _toggleSaveRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Stack(
              children: [
                ClipRRect(
                  child: Image.network(
                    widget.recipe.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.recipe.prepTime + widget.recipe.cookTime} mins",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Recipe Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text("4.8"), // Static rating for now
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags
                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(widget.recipe.mealType),
                      if (widget.recipe.preferences?['diabeticFriendly'] == true)
                        _buildTag("Diabetic Friendly"),
                      if (widget.recipe.preferences?['cuisinePreferences'] != null &&
                          widget.recipe.preferences!['cuisinePreferences'].isNotEmpty)
                        ...widget.recipe.preferences!['cuisinePreferences']
                            .take(2) // Limit to 2 cuisine types to avoid overflow
                            .map((cuisine) => _buildTag(cuisine))
                            .toList(),
                    ],
                  ),
                  const SizedBox(height: 16),


                  const SizedBox(height: 16),

                  // Description
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.recipe.description),
                  const SizedBox(height: 24),

                  // Ingredients
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ingredients",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._buildIngredientList(),
                  const SizedBox(height: 24),

                  // Instructions
                  Text(
                    "Instructions",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._buildInstructions(),
                  const SizedBox(height: 24),

                  // Nutrition
                  Text(
                    "Nutrition Facts (per serving)",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Start cooking action
      //     Navigator.pushNamed(context, '/cooking-mode', arguments: widget.recipe);
      //   },
      //   icon: const Icon(Icons.restaurant_menu),
      //   label: const Text("Start Cooking"),
      //   backgroundColor: _primaryColor,
      // ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  List<Widget> _buildIngredientList() {
    return List.generate(widget.recipe.ingredients.length, (i) {
      final ingredient = widget.recipe.ingredients[i];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: _ingredientChecked[i],
              onChanged: (value) {
                setState(() {
                  _ingredientChecked[i] = value!;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: _primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                ingredient['name'] ?? '',
                style: TextStyle(
                  decoration: _ingredientChecked[i]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            Text(
              ingredient['quantity'] ?? '',
              style: TextStyle(
                color: Colors.grey[600],
                decoration: _ingredientChecked[i]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildInstructions() {
    return List.generate(widget.recipe.instructions.length, (i) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${i + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.recipe.instructions[i],
                style: const TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNutritionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNutritionRow("Calories", "${widget.recipe.calories} kcal",
                Icons.local_fire_department),
            const Divider(),
            _buildNutritionRow(
                "Protein", "${widget.recipe.protein}g", Icons.fitness_center),
            const Divider(),
            _buildNutritionRow("Fat", "${widget.recipe.fat}g", Icons.oil_barrel),
            const Divider(),
            _buildNutritionRow(
                "Carbs", "${widget.recipe.carbs}g", Icons.restaurant_menu),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: _primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}